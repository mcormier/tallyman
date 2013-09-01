require "sqlite3"
require_relative 'statement_wrapper'

# References
#
# http://sqlite-ruby.rubyforge.org/sqlite3/classes/SQLite3/Statement.html
#
# http://sqlite-ruby.rubyforge.org/sqlite3/classes/SQLite3/Database.html

#
# A wrapper that counts the number of SQL statements executed
#
class DatabaseProxy  < SQLite3::Database



  def initialize ( databaseName )
    super(databaseName)
    @insertSqlCount = 0
  end


  #
  # return a prepared statement wrapper if it is an insert
  # statement so we can count inserts
  #
  def prepare( sql )
    stmt = super(sql)

    if sql.include? "INSERT"
      wrapper = StatementWrapper.new(stmt, self)
      return wrapper
    end

    stmt
  end

  def incrementInsert
    @insertSqlCount = @insertSqlCount + 1
  end

  def insertCount
    @insertSqlCount
  end

end