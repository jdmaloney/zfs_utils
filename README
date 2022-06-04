# ZFS Administration Utilities

## Scrubber
Script to run a scrub on all pools that aren't exempted from scrubs in the zfs_utils.conf file

## Snapshot Manager
Script that kicks off snapshots for all specified datasets (all that aren't exempt); it keeps them for the specified retenion (either the default or the dataset override).  Snapshot cadence is set by cron.  

## Default Quota Setter
Sets default quotas for all users (except those exempt) for a given datset path, run frequently via cron to catch new users and apply the default quota (recommended run cadence is every 5 minutes)
