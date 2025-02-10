
#
# Useful variables
#
$tenantID = 'any valid tenant id'
$password = 'any valid password'

#
# Connect to the MS Entra ID interactively
#
Connect-Entra -TenantId $tenantID -Scopes 'User.ReadWrite.All'
# Check your sign-in and scopes
Get-EntraContext
(Get-EntraContext).Scopes

# Get all users
Get-EntraUser
# Get a specific user by user principal name
Get-EntraUser -UserId 'any valid user name'
# Get a specific user by ID
Get-EntraUser -UserId '12345678-1234-1234-1234-123456789012'
# Find a user by name
Get-EntraUser -SearchString 'anyUser' # This will return all users with 'anyUser' in their display name or user principal name.
# Find a user by name with a filter
Get-EntraUser -Filter "city eq 'london'"
Get-EntraUser -Filter "startswith(city,'lon')"
Get-EntraUser -Filter "endswith(city,'don')" # This operator is not supported ...

# Create a new user
# First create a password profile
$passwordProfile = New-Object -type Microsoft.Open.AzureAD.Model.PasswordProfile
$passwordProfile.Password = $password
$passwordProfile.ForceChangePasswordNextLogin = $true
New-EntraUser -UserPrincipalName 'guido@domai.at' `
              -DisplayName 'Guido Brunetti' `
              -GivenName 'Guido' `
              -Surname 'Brunetti' `
              -PasswordProfile $passwordProfile `
              -AccountEnabled $true `
              -MailNickName 'Guido'

# Update a user
Set-EntraUser -UserId 'guido@domain.at' `
              -City 'Venice' `
              -Country 'Italy' `
              -UsageLocation 'IT'

# Delete a user
Remove-EntraUser -UserId 'guido@domain.at'

# Restore a deleted user
Get-EntraDeletedUser
Get-EntraDeletedUser -SearchString 'guido'

Get-EntraDeletedUser -SearchString 'guido' | Restore-EntraDeletedDirectoryObject
