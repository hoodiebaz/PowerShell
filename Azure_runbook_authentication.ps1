########## PnP ##########
$env:PNPPOWERSHELL_UPDATECHECK = "Off"
$URL = ""
$ClientId = ""
$TenantId = ""
$Cert = Get-AutomationCertificate -Name ""
Connect-PnPOnline `
    -Url $URL `
    -ClientId $ClientId `
    -Tenant $TenantId `
    -Thumbprint $Cert.Thumbprint `
    -NoTelemetry `
    -WarningAction SilentlyContinue


########## AzAccount ##########
$Thumbprint = ""
$TenantId = ""
$ApplicationId = ""
Connect-AzAccount `
  -CertificateThumbprint $Thumbprint `
  -ApplicationId $ApplicationId `
  -Tenant $TenantId `
  -ServicePrincipal

########## MgGraph ##########
$ClientId = ""
$TenantId = ""
$Certificate = Get-AutomationCertificate -Name ""
Connect-MgGraph -ClientID $ClientId -TenantId $TenantId -CertificateThumbprint $Certificate.Thumbprint -NoWelcome
