
#
# Useful variables
#
$tenantID = 'any valid tenant id'
$user = Get-EntraUser -SearchString 'any valid user name'

#
# Connect to the MS Entra ID interactively
#
Connect-Entra -TenantId $tenantID -Scopes 'User.ReadWrite.All,Group.ReadWrite.All'
# Check your sign-in and scopes
Get-EntraContext
(Get-EntraContext).Scopes

# Get all groups
Get-EntraGroup
# Get a specific group by Displayname
Get-EntraGroup -SearchString 'any valid group name'
# Get a specific group by ID
Get-EntraGroup -GroupId 'any valid group id'
# Get all security groups
Get-EntraGroup -Filter "securityEnabled eq true"
# Get all M365 groups
Get-EntraGroup -Filter "mailEnabled eq true and groupTypes/any(c:c eq 'Unified')"

# Create a new group
# Security Group
New-EntraGroup -DisplayName 'SecGroup' `
               -MailEnabled $false `
               -MailNickname 'SecGroup' `
               -SecurityEnabled $true `
               -Description 'Security Group'
# M365 Group
New-EntraGroup -DisplayName 'M365Group' `
               -MailEnabled $true `
               -MailNickname 'M365Group' `
               -SecurityEnabled $true `
               -Description 'M365 Group' `
               -GroupTypes 'Unified'

# Update a group
$group = Get-EntraGroup -SearchString 'SecGroup'
Set-EntraGroup -GroupId $group.Id `
-Description 'Security Group for all users'

# Add Members to a group
$group = Get-EntraGroup -SearchString 'SecGroup'
Add-EntraGroupMember -GroupId $group.Id -RefObjectId $user.Id

# Get Members of a group
$group = Get-EntraGroup -SearchString 'SecGroup'
Get-EntraGroupMember -GroupId $group.Id

# Remove Members from a group
$group = Get-EntraGroup -SearchString 'SecGroup'
Remove-EntraGroupMember -GroupId $group.Id -MemberId $user.Id

# Delete a group
$group = Get-EntraGroup -SearchString 'SecGroup'
Remove-EntraGroup -GroupId $group.Id

# Restore a deleted group
# Note: Security groups cannot be restored. Only Microsoft 365 groups can be restored.
Get-EntraDeletedGroup
Get-EntraDeletedGroup -SearchString 'M365Group'
Get-EntraDeletedGroup -SearchString 'M365Group' | Restore-EntraDeletedDirectoryObject
