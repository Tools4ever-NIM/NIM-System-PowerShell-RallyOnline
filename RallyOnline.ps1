#
# RallyOnline.ps1 - Rally Online
#


$Log_MaskableKeys = @(
    'Password',
    "proxy_password",
    "client_secret"
)

#"Entry, UID, Date, Contact Emailed,Email Address,First Name,Last Name,Position\/Role,Code of Conduct 
$Properties = @{
    ExternalContractors = @(
        @{ name = 'UID';           										options = @('default','key')}    
        @{ name = 'Entry';           									options = @('default')}
        @{ name = 'Date';           									options = @('default')}
        @{ name = 'Contact Emailed';           							options = @('default')}
        @{ name = 'Email Address';           						    options = @('default')}
        @{ name = 'First Name';           						    options = @('default')}
        @{ name = 'Last Name';           						        options = @('default')}
        @{ name = 'Position/Role';           							options = @('default')}
        @{ name = 'Code of Conduct';           						options = @('default')}
		@{ name = 'Date of Birth';           						options = @('default')}
        @{ name = 'Personal Email Address';           						options = @('default')}
    )
    NewEmployees = @(
        @{ name = 'UID';           										options = @('default','key')}    
        @{ name = 'Entry';           									options = @('default')}
        @{ name = 'Date';           									options = @('default')}
        @{ name = 'Contact Emailed';           							options = @('default')}
        @{ name = 'Have you ever worked for Wolf Creek before?';      options = @('default')}
        @{ name = 'Legal First Name';           						options = @('default')}
        @{ name = 'Legal Last Name';           						options = @('default')}
        @{ name = 'Preferred First Name';           					options = @('default')}
        @{ name = 'Preferred Last Name';           					options = @('default')}
        @{ name = 'Home Phone';           								options = @('default')}
        @{ name = 'Cell Phone';           								options = @('default')}
        @{ name = 'Address';           								options = @('default')}
        @{ name = 'City/Town';           								options = @('default')}
        @{ name = 'Postal Code';           							options = @('default')}
        @{ name = 'Position/Role';           							options = @('default')}
        @{ name = 'Primary Work Location';           					options = @('default')}
        @{ name = 'Additional Schools';           						options = @('default')}
        @{ name = 'Emergency Contact Name';           					options = @('default')}
        @{ name = 'Emergency Contact Relationship';           			options = @('default')}
        @{ name = 'Emergency Contact Phone';           					options = @('default')}
        @{ name = 'Emergency Contact Phone 2';           				options = @('default')}
        @{ name = 'Additional Emergency Info';           				options = @('default')}
        @{ name = 'Code of Conduct';           						options = @('default')}
		@{ name = 'Date of Birth';           						options = @('default')}
        @{ name = 'Personal Email Address';           						options = @('default')}
    )
}

#
# System functions
#
function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    Log verbose "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"

    if ($Connection) {
        @(
            @{
                name = 'hostname'
                type = 'textbox'
                label = 'Hostname'
                description = 'Hostname for Web Services'
                value = 'api.rallycms.ca'
            }
            @{
                name = 'client_secret'
                type = 'textbox'
                password = $true
                label = 'Client Secret'
                description = 'Authentication: Client Secret'
                value = ''
            }
            @{
                name = 'use_proxy'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requests'
                value = $false # Default value of checkbox item
            }
            @{
                name = 'proxy_address'
                type = 'textbox'
                label = 'Proxy Address'
                description = 'Address of the proxy server'
                value = 'http://127.0.0.1:8888'
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'use_proxy_credentials'
                type = 'checkbox'
                label = 'Use Proxy Credentials'
                description = 'Use credentials for proxy'
                value = $false
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'proxy_username'
                type = 'textbox'
                label = 'Proxy Username'
                label_indent = $true
                description = 'Username account'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'proxy_password'
                type = 'textbox'
                password = $true
                label = 'Proxy Password'
                label_indent = $true
                description = 'User account password'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                description = ''
                value = 1
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                description = ''
                value = 1
            }
        )
    }

    if ($TestConnection) {
        
    }

    if ($Configuration) {
        @()
    }

    Log verbose "Done"
}

function Idm-OnUnload {
}

#
# Object CRUD functions
#

function Idm-ExternalContractorsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'ExternalContractors'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            #Retrieve Report
            $uri = "https://$($system_params.hostname)/rally_api_v1/get/form_builder_results"
            
            $headers = @{
                "Authorization" = "Bearer $($system_params.client_secret)"
            }

            try {
                $splat = @{
                    Method = "GET"
                    Uri = $uri
                    Headers = $headers
                    Body = @{
                        key = $system_params.client_secret
                        form_id = 93
                    }
                }

                if($system_params.use_proxy)
                {
                    Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    
                    $splat["Proxy"] = $system_params.proxy_address

                    if($system_params.use_proxy_credentials)
                    {
                        $splat["proxyCredential"] = New-Object System.Management.Automation.PSCredential ($system_params.proxy_username, (ConvertTo-SecureString $system_params.proxy_password -AsPlainText -Force) )
                    }
                }
                
                $response = Invoke-RestMethod @splat -ErrorAction Stop
                
                $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                Log verbose "Total Results to process: $($response.data.count)"
                foreach($rowItem in $response.data) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
                        if(!$properties.contains($prop.Name)) { 
							log warn "$($prop.Name) not configured, skipping"
							continue
						}
						if($prop.Name -eq 'Date') {
							$row.($prop.Name) = try { ([datetime]::ParseExact($prop.Value, "MMM d, yyyy h:mmtt", $null)).ToString("yyyy-MM-dd HH:mm") } catch{}
						} else {
							$row.($prop.Name) = $prop.Value
						}
					}

                    $row
                }
                
            }
            catch [System.Net.WebException] {
                $message = "Error : $($_)"
                Log error $message
                Write-Error $_
            }
            catch {
                $message = "Error : $($_)"
                Log error $message
                Write-Error $_
            }
        }
}

function Idm-NewEmployeesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'NewEmployees'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            #Retrieve Report
            $uri = "https://$($system_params.hostname)/rally_api_v1/get/form_builder_results"
            
            $headers = @{
                "Authorization" = "Bearer $($system_params.client_secret)"
            }

            try {
                $splat = @{
                    Method = "GET"
                    Uri = $uri
                    Headers = $headers
                    Body = @{
                        key = $system_params.client_secret
                        form_id = 92
                    }
                }

                if($system_params.use_proxy)
                {
                    Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    
                    $splat["Proxy"] = $system_params.proxy_address

                    if($system_params.use_proxy_credentials)
                    {
                        $splat["proxyCredential"] = New-Object System.Management.Automation.PSCredential ($system_params.proxy_username, (ConvertTo-SecureString $system_params.proxy_password -AsPlainText -Force) )
                    }
                }
                $response = Invoke-RestMethod @splat -ErrorAction Stop

                $properties = ($Global:Properties.$Class).name
                $hash_table = [ordered]@{}

                foreach ($prop in $properties.GetEnumerator()) {
                    $hash_table[$prop] = ""
                }

                Log verbose "Total Results to process: $($response.data.count)"
                foreach($rowItem in $response.data) {
                    $row = New-Object -TypeName PSObject -Property $hash_table

                    foreach($prop in $rowItem.PSObject.properties) {
						if(!$properties.contains($prop.Name)) { 
							log warn "$($prop.Name) not configured, skipping"
							continue
						}
                        if($prop.Name -eq 'Date') {
							$row.($prop.Name) = try { ([datetime]::ParseExact($prop.Value, "MMM d, yyyy h:mmtt", $null)).ToString("yyyy-MM-dd HH:mm") } catch{}
						} else {
							$row.($prop.Name) = $prop.Value
						}
						
						
                        }

                    $row
                } 
            }
            catch [System.Net.WebException] {
                $message = "Error : $($_)"
                Log error $message
                Write-Error $_
            }
            catch {
                $message = "Error : $($_)"
                Log error $message
                Write-Error $_
            }
        }
}
function Check-RallyConnection { 
    param (
        [string] $SystemParams
    )
     Open-RallyConnection $SystemParams
}

function Open-RallyConnection {
    param (
        [hashtable] $SystemParams
    )
    
   
}

function Get-ClassMetaData {
    param (
        [string] $SystemParams,
        [string] $Class
    )

    @(
        @{
            name = 'properties'
            type = 'grid'
            label = 'Properties'
            table = @{
                rows = @( $Global:Properties.$Class | ForEach-Object {
                    @{
                        name = $_.name
                        usage_hint = @( @(
                            foreach ($opt in $_.options) {
                                if ($opt -notin @('default', 'idm', 'key')) { continue }

                                if ($opt -eq 'idm') {
                                    $opt.Toupper()
                                }
                                else {
                                    $opt.Substring(0,1).Toupper() + $opt.Substring(1)
                                }
                            }
                        ) | Sort-Object) -join ' | '
                    }
                })
                settings_grid = @{
                    selection = 'multiple'
                    key_column = 'name'
                    checkbox = $true
                    filter = $true
                    columns = @(
                        @{
                            name = 'name'
                            display_name = 'Name'
                        }
                        @{
                            name = 'usage_hint'
                            display_name = 'Usage hint'
                        }
                    )
                }
            }
            value = ($Global:Properties.$Class | Where-Object { $_.options.Contains('default') }).name
        }
    )
}
