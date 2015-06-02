class MusicDomain < Domain

  def create_action( db, config )
    MusicAction.new
  end

end