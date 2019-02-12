# == Class: newrelic::agent::java
#
# This class install the New Relic Java Agent
#
# Management of the JVM opts to make use of said agent are not supported
# and must be managed by end users seperately
#
# Useful docs for reference
# - https://docs.newrelic.com/docs/agents/java-agent/installation/install-java-agent
# - https://docs.newrelic.com/docs/agents/java-agent/installation/include-java-agent-jvm-argument
#
# === Parameters:
#
# [*license_key*]
#   NewRelic API license key (String)
#
# [*package_source_url*]
#   URL for the newrelic zip. Used as the source for download of zip.
#   Default: https://oss.sonatype.org/content/repositories/releases/com/newrelic/agent/java/newrelic-java
#
# [*package_version*]
#   Version of the newrelic java agent being used
#   Default: 3.47.1
#
# [*install_dir*]
#   Install dir for newrelic java agent.
#   Default: /opt
#
# [*newrelic_application_name*]
#   Name to give to your NewRelic application in the NewRelic GUI
#   Default: webapp
#
# [*agent_user*]
#   User for the newrelic agent
#   Default: root
#
# [*agent_group*]
#   Group for the newrelic agent
#   Default: root
#
# [*manage_config*]
#   Whether puppet should manage the newrelic.yml config file or not
#   Default: true
#
class newrelic::agent::java (
  String  $license_key,
  String  $package_source_url            = 'https://oss.sonatype.org/content/repositories/releases/com/newrelic/agent/java/newrelic-java',
  String  $package_version               = '3.47.1',
  String  $install_dir                   = '/opt',
  String  $newrelic_application_name     = 'webapp',
  String  $agent_user                    = 'root',
  String  $agent_group                   = 'root',
  Boolean $manage_config                 = true
){

  # == Package Installation
  ensure_packages('unzip')

  # == Newrelic java agent fetch/installation

  # Grab java agent verion from source URL.
  #
  # The default $package_source_url set within the module is pointing
  # to the only useful/dependable place for the java agent.
  # This can be overriden with a private nexus url for example
  exec { 'wget-newrelic-java-agent':
    path    => ['/usr/bin', '/usr/sbin'],
    cwd     => $install_dir,
    command => "wget ${package_source_url}/${package_version}/newrelic-java-${package_version}.zip",
    creates => "${install_dir}/newrelic-java-${package_version}.zip",
    onlyif  => "test ! -f ${install_dir}/newrelic-java-${package_version}.zip",
    notify  => Exec['unzip-newrelic-java-agent-zip']
  }

  exec { 'unzip-newrelic-java-agent-zip':
    path        => ['/usr/bin', '/usr/sbin'],
    cwd         => $install_dir,
    command     => "unzip ${install_dir}/newrelic-java-${package_version}.zip",
    creates     => "${install_dir}/newrelic",
    notify      => Exec['chown-newrelic-install-dir'],
    refreshonly => true
  }

  exec { 'chown-newrelic-install-dir':
    path        => ['/usr/bin', '/usr/sbin'],
    command     => "chown -R ${agent_user}:${agent_group} ${install_dir}/newrelic",
    refreshonly => true
  }

  # == Configuration

  # manage the contents of the newrelic.yml or not
  # if managed only license_key + app_name + env app_names are overriden/supported by module overrides
  if $manage_config {
    file { "${install_dir}/newrelic/newrelic.yml":
      ensure  => 'file',
      content => epp('newrelic/java/newrelic.yml.epp', {
        license_key               => $license_key,
        newrelic_application_name => $newrelic_application_name
      }),
      owner   => $agent_user,
      group   => $agent_group,
      mode    => '0755',
      require => Exec['unzip-newrelic-java-agent-zip']
    }
  }
}
