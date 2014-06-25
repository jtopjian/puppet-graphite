class graphite::params {

  # Package and Service parameters
  case $::osfamily {
    'Debian': {
      $web_package_name        = 'graphite-web'
      $web_package_ensure      = 'latest'

      $carbon_package_name     = 'graphite-carbon'
      $carbon_package_ensure   = 'latest'
      $carbon_service_name     = 'carbon-cache'
      $carbon_service_ensure   = 'running'

      $whisper_package_name    = 'python-whisper'
      $whisper_package_ensure  = 'latest'

      $carbon_conf             = '/etc/carbon/carbon.conf'
      $storage_schemas_conf    = '/etc/carbon/storage-schemas.conf'
      $aggregation_rules_conf  = '/etc/carbon/aggregation-rules.conf'

      $graphite_user           = '_graphite'
      $graphite_group          = '_graphite'

      $apache_docroot          = '/usr/share/graphite-web/'
      $apache_wsgi_path        = "${apache_docroot}/graphite.wsgi"
      $apache_static_path      = "${apache_docroot}/static/"
    }
  }

}
