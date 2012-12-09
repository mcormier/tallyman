#!/Users/mcormier/.rvm/rubies/ruby-1.9.2-p136/bin/ruby


# Curses reference:
# http://www.ruby-doc.org/stdlib-1.9.3/libdoc/curses/rdoc/Curses.html

require './ppcurses/Menu.rb'
require './ppcurses/RadioMenu.rb'
require './ppcurses/CompositeMenu.rb'
require './ppcurses/Actions.rb'

require "curses"
require "sqlite3"
include Curses


init_screen
begin
  Curses.raw
  clear
  curs_set(0) # Makes cursor invisible
  noecho
  cbreak
  start_color


  db = SQLite3::Database.open "myData2013.db"

  liftFreqMenu = RadioMenu.new( [ "1RM", "3RM", "5RM" ], nil )

  liftTypeMenu = Menu.new( [ "Back Squat","Clean", "Squat Clean", "Clean & Jerk",
                          "Deadlift", "Front Squat", "Overhead Squat",
                          "Push Jerk", "Push Press", "Shoulder Press",
                          "Snatch", "Squat Snatch", "Sots Press" ], nil )

  liftsMenu = CompositeMenu.new( liftTypeMenu, liftFreqMenu )

  bookAction = InsertSQLDataAction.new( [GetStringAction.new("Book name: "), 
                                   GetIntegerAction.new("Number of pages: ") ], 
                "INSERT into books(name, pages) values ('%s', %s)", db )


  liftsAction = ShowMenuAction.new(liftsMenu)  

  mainMenu = Menu.new( [ "Book","Lifts"], [ bookAction, liftsAction ] )

  mainMenu.show()
  mainMenu.getMenuSelection() 
  
  mainMenu.close()

ensure
  close_screen
  db.close if db
end
