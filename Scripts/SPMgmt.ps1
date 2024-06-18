
# SP sign in
## using client secret
$TentantID = '<your-tenant-id'
$SPClientID = '<your-SP-ClientID>'
$SPSecret = '<your-SP-Secret>'
$cred = New-Object -TypeName pscredential -ArgumentList $SPClientID,(ConvertTo-SecureString -String $SPSecret -AsPlainText -Force)

Connect-MgGraph -ClientSecretCredential $cred -TenantId $TentantID

# SP sign in
## using client certificate

## create and export a certificate 
$CertParam = @{
    'KeyAlgorithm'      = 'RSA'
    'KeyLength'         = 2048
    'KeyExportPolicy'   = 'Exportable'
    'DnsName'           = 'server.dist.at'
    'FriendlyName'      = 'SP Sign In Certificate'
    'CertStoreLocation' = 'Cert:\LocalMachine\My\'
    'NotAfter'          = (Get-Date).AddYears(1)
}
$Cert = New-SelfSignedCertificate @CertParam

Export-Certificate -Cert $Cert -FilePath $Home\Documents\AutomationApp.cer

## upload certificate
###
## Switch to your browser and upload the AutomationApp.cer to the registerd application.
###

## sign in
$TentantID = '<your-tenant-id'
$SPClientID = '<your-SP-ClientID>'
$Certificate = Get-ChildItem Cert:\LocalMachine\My\<yourThumbPrint>

## Sign in to MS Graph
Connect-MgGraph -TenantId $TenantId -ClientId $SPClientID -CertificateThumbprint $Certificate.Thumbprint
## Sign in to Azure
Connect-AzAccount -ServicePrincipal -TenantId $TenantID -ApplicationId $SPClientID -CertificateThumbprint $Certificate.Thumbprint
