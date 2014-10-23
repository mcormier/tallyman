require 'set'

module Tallyman


  class Config

    attr_accessor :enabled_domains
    attr_accessor :domain_configs

    def enable_domain( domain_name )
      if @enabled_domains.nil?
        @enabled_domains = Set.new
      end

      @enabled_domains.add(domain_name)
    end

    def disable_domain( domain_name )
      if @enabled_domains.nil?
        return
      end

      @enabled_domains.delete(domain_name)
    end

    def domain_enabled?(domain_name)
      if @enabled_domains.nil?
        return false
      end

      @enabled_domains.member?(domain_name)

    end


    def get_domain_config(key)
      if @domain_configs.nil?
        @domain_configs = Hash.new
      end

      @domain_configs[key]
    end

    def set_domain_config(config_obj, key)
      if @domain_configs.nil?
        @domain_configs = Hash.new
      end

      @domain_configs[key] = config_obj
    end



  end

end