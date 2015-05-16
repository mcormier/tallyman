class DistanceDomain < Domain

  def create_action( db, config )
    # TODO send in table_name
    ExerciseDistanceAction.new
  end

end
