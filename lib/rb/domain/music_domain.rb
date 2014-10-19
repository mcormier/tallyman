class MusicDomain < Domain

  def create_action( db )
    MusicAction.new(db)
  end

end