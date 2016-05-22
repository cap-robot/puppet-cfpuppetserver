# cfpuppetserver

## Description

The package does standard procedure of installing Puppet Server, Puppet DB, PostgreSQL,
r10k, librarian-puppet and making it work all togather. It also lives in peace with
[cfsystem][] and [cfnetwork][] packages.

### Environment configuration

The configurations expects you to provide [Hiera version 4 configuration](https://docs.puppetlabs.com/puppet/latest/reference/lookup_quick.html#hierayaml-version-4-in-a-nutshell)
in environments. Example can be taken from [codingfuture/puppe-test](https://github.com/codingfuture/puppet-test/blob/master/hiera.yaml).

**NOTE1: there is a known closed bug in puppet <=4.3.2 - please make sure that all Hiera hierarchy files exist and both empty YAML and JSON files include '{}' at least**

## Global Hiera config

Puppet 4 has own implementation of lookup() which goes through:

* Global Hiera
* Per-environment Data Providers (Hiera, custom function)
* Per-module Data Providers (Hiera, custom function)

You should not use global Hiera any more. All configurations should be set in environments as mentioned above.

Global Hiera config is as follows:

```yaml
---
:backends:
  - yaml
:hierarchy:
  - global
:yaml:
  # Make sure to use hiera.yaml in environments
  :datadir: "/etc/puppetlabs/code/hieradata"
```

### Adding new Puppet clients

This module also provides a handy tool to initalize new puppet client hosts:

```
~#  /opt/codingfuture/bin/cf_gen_puppet_client_init
Usage: cf_gen_puppet_client_init <certname> [<cflocation> [<cflocationpool> [<http_proxy>]]
```

### Manual (re-)deployment of Puppet environments

```
~# /opt/codingfuture/bin/cf_r10k_deploy
```

### Automatic deployment via VCS (git) hook
```
~# ssh deploypuppet@puppet.example.com sudo /opt/codingfuture/bin/cf_r10k_deploy
```


## Setup

### Initial Puppet Server infrastructure

Either do manually (preferred for self-education) or use bundled [setup script](https://github.com/codingfuture/puppet-cfpuppetserver/blob/master/setup_puppetserver.sh):
```
~# ./setup_puppetserver.sh
Usage: ./setup_puppetserver.sh <r10k_repo_url> [<certname=hostname> [<cflocation> [<cflocationpool> [<http_proxy=$http_proxy>] ] ] ]
```

### Config for Puppet Server node

Please use [librarian-puppet](https://rubygems.org/gems/librarian-puppet/) to deal with dependencies.
If this module is used for server setup then librarian-puppet is installed automatically.

There is a known r10k issue [RK-3](https://tickets.puppetlabs.com/browse/RK-3) which prevents
automatic dependencies of dependencies installation.

## Examples

Please check [codingufuture/puppet-test](https://github.com/codingfuture/puppet-test) for
example of a complete infrastructure configuration and Vagrant provisioning.


## `cfpuppetserver` class

* `deployuser = 'deploypuppet'` - user name for auto deploy user for VCS hook
* `deployuser_auth_keys = undef` - list of ssh_authorized_keys configurations
* `repo_url = undef` - repository location in URI format (e.g. ssh://user@host/repo or file:///some/path)
* `puppetserver = true` - if true then assume Puppet Server lives on this host (affects firewall)
* `puppetdb = true` - if true then assume Puppet DB lives on this host (affects firewall)
* `puppetdb_port = 8081` - port to use for Puppet DB
* `setup_postgresql = true` - if true and $puppetdb == true then install and configure PostgreSQL as well
* `service_face = 'any'` - `cfnetwork::iface` name to listen for incoming client connections
* `puppetserver_mem = auto` - memory in MB to use for Puppet Server, if installed
* `puppetdb_mem = auto` - memory in MB to use for Puppet DB, if installed
* `postgresql_mem = auto` - memory in MB to use for PostgreSQL, if installed
* `allow_update_check = false` - open firewall to connect to updates.puppetlabs.com, if enabled

## `cfpuppetserver::puppetdb` class

* `postgresql_host = 'localhost'` - PostgreSQL host to listen and connect
* `postgresql_listen = $postgresql_host` - goes into PostgreSQL listen configuration
* `postgresql_port = 5432` - PostgreSQL port to listen and connect
* `postgresql_user = 'puppetdb'` - PostgreSQL user
* `postgresql_pass = 'puppetdb'` - PostgreSQL password
* `postgresql_ssl  = false` - enable SSL for PostgreSQL connection (uses Puppet's PKI)


## `cfpuppetserver::puppetserver` class

* `autosign = false` - DO NOT use in production. Enable auto-sign of client certificates.
* `global_hiera_config = 'cfpuppetserver/hiera.yaml'` - default global Hiera config


[cfnetwork]: https://github.com/codingfuture/puppet-cfnetwork
[cfsystem]: https://github.com/codingfuture/puppet-cfsystem
