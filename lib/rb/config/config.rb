require 'set'

module Tallyman


  class Config

    attr_accessor :enabled_domains

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

  end

end