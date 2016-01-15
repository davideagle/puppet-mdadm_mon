# == Class: mdadm_mon::mdmonitor
#
# This class should be considered private.
#
class mdadm_mon::mdmonitor(
  $ensure = 'running',
  $enable = true,
) {
  validate_re($ensure, '^running$|^stopped$')
  validate_bool($enable)

  service { 'mdmonitor':
    ensure     => $ensure,
    hasrestart => true,
    hasstatus  => true,
    enable     => $enable,
  }
}
