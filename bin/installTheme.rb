#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'

script_location = File.expand_path File.dirname(__FILE__)
to_load = script_location + '/../config/config.properties'
load to_load

@theme_root = script_location + '/../data/themes/'


def copyThemeDirToWebRoot(dirName)

  theme_dir = "#{@theme_root}#{@theme}/#{dirName}"
  web_dir="#{@webRoot}/#{dirName}" 
     
  if File.exists?(theme_dir) 
  then
    Dir.mkdir(web_dir) unless File.exists?(web_dir)
	
	FileUtils.cp_r theme_dir, web_dir, :verbose => true
  end
  
  
end

copyThemeDirToWebRoot( "fonts" )
copyThemeDirToWebRoot( "images" )
copyThemeDirToWebRoot( "css" )
copyThemeDirToWebRoot( "js" )

FileUtils.cp_r "#{@theme_root}#{@theme}/html/.", "#{@webRoot}", :verbose => true
