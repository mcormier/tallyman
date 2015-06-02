#!/usr/bin/env ruby

require_relative '../lib/rb/tallyman'


begin

  db = SQLite3::Database.open 'test.db'
  db.execute <<-SQL
    create table countTable(event varchar(256), day date default current_date );
  SQL

  db.execute <<-SQL
    insert into countTable (event) values ('Smoked Cigarette');
  SQL

  count_action = CountAction.new(db)

  @app = PPCurses::Application.new
  
  @app.content_view = count_action.form
 
  @app.launch

rescue SystemExit, Interrupt
  # Empty Catch block so ruby doesn't puke out
  # a stack trace when CTRL-C is used
ensure
  db.close if db
  File.delete('test.db')
end
