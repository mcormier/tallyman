class DistanceDomain < Domain

  def create_action( db )
    ExerciseDistanceAction.new(db, table_name)
  end

end
