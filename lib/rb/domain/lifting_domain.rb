class LiftingDomain < Domain

  def create_action( db )

    # TODO -- make configurable
    # TODO -- Push 1/3/5 RM selection inside menu
    lift_rep_menu = PPCurses::RadioMenu.new( %w(1RM 3RM 5RM), nil )
    lift_type_menu = PPCurses::Menu.new( ['Deadlift', 'Shoulder Press', 'Clean', 'Front Squat', 'Push Jerk', 'Overhead Squat', 'Snatch'] , nil )
    lifts_menu = PPCurses::CompositeMenu.new( lift_type_menu, lift_rep_menu )
    add_lift_action = LiftAction.new( lift_type_menu, lift_rep_menu, db )

    lift_type_menu.set_global_action(add_lift_action)

    PPCurses::ShowMenuAction.new(lifts_menu)
  end



end