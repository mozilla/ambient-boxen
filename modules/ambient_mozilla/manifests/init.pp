# Public: set up a machine to be an ambient mozilla display
class ambient_mozilla{
  include firefox::aurora

  exec { '/Applications/FirefoxAurora.app/Contents/MacOSX/firefox -profile /opt/boxen/repo/modules/ambient_mozilla/files/firefox_profile'}

}
