#noinspection RubyResolve
require_relative 'statement_wrapper'

# References
#
# http://www.rubydoc.info/gems/sqlite3/1.3.10/SQLite3/Statement
#
# http://www.rubydoc.info/gems/sqlite3/1.3.10/SQLite3/Database

#
# A wrapper that counts the number of SQL statements executed
#
#noinspection RubyResolve
class DatabaseProxy  < SQLite3::Database


  attr_accessor :modified_table_set
  attr_reader :insert_count

  def initialize ( database_name )
    super(database_name)
    @insert_count = 0
    @modified_table_set = Set.new
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


  def table_exists?( table_name )
    info = table_info(table_name)

    if info.length == 0
      return false
    end

    true
  end


  def increment_insert
    @insert_count = @insert_count + 1
  end


  def data_added_to(table_name)
    @modified_table_set.add(table_name)
  end

end