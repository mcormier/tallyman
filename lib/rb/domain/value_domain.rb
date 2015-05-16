class ValueDomain < Domain

  def create_action ( db, config )
    value_action = ValueAction_10.new(db)    
  end

end