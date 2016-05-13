# This installs a MongoDB backup dump cron job.
class mongodb::backup (
  $admin_username  = $mongodb::params::admin_username,
  $admin_password  = undef,
) inherits mongodb::params {
  # Backup cron job
  cron { 'MongoDB backup':
    command => 'mongodump --username ${admin_username} --password ${admin_password} --gzip --archive=/opt/backups/mongo.`date +%Y%m%d`.gz --quiet',
    user    => 'root',
    hour    => 23,
    minute  => 0,
  }
}
