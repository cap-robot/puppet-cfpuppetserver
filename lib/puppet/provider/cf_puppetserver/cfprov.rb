
require File.expand_path( '../../../../puppet_x/cf_puppet_server', __FILE__ )


Puppet::Type.type(:cf_puppetserver).provide(
    :cfprov,
    :parent => PuppetX::CfPuppetServer::ProviderBase
) do
    desc "Provider for cfdb_access"
    
    commands :sudo => '/usr/bin/sudo'
    commands :systemctl => '/bin/systemctl'
    commands :netstat => '/bin/netstat'
    
    def self.get_config_index
        'cf20puppet1server'
    end

    def self.get_generator_version
        cf_system().makeVersion(__FILE__)
    end
    
    def self.check_exists(params)
        debug("check_exists: #{params}")
        begin
            systemctl(['status', "#{params[:service_name]}.service"])
        rescue => e
            warning(e)
            #warning(e.backtrace)
            false
        end
    end    

    def self.on_config_change(newconf)
        debug('on_config_change')
        
        newconf = newconf[newconf.keys[0]]
        service_name = newconf[:service_name]
        
        avail_mem = cf_system.getMemory(service_name)
        heap_mem = (avail_mem * 0.95).to_i
        
        conf_root_dir = '/etc/puppetlabs/puppetserver'
        conf_dir = "#{conf_root_dir}/conf.d"
        
        need_restart = false
        
        # Service File
        #==================================================
        content_ini = {
            'Unit' => {
                'Description' => "CF PuppetServer",
            },
            'Service' => {
                'ExecStart' => [
                    '/usr/bin/java',
                    '-XX:OnOutOfMemoryError=kill\s-9\s%%p',
                    '-Djava.security.egd=/dev/urandom',
                    "-Xmx#{heap_mem}m",
                    "-Xms#{heap_mem}m",
                    "-cp /opt/puppetlabs/server/apps/puppetserver/puppet-server-release.jar",
                    'clojure.main -m puppetlabs.trapperkeeper.main',
                    '--config ', conf_dir,
                    "-b #{conf_root_dir}/bootstrap.cfg",
                ].join(' '),
                'WorkingDirectory' => conf_root_dir,
            },
        }
        
        service_changed = self.cf_system().createService({
            :service_name => service_name,
            :user => 'puppet',
            :content_ini => content_ini,
            :cpu_weight => newconf[:cpu_weight],
            :io_weight => newconf[:io_weight],
            :mem_limit => avail_mem,
            :mem_lock => true,
        })
        
        need_restart ||= service_changed
        
        # during migration
        cf_system.maskService('puppetserver')

        #==================================================
        
        if need_restart
            warning(">> reloading #{service_name}")
            systemctl('restart', "#{service_name}.service")
            wait_sock(service_name, 8140)
        end        
    end
end
