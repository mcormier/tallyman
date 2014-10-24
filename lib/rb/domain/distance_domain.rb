class DistanceDomain < Domain

  def create_action( db, config )
    ExerciseDistanceAction.new(db, table_name)
  end

end
