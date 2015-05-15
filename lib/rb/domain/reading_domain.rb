class ReadingDomain < Domain

  def create_action( db, config )
    ReadingAction.new
  end

end