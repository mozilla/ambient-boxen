# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include ambient_mozilla::config

  include firefox::aurora
  include iterm2::dev

  include osx::software_update

  exec { "create-firefox-profile":
    command => "/Applications/FirefoxAurora.app/Contents/MacOS/firefox -CreateProfile \"ambient_mozilla ${ambient_mozilla::config::profiledir}\"",
    creates => "${ambient_mozilla::config::profiledir}",
    require => Package['Firefox-Aurora'],
  }

  file { "${ambient_mozilla::config::profiledir}/user.js":
    source  => "${boxen::config::repodir}/modules/ambient_mozilla/files/FirefoxPrefs.js",
    notify  => Service['dev.firefox'],
    force   => true,
  }

  file { "/Library/LaunchDaemons/dev.firefox.plist":
    content => template("ambient_mozilla/dev.firefox.plist.erb"),
    notify  => Service['dev.firefox'],
    group   => 'wheel',
    owner   => 'root',
  }

  service { "dev.firefox":
    ensure  => running,
    require => [Package['Firefox-Aurora'], Exec['create-firefox-profile']],
  }

  file { "/Users/airmozilla/Library/Application Support/Firefox/profiles.ini":
    content =>  template("ambient_mozilla/profiles.ini.erb"),
    group   => 'wheel',
    owner   => 'root',
    notify  => Service["dev.firefox"],
  }

  include brewcask

  package { 'consul': provider => 'brewcask' }

  service { "dev.consul":
    ensure  => running,
    require => Package['consul'],
  }

  file { "/Library/LaunchDaemons/dev.consul.plist":
    content => template("ambient_mozilla/dev.consul.plist.erb"),
    notify  => Service['dev.consul'],
    group   => 'wheel',
    owner   => 'root',
  }

  file { "${boxen::config::configdir}/consul":
    ensure  => directory,
    source  => "${boxen::config::repodir}/modules/ambient_mozilla/files/consul/",
    recurse => true,
  }
}
