# This installs a MongoDB backup dump script and cron job.
class mongodb::backup (
  $backupuser,
  $backuppassword,
  $backupdir,
  $backupdirmode = '0700',
  $backupdirowner = 'root',
  $backupdirgroup = 'root',
  $backuprotate = 30,
  $ensure = 'present',
  $time = ['23', '0'],
) inherits mongodb::params {
  cron { 'MongoDB backup':
    command => "/usr/local/sbin/mongobackup.sh",
    user    => 'root',
    hour    => $time[0],
    minute  => $time[1],
    require => File['mongobackup.sh'],
  }

  file { 'mongobackup.sh'
    ensure  => $ensure,
    path    => '/usr/local/sbin/mongobackup.sh',
    mode    => '0700',
    owner   => 'root',
    group   => 'root',
    content => template('mongodb/mongobackup.sh.erb'),
  }

  file { 'mongobackupdir'
    ensure => 'directory',
    path   => $backupdir,
    mode   => $backupdirmode,
    owner  => $backupdirowner,
    group  => $backupdirgroup,
  }
}
