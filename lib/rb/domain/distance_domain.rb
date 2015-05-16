class DistanceDomain < Domain

  def create_action( db, config )
    ExerciseDistanceAction.new ( self.table_name )
  end

end
