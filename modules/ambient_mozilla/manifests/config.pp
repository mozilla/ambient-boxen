#Config for ambient_mozilla 
#
class ambient_mozilla::config {
  require boxen::config

  $profiledir = "${boxen::config::datadir}/firefox_profile"
}
