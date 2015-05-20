class ValueDomain < Domain

  def create_action ( db, config )
    value_action = ValueAction.new(db)    
  end

end