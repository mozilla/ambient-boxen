# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include firefox::aurora

  file { "${boxen::config::home}/profile":
    ensure => 'directory',
    alias  => 'copy_profile',
    source => "${boxen::config::repodir}/modules/ambient_mozilla/files/profile"
  }

  exec { 'start_firefox':
    command =>
    "/Applications/FirefoxAurora.app/Contents/MacOSX/firefox \
      -profile ${boxen::config::home}/profile",
    after   => 'copy_profile' 
  }

}
