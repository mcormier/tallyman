
#
# Wraps a prepared statement
#
class StatementWrapper

  def initialize ( stmt, dbProxy )
    @delegate = stmt
    @dbProxy = dbProxy
  end

  def bind_params (data)
    @delegate.bind_params(data)
  end

  def execute()
    @delegate.execute()
    @dbProxy.incrementInsert()
  end

  def close()
    @delegate.close()
  end

end