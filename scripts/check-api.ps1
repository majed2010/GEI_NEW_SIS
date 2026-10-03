param([string]$BaseUrl = 'http://localhost:5100', [switch]$Configured)
$ErrorActionPreference = 'Stop'
function Get-Status([string]$Path, [string]$Token = '') {
    try {
        $headers = @{}
        if ($Token) { $headers.Authorization = 'Bearer ' + $Token }
        return [int](Invoke-WebRequest ($BaseUrl + $Path) -Headers $headers -UseBasicParsing).StatusCode
    } catch {
        if ($_.Exception.Response) { return [int]$_.Exception.Response.StatusCode }
        throw
    }
}
if ((Get-Status '/api/health') -ne 200) { throw 'Health check failed.' }
$expected = if ($Configured) { 401 } else { 503 }
if ((Get-Status '/api/me') -ne $expected) { throw "Unauthenticated /api/me must return $expected." }
if ((Get-Status '/api/me' 'invalid-token') -ne $expected) { throw 'Invalid bearer token was not rejected.' }
Write-Output "PASS: health returns 200; missing and invalid tokens return $expected."
