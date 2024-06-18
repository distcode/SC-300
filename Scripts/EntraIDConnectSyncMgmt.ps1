
# Set Sync Schedule
$SchedulerInterval = New-TimeSpan -Hours 3
Set-ADSyncScheduler -CustomizedSyncCycleInterval $SchedulerInterval
Set-ADSyncScheduler -SyncCycleEnabled $false
Get-AdSyncScheduler

# Set deleted objects treshold
Get-ADSyncExportDeletionThreshold
Enable-ADSyncExportDeletionThreshold -DeletionThreshold 50

# 
