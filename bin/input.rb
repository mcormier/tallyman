#!/usr/bin/ruby

# Curses reference:
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/curses/rdoc/Curses.html

require './ppcurses/Menu.rb'
require './ppcurses/RadioMenu.rb'
require './ppcurses/CompositeMenu.rb'
require './ppcurses/Actions.rb'


require 'rubygems'
require "curses"
require "sqlite3"
include Curses

load '../config/config.properties'

init_screen
begin
  Curses.raw
  clear
  curs_set(0) # Makes cursor invisible
  noecho
  cbreak
  start_color


  db = SQLite3::Database.open @dbName

  liftRepMenu = RadioMenu.new( [ "1RM", "3RM", "5RM" ], nil )

  liftTypeMenu = Menu.new( @lifts, nil )

  liftsMenu = CompositeMenu.new( liftTypeMenu, liftRepMenu )
  addLiftAction = LiftAction.new( liftTypeMenu, liftRepMenu, db )

  liftTypeMenu.setGlobalAction(addLiftAction)

  bookAction = InsertSQLDataAction.new( [GetStringAction.new("Book name: "), 
                                   GetIntegerAction.new("Number of pages: ") ], 
                "INSERT into books(name, pages) values ('%s', %s)", db )


  liftsAction = ShowMenuAction.new(liftsMenu)  

  mainMenu = Menu.new( [ "Add Book","Add Lift"], [ bookAction, liftsAction ] )

  mainMenu.show()
  mainMenu.getMenuSelection() 
  
  mainMenu.close()

ensure
  close_screen
  db.close if db
end
