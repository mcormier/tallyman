module Tallyman

  class ConfigLoader

    def load
      if File.exist?(config_file)
        Psych.load_file(config_file)
      else
        unless File.exist?(config_dir)
          FileUtils.mkdir_p(config_dir)
        end
        Config.new
      end

    end

    def save(config)
      File.open(config_file, 'w') { |file| file.write (config.to_yaml) }
    end

    def config_file
      config_dir + 'config.yaml'
    end

    def config_dir
      ENV['HOME']+'/.config/tallyman/'
    end

  end

end
