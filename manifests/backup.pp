# This installs a MongoDB backup dump cron job.
class mongodb::backup (
  $admin_username  = $mongodb::params::admin_username,
  $admin_password  = undef,
) inherits mongodb::params {
  # Backup cron job
  cron { 'MongoDB backup':
    command  => "mongodump --username ${admin_username} --password ${admin_password} --out /opt/backups/mongo.`date +\%Y\%m\%d` --quiet && wait; cd /opt/backups && wait; tar czf /opt/backups/mongo.`date +\%Y\%m\%d`.tar.gz mongo.`date +\%Y\%m\%d` && wait; rm -Rf mongo.`date +\%Y\%m\%d` && wait;",
    user     => 'root',
    hour     => 23,
    minute   => 0,
  }
}
