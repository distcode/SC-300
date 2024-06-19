#
# Connect to Graph
#
$TenantID = '6434b4fa-92c8-4671-935b-ab082df57f3e'
$AppID = '476024b0-d7af-4f45-be5e-4ea62e065997'
$Cert = Get-ChildItem Cert:\CurrentUser\My\44D9C0C1078D52AE13EEBF26DB8DA3816AC6778C

Connect-MgGraph -TenantId $TenantID -AppId $AppID -Certificate $Cert

#
# Required permissions:
#  Application.ReadWrite.All
(Get-MgContext).Scopes

#
# Create a new app
# 
# Parameter -SignInAudiance: 'AzureADMyOrd' | 'AzureADMultipleOrgs' | 'AzureADandPersonalMicrosoftAccount' (default) | 'PersonalMicrosoftAccount' 
$nextApp = New-MgApplication -DisplayName 'mgMultiTenantApp' -Description 'Demo Multitenant App' -SignInAudience 'AzureADMultipleOrgs'

#
# Get Information about App
#
$nextApp | Format-List -Property *

Get-MgApplication
Get-MgApplication -Search 'DisplayName:mgMulti' -ConsistencyLevel eventual
$nextApp = Get-MgApplication -Search 'DisplayName:mgMulti' -ConsistencyLevel eventual

#
# Set Certificate for CBA
#
# Prerequisits:
# - a *.pfx of a self-signed certificate
# ToDos:
# - Create *.cer
# - Get thumbprint
# - Get certificate key
# - create key credentials
# - udpate AAD application
#
## Get *.pfx
## do not forget to provide a password
$pfx = Get-PfxCertificate -FilePath C:\Temp\GraphAPICertificate.pfx
## Create *.cer
$pfx | Export-Certificate -FilePath c:\temp\temp.cer -Type CERT -Force
## Get thumbprint
# $thumbprint = $pfx.Thumbprint
## if nescesary, import certificat to local machine store.
# Import-Certificate -FilePath *.pfx -CertStoreLocation Cert:\LocalMachine\My\

## Get certificate key
$key = [convert]::ToBase64String((Get-Content -Path C:\temp\temp.cer -Encoding Byte))

## create key credentials
$bodyparamters = @{
    keyCredentials = @(
        @{
            endDateTime   = $pfx.NotAfter
            startDateTime = $pfx.NotBefore
            type          = "AsymmetricX509Cert"
            usage         = "Verify"
            key           = [System.Text.Encoding]::ASCII.GetBytes($key)
            displayName   = "automatically uploaded"
        }
    )
}
## Update certificate for app
Update-MgApplication -ApplicationId $nextApp.Id -BodyParameter $bodyparamters

#
# Set secret for an app
#
$bodyparameters = @{
    passwordCredentials = @(
        @{
            DisplayName = 'Secret01'
            endDateTime = '2023-01-31T00:00:00Z'
        }
    )
}
Update-MgApplication -ApplicationId $nextApp.Id -PasswordCredentials $bodyparameters.passwordCredentials





##################
# found examples
##################

# Link: https://learn.microsoft.com/en-us/graph/applications-how-to-add-certificate?tabs=powershell
Import-Module Microsoft.Graph.Applications

$params = @{
    keyCredentials = @(
        @{
            endDateTime   = [System.DateTime]::Parse("2024-01-11T15:31:26Z")
            startDateTime = [System.DateTime]::Parse("2023-01-12T15:31:26Z")
            type          = "AsymmetricX509Cert"
            usage         = "Verify"
            key           = [System.Text.Encoding]::ASCII.GetBytes("base64MIIDADCCAeigAwIBAgIQP6HEGDdZ65xJTcK4dCBvZzANBgkqhkiG9w0BAQsFADATMREwDwYDVQQDDAgyMDIzMDExMjAeFw0yMzAxMTIwODExNTZaFw0yNDAxMTIwODMxNTZaMBMxETAPBgNVBAMMCDIwMjMwMTEyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAseKf1weEacJ67D6/...laxQPUbuIL+DaXVkKRm1V3GgIpKTBqMzTf4tCpy7rpUZbhcwAFw6h9A==")
            displayName   = "CN=20230112"
        }
    )
}

Update-MgApplication -ApplicationId $applicationId -BodyParameter $params



cert = New-SelfSignedCertificate -Subject "CN=MyCert" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature
$thumbprint = $cert.Thumbprint
$startDate = Get-Date
$endDate = $startDate.AddYears(1)
$securePassword = ConvertTo-SecureString "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential("username", $securePassword)
Connect-AzAccount -Credential $credential -TenantId <TenantId>
New-AzADServicePrincipal -DisplayName "MyServicePrincipal" -CertValue $cert.GetRawCertData() -EndDate $endDate -StartDate $startDate -Type asymmetricX509Cert -KeyCredentialType AsymmetricX509Cert -KeyUsage Verify -PasswordCredential $null

#######

