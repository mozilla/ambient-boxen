# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include firefox::aurora

  file { "${boxen::config::home}/profile":
    ensure => 'directory',
  }

  file { "${boxen::config::home}/profile/user.js":
    source  => "${boxen::config::repodir}/modules/ambient_mozilla/files/FirefoxPrefs.js",
    require => File["${boxen::config::home}/profile"],
    notify  => Service['dev.firefox'],
    force   => true
  }

  file { "/Library/LaunchDaemons/dev.firefox.plist":
    content => template("ambient_mozilla/dev.firefox.plist.erb"),
    notify  => Service['dev.firefox'],
    group   => 'wheel',
    owner   => 'root'
  }

  service { "dev.firefox":
    ensure  => running,
    require => Package['Firefox-Aurora']
  }

}
