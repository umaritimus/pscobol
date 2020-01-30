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