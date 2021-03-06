# Change Log

All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning](http://semver.org/).

## [0.9.7]
- Migrated to `cfdb` module for PostgreSQL provisioning and High Availability setup
- Cpmpletely rewritten PuppetDB configuration
- Many parameters change!
- Security enforcement for PuppetDB access authorization

## [0.9.6]
- Disabled scheduled agent runs safety purposes
- Added custom puppetserver.conf to mitigate memory leaks with JRuby tuning

## [0.9.5]
- Updated to Puppet 4.5.0
- Enforced strict mode checking
- Minor fixes
- Added $allow_update_check option
- Fixed minor issues in puppet server bootstrap script
- Updated to latest deps

## [0.9.4]
- Updated cfsystem to 0.9.9
- Changed to install all scripts under /opt/codingfuture/bin
    * cf_r10k_deploy
    * cf_gen_puppet_client_init

## [0.9.3]

- Fixed issues in deploy.sh under some conditions
    - Forcibly added Puppet bin folder to PATH
    - Fixed deploy.sh created by setup_puppetserver.sh bootstrap script

## [0.9.2]

- Fixed use_srv_records and ca_server puppet setting to depend on correct parameters
- Changed to use primary Puppet host for secondary Puppet servers
- Fixed dependency issues when installing Puppet Server from Puppet itself

## [0.9.1]

- Implemented proper 3 level Global Hiera -> Environment Data Provider -> Module Data Provider
  configuration lookup instead of pure Hiera-based
- Moved main PuppetServer to cfsystem module and added support for more paramaters from there
- Added checks for minimal configured RAM of each service
- Added advanced PostgreSQL configuration with SSL support based on Puppet's PKI
- Fixed not to reload PuppetServer on configuration change as it leads to aborted deployment run
- Removed installation of deep_merge gem
- Fixed slave Puppet Server provisioning issues
- Added Puppet environments to etckeeeper ignore
- Fixed to properly disable CA service on slave Puppet Server
- Updated bootstrap script to be more verbose and support autosigning configuration (for testing)
- Changed to deploy dependencies though librarian-puppet instead of builtin in r10k
- Updated Puppet client configs to support ca_server

## [0.9.0]

- Changed to use puppetlabs/postgresql and puppetlabs/puppetdb for installation
- Implemented full forceful setup of configuration
- Implemented `librarian-puppet` based dependency installation instead of not
   incomplete implementation in r10k. See [RK-3](https://tickets.puppetlabs.com/browse/RK-3).
    - No more need to include dependencies of dependencies in Puppetfile
    - Puppetfile.lock is now supported
- Bugfixes for parameter handling
- Bugfix: opened HTTPS port for Puppet Forge
- Added automatic memory limit configuration for installed services
- Changed $puppet_git_host to $repo_url
- Added new configuration variables

## [0.1.2]

- Added hiera.yaml version 4 support
- Added Puppt Server infrastructure initialization script

## [0.1.1]

- No changes (missed merge)

## [0.1.0]

Initial release

[0.9.6]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.6
[0.9.5]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.5
[0.9.4]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.4
[0.9.3]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.3
[0.9.2]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.2
[0.9.1]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.1
[0.9.0]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.9.0
[0.1.2]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.1.2
[0.1.1]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.1.1
[0.1.0]: https://github.com/codingfuture/puppet-cfpuppetserver/releases/tag/v0.1.0

