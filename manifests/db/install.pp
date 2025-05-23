class teamcity::db::install inherits ::teamcity::params {
  $db_type                        = $::teamcity::params::db_type

  # for the template!
  $db_host                        = $::teamcity::params::db_host
  $db_port                        = $::teamcity::params::db_port
  $db_name                        = $::teamcity::params::db_name
  $db_user                        = $::teamcity::params::db_user
  $db_pass                        = $::teamcity::params::db_pass

  # unused
  $db_admin_user                  = $::teamcity::params::db_admin_user
  $db_admin_pass                  = $::teamcity::params::db_admin_pass

  $jdbc_download_url              = $::teamcity::params::jdbc_download_url
  $teamcity_data_path             = $::teamcity::params::teamcity_data_path

  # variable definitions

  $use_jdbc_download_url = $jdbc_download_url ? {
    undef => $db_type ? {
      'postgresql'  => 'https://jdbc.postgresql.org/download/postgresql-42.0.0.jar',
    },
    default => $jdbc_download_url,
  }

  $tmp              = split($use_jdbc_download_url, "[/\\\\]")
  $jdbc_filename    = $tmp[-1]

  # go

  File["${teamcity_data_path}/lib/jdbc"]
  -> archive { "${teamcity_data_path}/lib/jdbc/${jdbc_filename}":
    provider => 'wget',
    source   => $use_jdbc_download_url,
    user     => 'teamcity',
    group    => 'teamcity',
  } -> file { "${teamcity_data_path}/lib/jdbc/${jdbc_filename}":
    owner => 'teamcity',
    group => 'teamcity',
  } ~> Service['teamcity']
}
