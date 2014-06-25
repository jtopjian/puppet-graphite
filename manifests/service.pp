class graphite::service {

  include graphite::params

  if $::graphite::carbon_service_ensure == 'running' {
    $enable = true
  } else {
    $enable = false
  }

  service { 'carbon':
    name       => $::graphite::params::carbon_service_name,
    ensure     => $::graphite::carbon_service_ensure,
    enable     => $enable,
    hasstatus  => true,
    hasrestart => true,
  }

  case $::lsbdistid {
    'Ubuntu': {
      file_line { '/etc/default/graphite-carbon enable':
        path   => '/etc/default/graphite-carbon',
        match  => '^CARBON_CACHE_ENABLED=',
        line   => 'CARBON_CACHE_ENABLED=true',
        notify => Service['carbon'],
      }
    }
  }

}
