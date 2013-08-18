#!/usr/bin/env ruby

require 'rubygems'
require 'ppcurses'
require_relative '../bin/LiftAction.rb'

begin
  require 'sqlite3'
rescue LoadError => e
  abort 'Missing dependency! Run: gem install sqlite3'
end


def doAction(action)
  action.show()
  action.execute()
end


db = SQLite3::Database.open 'test.db'
db.execute <<-SQL
  create table lifts (name varchar(30), weight int, reps int);
SQL

screen = PPCurses::Screen.new()



screen.run {
  liftRepMenu = PPCurses::RadioMenu.new( [ "1RM", "3RM", "5RM" ] , nil )
  liftTypeMenu = PPCurses::Menu.new( [ "Deadlift", "Shoulder Press", "Back Squat"], nil )


  liftAction = LiftAction.new( liftTypeMenu, liftRepMenu, db)

  doAction(liftAction) }


db.close
File.delete('test.db')


