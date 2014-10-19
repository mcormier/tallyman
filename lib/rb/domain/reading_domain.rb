class ReadingDomain < Domain

  def create_action( db )
    BookAction.new(db)
  end

end