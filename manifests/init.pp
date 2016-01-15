# == Class: mdadm_mon
#
# Please refer to https://github.com/jhoblitt/puppet-mdadm_mon#usage for parameter
# documentation.
#
class mdadm_mon(
  $config_file_manage  = $::mdadm_mon::params::config_file_manage,
  $config_file_options = $::mdadm_mon::params::config_file_options,
  $service_force       = $::mdadm_mon::params::service_force,
  $service_ensure      = $::mdadm_mon::params::service_ensure,
  $service_enable      = $::mdadm_mon::params::service_enable,
  $raid_check_manage   = $::mdadm_mon::params::raid_check_manage,
  $raid_check_options  = $::mdadm_mon::params::raid_check_options,
) inherits mdadm_mon::params {
  validate_bool($config_file_manage)
  validate_hash($config_file_options)
  validate_bool($service_force)
  validate_re($service_ensure, '^running$|^stopped$')
  validate_bool($service_enable)
  validate_bool($raid_check_manage)
  validate_hash($raid_check_options)

  if $service_force {
    $use_service_ensure = $service_ensure
    $use_service_enable = $service_enable
  } elsif $::mdadm_mon_arrays {
    $use_service_ensure = 'running'
    $use_service_enable = true
  } else {
    $use_service_ensure = 'stopped'
    $use_service_enable = false
  }

  package { $mdadm_mon::params::mdadm_mon_package:
    ensure => present,
  }

  if $config_file_manage {
    Package[$mdadm_mon::params::mdadm_mon_package] ->
    class { 'mdadm_mon::config':
      options => $config_file_options,
    } ->
    Class['mdadm_mon::mdmonitor']
  }

  class { 'mdadm_mon::mdmonitor':
    ensure => $use_service_ensure,
    enable => $use_service_enable,
  }

  if $raid_check_manage {
    Class['mdadm_mon::mdmonitor'] ->
    class { 'mdadm_mon::raid_check':
      options => $raid_check_options,
    } ->
    Anchor['mdadm_mon::end']
  }

  anchor { 'mdadm_mon::begin': } ->
  Package[$mdadm_mon::params::mdadm_mon_package] ->
  Class['mdadm_mon::mdmonitor'] ->
  anchor { 'mdadm_mon::end': }
}
