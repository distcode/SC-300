
#
# Useful variables
#
$tenantID = 'any valid tenant id'
$user = Get-EntraUser -SearchString 'any valid user principal name'

#
# Connect to the MS Entra ID interactively
#
Connect-Entra -TenantId $tenantID -Scopes 'User.ReadWrite.All,Group.ReadWrite.All,Organization.Read.All, LicenseAssignment.Read.All'
# Check your sign-in and scopes
Get-EntraContext
(Get-EntraContext).Scopes

# Get all licenses
Get-EntraAccountSku

# Get all licenses for a user
Get-EntraUserLicenseDetail -UserId $user.Id

# Assign a license to a user
$licenseObject = Get-EntraAccountSku | Where-Object { $_.skuPartNumber -eq 'DEVELOPERPACK_E5' }
$licenstoAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses    
$licenstoAssign.SkuId = $licenseObject.SkuId
$licenses.AddLicenses = $licenstoassign 
Set-EntraUserLicense -UserId $user.Id -AssignedLicenses $licenses

# Remove a license from a user
$licenseObject = Get-EntraAccountSku | Where-Object { $_.skuPartNumber -eq 'DEVELOPERPACK_E5' }
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses    
$licenses.RemoveLicenses = $licenseObject.SkuId # Licenses to remove must be an array of strings SKU IDs.
Set-EntraUserLicense -UserId $user.Id -AssignedLicenses $licenses

# Assign licenses with options
$licenseObject = Get-EntraAccountSku | Where-Object { $_.skuPartNumber -eq 'DEVELOPERPACK_E5' }
$licenseObject.ServicePlans # to see the license options
$disabledServices = @($licenseObject.ServicePlans | Where-Object { $_.ServicePlanName -eq 'SWAY' })
$disabledServices += @($licenseObject.ServicePlans | Where-Object { $_.ServicePlanName -eq 'FORMS_PLAN_E5' })
$disabledServices += @($licenseObject.ServicePlans | Where-Object { $_.ServicePlanName -eq 'POWERAPPS_O365_P3' })

$licenstoAssign = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$licenses = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses    
$licenstoAssign.SkuId = $licenseObject.SkuId
$licenstoAssign.DisabledPlans = $disabledServices
$licenses.AddLicenses = $licenstoassign 
Set-EntraUserLicense -UserId $user.Id -AssignedLicenses $licenses

(Get-EntraUserLicenseDetail -UserId $user.Id).ServicePlannam

#
# Change license options
# You have to remove the current license and assign it again with the new options.
#