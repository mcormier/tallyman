#!/usr/bin/env ruby

gem 'ppcurses', '=0.0.25'
require 'ppcurses'

require_relative '../lib/rb/tallyman'

load '../config/config.properties'

def getData(db)
  countAction = CountAction.new(db)
  countAction.show()
  countAction.menu_selection()
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
