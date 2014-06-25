class graphite (
  $carbon_settings        = {},
  $storage_schemas        = {},
  $storage_aggregation    = {},
  $aggregation_rules      = {},
  $web_package_name       = $::graphite::params::web_package_name,
  $web_package_ensure     = $::graphite::params::web_package_ensure,
  $carbon_package_name    = $::graphite::params::carbon_package_name,
  $carbon_package_ensure  = $::graphite::params::carbon_package_ensure,
  $carbon_service_ensure  = $::graphite::params::carbon_service_ensure,
  $whisper_package_name   = $::graphite::params::whisper_package_name,
  $whisper_package_ensure = $::graphite::params::whisper_package_ensure,
  $whisper_storage_dir    = $::graphite::params::whisper_storage_dir,
  $web_server_name        = $::fqdn,
  $web_server             = 'apache',
  $web_port               = '80',
  $django_secret_key      = 'CHANGE-ME',
  $django_time_zone       = 'America/Chicago',
  $django_debug           = 'False',
  $db_engine              = 'django.db.backends.sqlite3',
  $db_name                = '/var/lib/graphite/graphite.db',
  $db_user                = '',
  $db_password            = '',
  $db_host                = '',
  $db_port                = '',
  $memcache_servers       = [],
  $cluster                = false,
  $cluster_fetch_timeout  = 6,
  $cluster_find_timeout   = '2.5',
  $cluster_retry_delay    = 60,
  $cluster_cache_duration = 300,
) inherits graphite::params {
  class{'graphite::install': } ->
  class{'graphite::config': } ~>
  class{'graphite::service': } ->
  Class['graphite']
}
