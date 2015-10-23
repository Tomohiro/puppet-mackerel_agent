# == Class: mackerel_agent::install
#
class mackerel_agent::install(
  $ensure = present
) {
  $gpgkey_url = 'https://mackerel.io/assets/files/GPG-KEY-mackerel'

  case $::osfamily {
    'RedHat': {
      yumrepo { 'mackerel':
        name     => 'mackerel',
        baseurl  => "http://yum.mackerel.io/centos/${::architecture}",
        descr    => 'mackerel-agent',
        enabled  => 1,
        gpgkey   => $gpgkey_url,
        gpgcheck => 1
      }
    }
    'Debian': {
      apt::key { 'mackerel':
        key        => 'C2B48821',
        key_source => $gpgkey_url
      }
      apt::source { 'mackerel':
        location    => 'http://apt.mackerel.io/debian/',
        release     => 'mackerel',
        repos       => 'contrib',
        include_src => false
      }
    }
    default: {
      # Do nothing
    }
  }

  package { 'mackerel-agent':
    ensure => $ensure
  }

  file {
    '/etc/mackerel-agent':
      ensure => directory,

    '/etc/mackerel-agent/conf.d':
      ensure => directory,
  }
}
