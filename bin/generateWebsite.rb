#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

@theme_root = script_location + '/../data/themes/' + @theme

#----------------------------
# Extract phase
#----------------------------
extract_root= @theme_root + '/_extract/'

# Process all rb files in the theme _extract directory
Dir.glob(extract_root + '*.rb') do |rb_file|
  require rb_file
end



#----------------------------
# Transform phase
#----------------------------
transform_root= @theme_root +'/_transform/'

# Process all rb files in the theme _extract directory
Dir.glob(transform_root + '*.rb') do |rb_file|
  require rb_file
end

