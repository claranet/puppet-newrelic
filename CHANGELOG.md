# Change Log

Release notes for the claranet/puppet-newrelic module.

------------------------------------------

## 2.1.1 - 2018-02-01
  * Fork to fix olx Indonesia problem with apt-get update missing

## 2.1.0 - 2017-11-22
  * PHP Agent: Fixed a bug where the `newrelic-daemon` service would flap if the start-up mode was set to `agent` - [#13](https://github.com/claranet/puppet-newrelic/issues/13)
  * PHP Agent: New parameter: `default_daemon_settings` for external start-up mode - [#12](https://github.com/claranet/puppet-newrelic/pull/12)

## 2.0.1 - 2017-10-04
  * Infra Repo: Apt module now handles setting `release` for Debian osfamily - [#11](https://github.com/claranet/puppet-newrelic/issues/11)
  * Linux Server: Exec now creates `/etc/newrelic/nrsysmond.cfg` before `nrsysmond-config` is run
  * Dependencies: Apt has been relaxed to `>= 2.3.0`

## 2.0.0 - 2017-08-23
  * Major rewrite of module
  * Please note that Windows support is _untested_

## 1.1.0 - 2017-08-11
  * Managing repo now optional

## 1.0.0 - 2017-08-08
  * Initial Forge Release
