#!/usr/bin/ruby

require 'rubygems'
require 'builder'
require "sqlite3"

load 'config.properties'


begin
  x = Builder::XmlMarkup.new( :indent => 2 )
  db = SQLite3::Database.open @dbName
  x.instruct! :xml, :encoding => @xmlEncoding

  File.open( @outputFile, 'w' ) do |out|

  out.puts x.data {
    @outputQueries.each do |queryInfo|
      stm = db.prepare queryInfo[0]
      rs = stm.execute
      row = rs.next
      x.item{
        x.title queryInfo[1]
        x.value row.join "\s"
      }
      stm.close
    end
  }

  end

rescue SQLite3::Exception => e
  puts "Exception occurred"
  puts e.message

ensure
  db.close if db
end
