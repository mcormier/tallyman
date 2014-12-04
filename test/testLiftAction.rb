#!/usr/bin/env ruby

gem 'ppcurses', '=0.0.25'
require 'ppcurses'

require_relative '../lib/rb/tallyman'




def doAction(action)
  action.show
  action.execute
end


db = SQLite3::Database.open 'test.db'
db.execute <<-SQL
  create table lifts (name varchar(30), weight int, reps int);
SQL

screen = PPCurses::Screen.new



screen.run {
  liftRepMenu = PPCurses::RadioMenu.new( %w(1RM 3RM 5RM), nil )
  liftTypeMenu = PPCurses::Menu.new( [ 'Deadlift', 'Shoulder Press', 'Back Squat'], nil )


  liftAction = LiftAction.new( liftTypeMenu, liftRepMenu, db)

  doAction(liftAction) }


db.close
File.delete('test.db')


