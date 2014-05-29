# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include firefox::aurora
  include iterm2

  include osx::software_update

  exec { "create_firefox_profile":
    command => "/Applications/FirefoxAurora.app/Contents/MacOS/firefox -CreateProfile \"ambient_mozilla ${boxen::config::home}/firefox_profile\"",
    creates => "${boxen::config::home}/firefox_profile",
    require => Package['Firefox-Aurora']
  }

  file { "${boxen::config::home}/firefox_profile/user.js":
    source  => "${boxen::config::repodir}/modules/ambient_mozilla/files/FirefoxPrefs.js",
    require => Exec["create_firefox_profile"],
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
