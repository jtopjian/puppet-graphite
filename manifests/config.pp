class graphite::config {

  include graphite::params

  # Bring some variables into local scope
  $web_port         = $::graphite::web_port
  $memcache_servers = $::graphite::memcache_servers

  # Configure the Django local_settings.py file
  file { '/etc/graphite/local_settings.py':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('graphite/local_settings.py.erb'),
    notify  => Exec['graphite syncdb']
  }

  # Run the standard Django syncdb
  exec { 'graphite syncdb':
    command     => '/usr/bin/graphite-manage syncdb --noinput',
    refreshonly => true,
    require     => File['/etc/graphite/local_settings.py'],
  }

  # Change the db ownership if using sqlite3
  if $::graphite::db_engine == 'django.db.backends.sqlite3' {
    file { '/var/lib/graphite/graphite.db':
      owner     => $::graphite::params::graphite_user,
      group     => $::graphite::params::graphite_group,
      mode      => '0664',
      subscribe => Exec['graphite syncdb'],
    }
  }

  # Iterate over a nested hash of key/value settings for carbon.conf
  $::graphite::carbon_settings.each |$section, $settings| {
    $settings.each |$setting, $value| {
      ini_setting { "${section}: ${setting} = ${value}":
        ensure  => present,
        path    => $::graphite::params::carbon_conf,
        section => $section,
        setting => upcase($setting),
        value   => $value,
      }
    }
  }

  # Iterate over a nested hash of key/value settings for storage-schemas.conf
  $::graphite::storage_schemas.each |$section, $settings| {
    $settings.each |$setting, $value| {
      ini_setting { "${section}: ${setting} = ${value}":
        ensure  => present,
        path    => $::graphite::params::storage_schemas_conf,
        section => $section,
        setting => $setting,
        value   => $value,
      }
    }
  }

  # Iterate over a nested hash of key/value settings for aggregation-rules.conf
  $::graphite::aggregation_rules.each |$section, $settings| {
    $settings.each |$setting, $value| {
      ini_setting { "${section}: ${setting} = ${value}":
        ensure  => present,
        path    => $::graphite::params::aggregation_rules_conf,
        section => $section,
        setting => $setting,
        value   => $value,
      }
    }
  }

  # Configure the chosen web server
  case $::graphite::web_server {
    'apache': {
      apache::vhost { 'graphite':
        servername                  => $::graphite::web_server_name,
        port                        => $web_port,
        default_vhost               => true,
        priority                    => '10',
        docroot                     => $::graphite::params::apache_docroot,
        wsgi_daemon_process         => $::graphite::params::graphite_user,
        wsgi_process_group          => $::graphite::params::graphite_user,
        wsgi_script_aliases         => { '/' => $::graphite::params::apache_wsgi_path },
        wsgi_daemon_process_options => {
          processes          => 5,
          threads            => 5,
          display-name       => '%{GROUP}',
          inactivity-timeout => 120,
          user               => $::graphite::params::graphite_user,
          group              => $::graphite::params::graphite_group,
        }
      }
    }
  }

}
