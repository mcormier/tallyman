class ReadingDomain < Domain

  def create_action( db, config )
    BookAction.new(db)
  end

end