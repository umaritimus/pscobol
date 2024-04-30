# @summary Compiles PeopleSoft Cobol sources
#   Compiles PeopleSoft Cobol sources
#
# @param ensure
#   Standard puppet ensure, e.g. present, absent, installed, etc
#
# @param installdir
#   Location where Microfocus Visual Cobol is installed
#
# @param ps_home
#   Location of Peoplesoft PS_HOME directory
#
# @param targets
#   Array of Names of Targets to compile, could be none or few of
#   ('PS_HOME'|'PS_APP_HOME'|'PS_CUST_HOME')
#
# @example
#   include pscobol::peoplesoft
class pscobol::peoplesoft (
  Enum['present','absent']        $ensure            = $pscobol::params::ensure,
  Optional[String]                $installdir        = $pscobol::params::installdir,
  Optional[String]                $ps_home           = $pscobol::params::ps_home,
  Optional[String]                $ps_app_home       = $pscobol::params::ps_app_home,
  Optional[String]                $ps_cust_home      = $pscobol::params::ps_cust_home,
  Optional[Array[String[1]]]      $targets           = $pscobol::params::targets,
) inherits pscobol::params {
  debug ("Ensure 'pscobol::peoplesoft' to be '${ensure}' in '${targets}'")

  class { 'pscobol::peoplesoft::compile':
    ensure       => $ensure,
    installdir   => $installdir,
    ps_home      => $ps_home,
    ps_app_home  => $ps_app_home,
    ps_cust_home => $ps_cust_home,
    targets      => $targets,
  }

  contain 'pscobol::peoplesoft::compile'
}
