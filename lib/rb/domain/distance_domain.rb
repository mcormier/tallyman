class DistanceDomain < Domain

  def create_action( db, config )
    ExerciseDistanceAction.new
  end

end
