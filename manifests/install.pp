class graphite::install {

  include graphite::params

  package { 'graphite-web':
    name   => $::graphite::web_package_name,
    ensure => $::graphite::web_package_ensure,
  }

  package { 'graphite-carbon':
    name   => $::graphite::carbon_package_name,
    ensure => $::graphite::carbon_package_ensure,
  }

  package { 'python-whisper':
    name   => $::graphite::whisper_package_name,
    ensure => $::graphite::whisper_package_ensure,
  }

}
