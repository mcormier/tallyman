require 'psych'

class DomainManager

  attr_reader :domains

  def initialize(domain_root)
    @domain_root = domain_root
    @domains = []
    @domain_paths = Dir.glob(@domain_root+'*/').select {|f| File.directory? f}

    @domain_paths.each do |path|
      config_file = path + 'config.yaml'
      if File.exist?(config_file)
        domain = Psych.load_file(path + 'config.yaml')
        @domains.push(domain)
      end

    end

  end


end