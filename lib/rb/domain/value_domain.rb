class ValueDomain < Domain

  def create_action ( db )
    value_action = ValueAction.new(db)
    PPCurses::ShowMenuAction.new(value_action.menu)
  end

end