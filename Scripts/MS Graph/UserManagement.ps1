
#
# Sign In to Microsoft.Graph
#
Connect-MgGraph -Scopes 'User.ReadWrite.All'

#
# Useful variables
# 

$domain='aztrg.com'
$password = 'ein1000%SichersPasswort'

#
# Create new user
#
$htPasswordprofile = @{
    Password = $password;
    ForceChangePasswordNextSignIn = $false;
    # ForceChangePasswordnextSignInWithMfa=$true --> User must perform Mfa before change password!
}
New-MgUser -DisplayName 'Guido Brunetti' `
           -UserPrincipalName "guido@$domain" `
           -AccountEnabled `
           -MailNickname 'Guido' `
           -Surname 'Brunetti' `
           -GivenName 'Guido' `
           -UsageLocation 'IT' `
           -UserType 'Member' `
           -PasswordProfile $htPasswordprofile

#
# Get a user's information
#
Get-MgUser
$curUser = Get-MgUser -Search '"DisplayName:Guido"' -ConsistencyLevel eventual
Get-MgUser -UserId $curUser.Id
Get-MgUser -UserId $curUser.Id | Format-List *

#
# Filter users
#
Get-MgUser -Filter "city eq 'Graz'"
Get-MgUser -Filter "startswith(city, 'G')" 

#
# Change user's setting
#
Update-MgUser -UserId $curUser.Id -City 'Venice'
$curUser = Get-MgUser -UserId $curUser.Id -Property 'City'

#
# Delete user
#
Remove-MgUser -UserId $curUser.Id

#
# Restore deleted user
#
Get-MgDirectoryDeletedItem -DirectoryObjectId $curUser.Id
Restore-MgUser -UserId $curUser.Id
