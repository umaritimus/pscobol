Function Install-MicroFocusVisualCobol {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Source Directory"
        )]
        [String] ${Source},
        [Parameter(
            Mandatory = $True,
            HelpMessage = "InstallDir Directory"
        )]
        [String] ${InstallDir}
    )

    Begin {
        ${ComputerName} = (Get-WmiObject Win32_Computersystem).Name.toLower()
    }

    Process {
        Try {
            ${LogFile} = "${Env:Temp}\$((Split-Path -Path $Source -Leaf).Replace('exe','log'))"

            If (Test-Path -Path "${LogFile}") {
                Remove-Item -Path "${LogFile}" -Force
            }

            ${ExitCode} = (
                Start-Process `
                    -FilePath "${Source}" `
                    -ArgumentList ( "/quiet", "/norestart", "/install InstallFolder=${InstallDir}", "/log ${LogFile}" ) `
                    -Wait `
                    -NoNewWindow `
                    -PassThru
            ).ExitCode

            If (${ExitCode} -eq 0) {
                If (Get-Content -Path "${LogFile}" | Select-String "Apply complete, result: 0x0" -Quiet) {
                    Exit 0
                } Else {
                    Exit 1
                }
            }

            Exit ${ExitCode}
        } Catch {
            Throw "Installation of 'Micro Focus Visual COBOL' failed"
        }
    }
}

Function Uninstall-MicroFocusVisualCobol {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Source Directory"
        )]
        [String] ${Source},
        [Parameter(
            Mandatory = $True,
            HelpMessage = "InstallDir Directory"
        )]
        [String] ${InstallDir}
    )

    Begin {
        ${ComputerName} = (Get-WmiObject Win32_Computersystem).Name.toLower()
    }

    Process {
        Try {
            ${LogFile} = "${Env:Temp}\uninstall-$((Split-Path -Path $Source -Leaf).Replace('exe','log'))"

            If (Test-Path -Path "${LogFile}") {
                Remove-Item -Path "${LogFile}" -Force
            }

            ${ExitCode} = (
                Start-Process `
                    -FilePath "${Source}" `
                    -ArgumentList ( "/quiet", "/norestart", "/uninstall InstallFolder=${InstallDir}", "/log ${LogFile}" ) `
                    -Wait `
                    -NoNewWindow `
                    -PassThru
            ).ExitCode

            If (${ExitCode} -eq 0) {
                If (-not (Get-Content -Path "${LogFile}" | Select-String "Apply complete, result: 0x0" -Quiet)) {
                    Exit 1
                }
            } Else {
                Exit 1
            }

            Exit ${ExitCode}
        } Catch {
            Throw "Uninstallation of 'Micro Focus Visual COBOL' failed"
        }
    }
}

Function Set-MicroFocusVisualCobolLicense {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Location of 'Sentinel RMS License Manager'"
        )]
        [String] ${CesAdminToolPath},
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Source Directory for MicroFocus Visual Cobol license file"
        )]
        [String] ${Source}
    )

    Begin {
        ${ComputerName} = (Get-WmiObject Win32_Computersystem).Name.toLower()
    }

    Process {
        Try {
            ${LogFile} = "${Env:Temp}\vcbt_license.log"

            If (Test-Path -Path "${LogFile}") {
                Remove-Item -Path "${LogFile}" -Force
            }

            ${InstallExitCode} = (
                Start-Process `
                    -FilePath "${CesAdminToolPath}" `
                    -ArgumentList ( "-term install", "-f ${Source}" ) `
                    -Wait `
                    -NoNewWindow `
                    -PassThru
            ).ExitCode

            If (${InstallExitCode} -eq 0) {

                ${ListExitCode} = (
                    Start-Process `
                        -FilePath "${CesAdminToolPath}" `
                        -ArgumentList ( "-term list" ) `
                        -Wait `
                        -NoNewWindow `
                        -RedirectStandardOutput "${LogFile}" `
                        -PassThru
                ).ExitCode
                
                If ((${ListExitCode} -eq 0) -and (Select-String -Path "${LogFile}" -Pattern "Feature" -Quiet -ErrorAction Stop)) {
                    Exit 0
                }
            }

            Exit 1
        } Catch {
            Throw "Licensing of 'Micro Focus Visual COBOL' failed"
        }
    }
}

Function Invoke-CobolCompile {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Location of 'Micro Focus Visual Cobol'"
        )]
        [String] ${cobroot},
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Location of 'PeopleSoft PeopleTools Home (PS_HOME)'"
        )]
        [String] ${ps_home} = ${Env:PS_HOME},
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Location of 'PeopleSoft Application Home (PS_APP_HOME)'"
        )]
        [String] ${ps_app_home} = ${Env:PS_APP_HOME},
        [Parameter(
            Mandatory = $False,
            HelpMessage = "Location of 'PeopleSoft Custom Home (PS_CUST_HOME)'"
        )]
        [String] ${ps_cust_home} = ${Env:PS_CUST_HOME},
        [Parameter(
            Mandatory = $True,
            HelpMessage = "Compile Target.  One of PS_HOME|PS_CUST_HOME|PS_APP_HOME"
        )]
        [String] ${Target}
    )

    Begin {
        ${ComputerName} = (Get-WmiObject Win32_Computersystem).Name.toLower()
    }

    Process {
        Try {
            ${Env:COBROOT} = "${cobroot}"

            # If PS_HOME, PS_APP_HOME and PS_CUST_HOME passed as optional parameters,
            # assume that these are the targets, so overwrite local environment
            # variables with their parameter equivalents.
            If (${ps_home} -ne ${Env:PS_HOME}) {
                ${Env:PS_HOME} = ${ps_home}
            }

            If (${ps_app_home} -ne ${Env:PS_APP_HOME}) {
                ${Env:PS_APP_HOME} = ${ps_app_home}
            }

            If (${ps_cust_home} -ne ${Env:PS_CUST_HOME}) {
                ${Env:PS_CUST_HOME} = ${ps_cust_home}
            }

            ${LogFile} = "$($Env:TEMP)\compile.log"
            ${CompileDrive} = "$(Split-Path ${Env:TEMP} -Qualifier)"
            ${CompilePath} = "$(Split-Path ${Env:TEMP} -NoQualifier)\compile"
            ${SuccessString} = 'ALL the files compiled and linked successfully.'

            ${ExitCode} = (
                Start-Process `
                    -FilePath "cmd.exe" `
                    -ArgumentList ("/c cblbld.bat ${CompileDrive} ${CompilePath} ${Target}") `
                    -WorkingDirectory "${Env:PS_HOME}\setup" `
                    -Wait `
                    -NoNewWindow `
                    -RedirectStandardOutput "${LogFile}" `
                    -PassThru
            ).ExitCode
            
            If ((${ExitCode} -eq 0) -and (Select-String -Path "${LogFile}" -Pattern ${SuccessString} -Quiet -ErrorAction Stop)) {
                Exit 0
            }
            Exit 1
        } Catch {
            Exit 1
        }

        Exit 1
    }
}