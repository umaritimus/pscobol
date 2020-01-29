# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include pscobol::microfocus::install
class pscobol::microfocus::install  (
  Enum['present','absent'] $ensure = 'absent',
  String[1] $installdir = 'C:/Program Files (x86)/Micro Focus/Visual COBOL Build Tools',
  String[1] $source = '//share/visualcobol/vcbt_40.exe',
) {
  debug ("Ensure 'pscobol::microfocus::install' to be '${ensure}' using '${source}' on '${installdir}'")
}
