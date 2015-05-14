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



  def get_menu_actions(config, db)
    
    actions = []
    
      @domains.each do |domain|
    
        if config.domain_enabled?(domain.module_name)
    
          # Create the table if it is missing.  Must be the first time the
          # domain was used.
          unless db.table_exists?(domain.table_name)
            prep_statement = db.prepare(domain.create_table_statement)
            prep_statement.execute
            prep_statement.close
          end
          
          notary = PPCurses::NotificationCentre.default_centre
          action = domain.create_action(db, config)
          
          actions.push( action )
     
    
        end
    
      end
    
      actions
  end

  # Convenience method that prints all the loaded domains
  # to standard output. If a configuration is passed int
  def print_domains( config=nil )
      
    @domains.each do |domain|
      module_name = domain.module_name   
      
      if config!= nil and config.domain_enabled?(module_name)
        puts "✓ #{module_name}"
      else
        puts "  #{module_name}"
      end
    end
      
      
  end


end