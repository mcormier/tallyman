#!/usr/bin/env ruby

gem 'ppcurses', '=0.0.25'
require 'ppcurses'

require_relative '../lib/rb/tallyman'


def get_data(db)
  count_action = CountAction.new(db)
  count_action.show
  count_action.menu_selection
end

begin

  db = SQLite3::Database.open 'test.db'
  db.execute <<-SQL
    create table countTable(event varchar(256), day date default current_date );
  SQL

  db.execute <<-SQL
    insert into countTable (event) values ('Smoked Cigarette');
  SQL

  screen = PPCurses::Screen.new
  screen.run { get_data(db) }

rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  db.close if db
  File.delete('test.db')
end
