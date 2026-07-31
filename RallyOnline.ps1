#
# RallyOnline.ps1 - Rally Online
#

$Log_MaskableKeys = @(
    'Password',
    "proxy_password",
    "client_secret"
)

$Global:Proxy = @{}
$Global:ProxyInitialized = $false


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
                name = 'connection_header'
                type = 'text'
                text = 'Connection'
				tooltip = 'Connection information'
            }
            @{
                name = 'hostname'
                type = 'textbox'
                label = 'Hostname'
                require = $true
                description = 'Hostname for Web Services'
                value = 'api.rallycms.ca'
            }
            @{
                name = 'client_secret'
                type = 'textbox'
                password = $true
                require = $true
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
                name = 'session_header'
                type = 'text'
                text = 'Session Options'
				tooltip = 'Options for system session'
            }
            @{
                name = 'nr_of_retries'
                type = 'textbox'
                label = 'Max. number of retry attempts'
                description = ''
                value = 5
            }
            @{
                name = 'retryDelay'
                type = 'textbox'
                label = 'Seconds to wait for retry'
                description = ''
                value = 2
            }
            @{
                name = 'request_timeout_seconds'
                type = 'textbox'
                label = 'Request timeout (seconds)'
                description = ''
                value = 100
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
            @{
                name = 'table_header'
                type = 'text'
                text = 'Tables'
				tooltip = 'Table Mapping'
            }
            @{
                name = 'table_1_header'
                type = 'text'
                text = 'Table 1'
				tooltip = 'Table 1 Config'
            }
            @{
                name = 'table_1_name'
                type = 'textbox'
                label = 'Table 1 Name'
                description = ''
            }
            @{
                name = 'table_1_form_id'
                type = 'textbox'
                label = 'Table 1 Form ID'
                description = ''
				disabled = '!table_1_name'
                hidden = '!table_1_name'
            }
            ##############################
            @{
				name = 'table_2_header'
				type = 'text'
				text = 'Table 2'
				tooltip = 'Table 2 Config'
				disabled = '!table_1_name'
				hidden = '!table_1_name'
			}
			@{
				name = 'table_2_name'
				type = 'textbox'
				label = 'Table 2 Name'
				description = ''
				disabled = '!table_1_name'
				hidden = '!table_1_name'
			}
			@{
				name = 'table_2_form_id'
				type = 'textbox'
				label = 'Table 2 Form ID'
				description = ''
				disabled = '!table_1_name'
				hidden = '!table_1_name'
			}
            ##############################
            @{
				name = 'table_3_header'
				type = 'text'
				text = 'Table 3'
				tooltip = 'Table 3 Config'
				disabled = '!table_2_name'
				hidden = '!table_2_name'
			}
			@{
				name = 'table_3_name'
				type = 'textbox'
				label = 'Table 3 Name'
				description = ''
				disabled = '!table_2_name'
				hidden = '!table_2_name'
			}
			@{
				name = 'table_3_form_id'
				type = 'textbox'
				label = 'Table 3 Form ID'
				description = ''
				disabled = '!table_2_name'
				hidden = '!table_2_name'
			}
            ##############################
			@{
				name = 'table_4_header'
				type = 'text'
				text = 'Table 4'
				tooltip = 'Table 4 Config'
				disabled = '!table_3_name'
				hidden = '!table_3_name'
			}
			@{
				name = 'table_4_name'
				type = 'textbox'
				label = 'Table 4 Name'
				description = ''
				disabled = '!table_3_name'
				hidden = '!table_3_name'
			}
			@{
				name = 'table_4_form_id'
				type = 'textbox'
				label = 'Table 4 Form ID'
				description = ''
				disabled = '!table_3_name'
				hidden = '!table_3_name'
			}
            ##############################
			@{
				name = 'table_5_header'
				type = 'text'
				text = 'Table 5'
				tooltip = 'Table 5 Config'
				disabled = '!table_4_name'
				hidden = '!table_4_name'
			}
			@{
				name = 'table_5_name'
				type = 'textbox'
				label = 'Table 5 Name'
				description = ''
				disabled = '!table_4_name'
				hidden = '!table_4_name'
			}
			@{
				name = 'table_5_form_id'
				type = 'textbox'
				label = 'Table 5 Form ID'
				description = ''
				disabled = '!table_4_name'
				hidden = '!table_4_name'
			}
            ##############################
			@{
				name = 'table_6_header'
				type = 'text'
				text = 'Table 6'
				tooltip = 'Table 6 Config'
				disabled = '!table_5_name'
				hidden = '!table_5_name'
			}
			@{
				name = 'table_6_name'
				type = 'textbox'
				label = 'Table 6 Name'
				description = ''
				disabled = '!table_5_name'
				hidden = '!table_5_name'
			}
			@{
				name = 'table_6_form_id'
				type = 'textbox'
				label = 'Table 6 Form ID'
				description = ''
				disabled = '!table_5_name'
				hidden = '!table_5_name'
			}
            ##############################
			@{
				name = 'table_7_header'
				type = 'text'
				text = 'Table 7'
				tooltip = 'Table 7 Config'
				disabled = '!table_6_name'
				hidden = '!table_6_name'
			}
			@{
				name = 'table_7_name'
				type = 'textbox'
				label = 'Table 7 Name'
				description = ''
				disabled = '!table_6_name'
				hidden = '!table_6_name'
			}
			@{
				name = 'table_7_form_id'
				type = 'textbox'
				label = 'Table 7 Form ID'
				description = ''
				disabled = '!table_6_name'
				hidden = '!table_6_name'
			}
            ##############################
			@{
				name = 'table_8_header'
				type = 'text'
				text = 'Table 8'
				tooltip = 'Table 8 Config'
				disabled = '!table_7_name'
				hidden = '!table_7_name'
			}
			@{
				name = 'table_8_name'
				type = 'textbox'
				label = 'Table 8 Name'
				description = ''
				disabled = '!table_7_name'
				hidden = '!table_7_name'
			}
			@{
				name = 'table_8_form_id'
				type = 'textbox'
				label = 'Table 8 Form ID'
				description = ''
				disabled = '!table_7_name'
				hidden = '!table_7_name'
			}
            ##############################
			@{
				name = 'table_9_header'
				type = 'text'
				text = 'Table 9'
				tooltip = 'Table 9 Config'
				disabled = '!table_8_name'
				hidden = '!table_8_name'
			}
			@{
				name = 'table_9_name'
				type = 'textbox'
				label = 'Table 9 Name'
				description = ''
				disabled = '!table_8_name'
				hidden = '!table_8_name'
			}
			@{
				name = 'table_9_form_id'
				type = 'textbox'
				label = 'Table 9 Form ID'
				description = ''
				disabled = '!table_8_name'
				hidden = '!table_8_name'
			}
            ##############################
			@{
				name = 'table_10_header'
				type = 'text'
				text = 'Table 10'
				tooltip = 'Table 10 Config'
				disabled = '!table_9_name'
				hidden = '!table_9_name'
			}
			@{
				name = 'table_10_name'
				type = 'textbox'
				label = 'Table 10 Name'
				description = ''
				disabled = '!table_9_name'
				hidden = '!table_9_name'
			}
			@{
				name = 'table_10_form_id'
				type = 'textbox'
				label = 'Table 10 Form ID'
				description = ''
				disabled = '!table_9_name'
				hidden = '!table_9_name'
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
    $Global:Proxy = @{}
    $Global:ProxyInitialized = $false
}

#
# Object CRUD functions
#
<#
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

#>

function Idm-Dispatcher {
    param (
        # Optional Class/Operation
        [string] $Class,
        [string] $Operation,
        # Mode
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-Class='$Class' -Operation='$Operation' -GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $system_params   = ConvertFrom-Json2 $SystemParams
    $function_params = ConvertFrom-Json2 $FunctionParams

    if ($Class -eq '') {

        if ($GetMeta) {
            #
            # Output list of supported operations per table/view (named Class)
            #
            for ($i = 0; $i -lt 21; $i++)
            {
                if($system_params."table_$($i)_name".length -gt 0)
                {
                    @(
                        [ordered]@{
                            Class = $system_params."table_$($i)_name"
                            Operation = 'Read'
                            'Source type' = 'Form Results'
                            'Primary key' = ''
                            'Supported operations' = 'R'
                            'Form ID' = $system_params."table_$($i)_form_id"
                        }
                    )
                    }
            }

        }
        else {
            # Purposely no-operation.
        }

    }
    else {

        if ($GetMeta) {
           @() # No Configuration Options
        }
        else {
            #
            # Execute function
            #

            for ($i = 0; $i -lt 21; $i++)
            {
                if($system_params."table_$($i)_name" -eq $class)
                {
                    $body = @{
                        key = $system_params.client_secret
                        form_id = $system_params."table_$($i)_form_id"
                    }
                    break
                }
            }
			
            $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = "rally_api_v1/get/form_builder_results"
                    Body = $body
                    Path = "data"
                }

            Execute-Request @splat
        }

    }

    Log verbose "Done"
}


#
#   Internal Functions
#

function Initialize-Proxy {
    param (
        [hashtable] $SystemParams
    )

    if($SystemParams.use_proxy)
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
                    
        $Global:Proxy['ProxyAddress'] = $SystemParams.proxy_address

        if($SystemParams.use_proxy_credentials)
        {
            $Global:Proxy["ProxyCredential"] = New-Object System.Management.Automation.PSCredential ($SystemParams.proxy_username, (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force) )
        }
    } else {
        $Global:Proxy = $null
    }


}

function Get-IntSetting {
    param (
        [hashtable] $Settings,
        [string] $Name,
        [int] $Default,
        [int] $Minimum = 1,
        [int] $Maximum = [int]::MaxValue
    )

    $value = $null
    if ($null -ne $Settings -and $Settings.ContainsKey($Name)) {
        $value = $Settings[$Name]
    }

    $parsed = 0
    if ($null -eq $value -or -not [int]::TryParse(([string]$value), [ref]$parsed)) {
        $parsed = $Default
    }

    if ($parsed -lt $Minimum) { return $Minimum }
    if ($parsed -gt $Maximum) { return $Maximum }
    return $parsed
}

function Execute-Request {
    param (
        [hashtable] $SystemParams,
        [string] $Method,
        [object] $Body,
        [string] $Uri,
        [string] $Path = $null,
        [boolean] $LoggingEnabled = $true,
        [boolean] $GetMeta = $true
    )

    if (-not $Global:ProxyInitialized) {
        Initialize-Proxy -SystemParams $SystemParams
        $Global:ProxyInitialized = $true
    }

    $requestTimeoutSeconds = Get-IntSetting -Settings $SystemParams -Name 'request_timeout_seconds' -Default 100 -Minimum 1 -Maximum 3600
    $maxRetries = Get-IntSetting -Settings $SystemParams -Name 'nr_of_retries' -Default 5 -Minimum 1 -Maximum 20
    $defaultRetryDelay = Get-IntSetting -Settings $SystemParams -Name 'retryDelay' -Default 2 -Minimum 1 -Maximum 3600

    # Build base request
    $splat = @{
        Headers = @{
            "Authorization" = ("Bearer {0}" -f $SystemParams.client_secret)
            "Accept"        = "application/json"
            "Content-Type"  = "application/json"
        }
        Method = $Method
        Uri    = ("https://{0}/{1}" -f $SystemParams.hostname, $Uri)
        TimeoutSec = $requestTimeoutSeconds
    }
 
    if ($Body) {
        $splat.Body = $Body
    }

    if ($SystemParams.use_proxy) {
        $splat["Proxy"] = $Global:Proxy['ProxyAddress']
        if ($SystemParams.use_proxy_credentials) {
            $splat["ProxyCredential"] = $Global:Proxy["ProxyCredential"]
        }
    }

    # Convert Body → query parameters for GET requests
    if ($Method -eq "GET" -and $Body) {

        # Ensure Body is a hashtable before treating it as query params
        if ($Body -is [hashtable]) {

            $queryParts = [System.Collections.Generic.List[string]]::new()
            foreach ($entry in $Body.GetEnumerator()) {
                if ($null -eq $entry.Value) { continue }

                $encodedKey = [Uri]::EscapeDataString([string]$entry.Key)
                if ($entry.Value -is [System.Array]) {
                    foreach ($value in $entry.Value) {
                        if ($null -eq $value) { continue }
                        $queryParts.Add(("{0}={1}" -f $encodedKey, [Uri]::EscapeDataString([string]$value)))
                    }
                } else {
                    $queryParts.Add(("{0}={1}" -f $encodedKey, [Uri]::EscapeDataString([string]$entry.Value)))
                }
            }

            $queryString = $queryParts -join "&"

            if ($queryString.Length -gt 0) {
                if ($splat.Uri -notmatch "\?") {
                    $splat.Uri = "$($splat.Uri)?$queryString"
                }
                else {
                    $splat.Uri = "$($splat.Uri)&$queryString"
                }
            }
        }

        # GET requests cannot send a body
        if ($splat.ContainsKey("Body")) {
            $splat.Remove("Body")
        }
    }

    # Response accumulator
    $allData = [System.Collections.Generic.List[object]]::new()

    $attempt = 0
        $retryDelay = $defaultRetryDelay

        do {
            try {
                $attemptSuffix = if ($attempt -gt 0) { " (Attempt $($attempt + 1))" } else { "" }
                if($LoggingEnabled) { Log verbose "$($splat.Method) Call: $($splat.Uri)$attemptSuffix" }

                $response = Invoke-RestMethod @splat -ErrorAction Stop
                break
            }
            catch {
                $errorRecord = $_
                $statusCode = $errorRecord.Exception.Response.StatusCode.value__

                switch ($statusCode) {

                    { $_ -eq 401 -or $_ -eq 403 } {
                        if($LoggingEnabled) { Log warning "Received $statusCode. Attempting reauthentication..." }

                        # Re-authenticate under a process-wide lock to avoid runspace refresh stampedes.
                        $authRefreshMutex = New-Object System.Threading.Mutex($false, "NIMConcurSapAuthRefresh")
                        $authRefreshLockAcquired = $false
                        try {
                            $authRefreshLockAcquired = $authRefreshMutex.WaitOne(($requestTimeoutSeconds * 1000))
                            if (-not $authRefreshLockAcquired) {
                                throw "Timed out waiting for token refresh lock."
                            }
                            Execute-Authorization $SystemParams
                        } finally {
                            if ($authRefreshLockAcquired) {
                                $authRefreshMutex.ReleaseMutex()
                            }
                            $authRefreshMutex.Dispose()
                        }

                        # Update Authorization header with new token
                        $splat.Headers["Authorization"] = ("Bearer {0}" -f $Global:AuthToken)

                        # Retry once immediately
                        try {
                            $response = Invoke-RestMethod @splat -ErrorAction Stop
                            break
                        }
                        catch {
                            throw "$statusCode persisted after reauthentication. Aborting request."
                        }
                    }

                    429 {
                        $attempt++
                        if ($attempt -ge $maxRetries) {
                            throw "Max retry attempts reached for $Uri"
                        }
                        $retryAfter = $errorRecord.Exception.Response.Headers["Retry-After"]
                        if ($retryAfter) {
                            $retryAfterSeconds = 0
                            if ([int]::TryParse($retryAfter, [ref]$retryAfterSeconds) -and $retryAfterSeconds -gt 0) {
                                $retryDelay = $retryAfterSeconds
                            } else {
                                $retryAfterDate = [datetime]::MinValue
                                if ([datetime]::TryParse($retryAfter, [ref]$retryAfterDate)) {
                                    $retryAfterSeconds = [math]::Ceiling(($retryAfterDate.ToUniversalTime() - [datetime]::UtcNow).TotalSeconds)
                                    if ($retryAfterSeconds -gt 0) {
                                        $retryDelay = $retryAfterSeconds
                                    }
                                }
                            }
                        }
                        if($LoggingEnabled) { Log warning "Received 429. Retrying in $retryDelay seconds..." }
                        Start-Sleep -Seconds $retryDelay
                        $retryDelay *= 2
                    }

                    default {
                        throw $errorRecord
                    }
                }
            }
        } while ($true)

        # Append data
        if ($Path.length -lt 1) {
            $allData.Add($response)
        } else {
            if ($response.$Path) {
                $allData.AddRange([object[]]@($response.$Path))
            }
        }


    return $allData
}