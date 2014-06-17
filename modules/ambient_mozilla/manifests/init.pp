# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include ambient_mozilla::config

  include firefox::aurora
  include iterm2::dev

  include osx::software_update

  exec { "create_firefox_profile":
    command => "/Applications/FirefoxAurora.app/Contents/MacOS/firefox -CreateProfile \"ambient_mozilla ${ambient_mozilla::config::profiledir}\"",
    creates => "${ambient_mozilla::config::profiledir}",
    require => Package['Firefox-Aurora']
  }

  file { "${ambient_mozilla::config::profiledir}/prefs.js":
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

  file { "/Users/airmozilla/Library/Application Support/Firefox/profiles.ini":
    content =>  template("ambient_mozilla/profiles.ini.erb"),
    group   => 'wheel',
    owner   => 'root',
    notify  => Service["dev.firefox"],
  }

}
