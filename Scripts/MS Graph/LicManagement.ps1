#
# Sign in to Entra ID
#
Connect-MgGraph -Scopes User.ReadWrite.All, Organization.Read.All

#
# Set Usage Location
#
$curUser = Get-MgUser -Filter "givenname eq 'guido'" -Property UsageLocation
Update-MgUser -UserId $curUser.Id -UsageLocation IT

#
# Get License SKUs
#
Get-MgSubscribedSku | Format-Table SkuPartNumber,ServicePlans
Get-MgSubscribedSku | Format-Table SkuPartNumber,ConsumedUnits,@{Label='PaidUnits';E={$_.prepaidunits.enabled}}
$licSKU = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq 'SPE_E5'}

#
# Assign licenses
#
Set-MgUserLicense -UserId $curUser.Id -AddLicenses @{SkuId = $licSKU.SkuId} -RemoveLicenses @()

#
# Assign Licenses with options
#
$disabledServices = $licSKU.ServicePlans | Where-Object { $_.ServicePlanName -like 'VIVA*' }
$lic = @{ SkuId = $licSKU.SkuId; DisabledPlans = $disabledServices }
Set-MgUserLicense -UserId $curUser.Id -AddLicenses $lic -RemoveLicenses @()

#
# Remove a license
#
Set-MgUserLicense -UserId $curUser.Id -RemoveLicenses @($licSKU.SkuId) -AddLicenses @()

