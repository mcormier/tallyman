class MusicDomain < Domain

  def create_action( db, config )
    MusicAction_10.new
  end

end