#!/usr/bin/ruby

require 'rubygems'
require 'builder'
require "sqlite3"

load 'config.properties'

def queryLiftData( db, query, liftname, rep)
  retVal = "0"

  value = db.get_first_value query, liftname, rep 
  if not value.nil? then
    retVal = value
  end

  return retVal
end




begin
  x = Builder::XmlMarkup.new( :indent => 2 )
  db = SQLite3::Database.open @dbName
  x.instruct! :xml, :encoding => @xmlEncoding

  File.open( @outputFile, 'w' ) do |out|

  out.puts x.data {
    @outputQueries.each do |queryInfo|
      begin
        stm = db.prepare queryInfo[0]
        rs = stm.execute
        row = rs.next
        x.item{
          x.title queryInfo[1]
          x.value row.join "\s"
        }
      ensure
        stm.close
      end
    end

    x.lifts {
    @lifts.each do |lift|
      begin
        
        x.lift {
          x.name lift

          x.onerm queryLiftData( db, @liftQuery, lift, 1)
          x.threerm queryLiftData( db, @liftQuery, lift, 3)  
          x.fiverm  queryLiftData( db, @liftQuery, lift, 5)
        }
      ensure
        #stm.close
      end
    end
    }
  }

 

  end

rescue SQLite3::Exception => e
  puts "Exception occurred"
  puts e.message

ensure
  db.close if db
end
