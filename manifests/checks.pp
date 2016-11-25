#
class mongodb::checks (
    $script_path = '/etc/nagios-plugins/check_mongodb.py',
    $address,
    $port = 27017,
    $conn_warn_value = 2,
    $conn_crit_value = 4,
    # For authentication we assume you have a ~/.mongorc.js with login details.
) {
    # Install script requirements
    include python
    python::pip { 'pymongo': }

    # The executable script.
    file { $script_path:
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        source  => "puppet:///modules/${module_name}/nagios-plugin-mongodb/check_mongodb.py",
    }

    # Allow nagios to run the script as any user.
    file { '/etc/sudoers.d/nagios-mongo':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        # sudoers require an empty newline
        content => "nagios ALL=(ALL) NOPASSWD:${script_path}\n\n"
    }

    # Available commands
    file { '/etc/nagios/nrpe.d/mongo_checks.cfg':
        ensure  => 'file',
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/mongo_checks.cfg.erb"),
    }
}

