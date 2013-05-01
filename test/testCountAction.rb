#!/usr/bin/env ruby

require 'ppcurses'
require 'rubygems'
require "sqlite3"
require_relative '../bin/CountAction.rb'

load '../config/config.properties'

def getData(db)
  countAction = CountAction.new(db)
  countAction.show()
  countAction.getMenuSelection() 
end

begin
  db = SQLite3::Database.open @dbName

  screen = PPCurses::Screen.new()
  screen.run { getData(db) }

rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  db.close if db
end
