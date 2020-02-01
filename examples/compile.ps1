${Env:PS_HOME} = 'd:\oracle\product\psft\pt\8.57.12'
${Env:PS_APP_HOME} = 'd:\oracle\product\psft\hr\HR92U033'
puppet apply `
    --modulepath 'C:\ProgramData\PuppetLabs\code\environments\production\modules' `
    --debug `
    --trace `
    --verbose `
    -e "class { 'pscobol' : ensure => 'present', targets => ['PS_HOME','PS_APP_HOME'] , installdir => 'd:/cobol' , }"
