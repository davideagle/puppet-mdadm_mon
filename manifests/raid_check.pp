# == Class: mdadm_mon::raid_check
#
# This class should be considered private.
#
class mdadm_mon::raid_check(
  $options = {}
) {
  validate_hash($options)

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  $safe_options = merge($::mdadm_mon::raid_check_default_options, $options)

  file { $::mdadm_mon::raid_check_path:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($::mdadm_mon::raid_check_template),
  }
}
