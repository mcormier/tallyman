#noinspection RubyResolve
require 'sqlite3'
require 'set'
require_relative 'statement_wrapper'

# References
#
# http://sqlite-ruby.rubyforge.org/sqlite3/classes/SQLite3/Statement.html
#
# http://sqlite-ruby.rubyforge.org/sqlite3/classes/SQLite3/Database.html

#
# A wrapper that counts the number of SQL statements executed
#
#noinspection RubyResolve
class DatabaseProxy  < SQLite3::Database


  attr_accessor :modified_table_set

  def initialize ( database_name )
    super(database_name)
    @insert_sql_count = 0

    @modified_table_set = Set.new()

  end


  #
  # return a prepared statement wrapper if it is an insert
  # statement so we can count inserts
  #
  def prepare( sql )
    stmt = super(sql)

    if sql.include? 'INSERT'
      wrapper = StatementWrapper.new(stmt, self)
      return wrapper
    end

    stmt
  end

  def increment_insert
    @insert_sql_count = @insert_sql_count + 1
  end

  def insert_count
    @insert_sql_count
  end



  def data_added_to(table_name)
    @modified_table_set.add(table_name)
  end

end