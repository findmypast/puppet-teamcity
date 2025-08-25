# = Class teamcity::master
#
# Configures a teamcity master on the host.
#
#
# == Parameters
#
# [*authentication*]
# String, must be 'local' (default) or 'ldap'. If 'ldap' is set you have to
# provide the ldap_configuration parameter.
#
# [*ldap_configuration*]
# String. The contents of the ldap-config.properties file. If set to 'external'
# then the user is responsible for providing the file by himself.
#
class teamcity::params (
  $teamcity_version               = '9.1.3',
  $teamcity_base_url              = 'http://download.jetbrains.com/teamcity/TeamCity-%%%VERSION%%%.tar.gz',
  $teamcity_download_timeout      = 180,

  $openjdk_21_jdk_headless        = 'latest',
  $openjdk_21_jre_headless        = 'latest',
  $openjdk_21_jre                 = 'latest',

  $teamcity_server_mem_opts       = undef,

  Regexp[/^(local|ldap)$/] $authentication                 = 'local',
  $ldap_configuration             = undef,

  $add_agent_sudo                 = false,

  $db_type                        = undef,
  $db_host                        = undef,
  $db_port                        = undef,
  $db_name                        = undef,
  $db_user                        = undef,
  $db_pass                        = undef,

  # unused
  $db_admin_user                  = undef,
  $db_admin_pass                  = undef,

  $jdbc_download_url              = undef,
  $agent_download_url             = '%%%TC_MASTER%%%/update/buildAgent.zip',
  $agent_master_url               = undef,

  $teamcity_agent_path            = '/opt/teamcity_agent',
  $teamcity_data_path             = '/var/lib/teamcity',
  $teamcity_logs_path             = '/opt/teamcity/logs',

  Regexp[/^(camptocamp|puppet)$/] $archive_provider               = 'camptocamp',

) {
  if $authentication == 'ldap' and $ldap_configuration == undef {
    fail('profiles::teamcity_master: if authentication is LDAP you have to provide $ldap_configuration')
  }
}
