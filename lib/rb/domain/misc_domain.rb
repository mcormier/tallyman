class MiscDomain < Domain

  def create_action( db, config )
    count_action = CountAction.new(db)
    PPCurses::ShowMenuAction.new(count_action.menu)
  end

end