#
# Sign In to Microsoft.Graph
#
Connect-MgGraph -Scopes 'User.ReadWrite.All', 'Group.ReadWrite.All'

#
# Create a new Group
#
New-MgGroup -MailNickname 'mgDetectives' -DisplayName 'mgDetectives' -SecurityEnabled -MailEnabled:$false

#
# Get groups / group
#
Get-MgGroup
$myGroup = Get-MgGroup -GroupId '5acda838-493f-4ed9-be6a-2a83ed07763f'
$myGroup | Format-List -Property *

#
# Add member(s) to groups
#
$myUser = Get-MgUser -Search '"Displayname:Guido"'
New-MgGroupMember -GroupId $myGroup.Id -DirectoryObjectId $myUser.Id

#
# Remove member(s) from group(s)
#
$myUser = Get-MgUser -Search '"Displayname:Guido"'
Remove-MgGroupMemberByRef -GroupId $myGroup.Id -DirectoryObjectId $myUser.Id
