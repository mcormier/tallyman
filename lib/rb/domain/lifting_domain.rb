class LiftingDomain < Domain

  @@lift_list =  ['Deadlift', 'Shoulder Press', 'Clean', 'Front Squat', 'Push Jerk', 'Overhead Squat', 'Snatch']

  def create_action( db )

    # TODO -- make configurable
    # TODO -- Push 1/3/5 RM selection inside menu
    lift_rep_menu = PPCurses::RadioMenu.new( %w(1RM 3RM 5RM), nil )
    lift_type_menu = PPCurses::Menu.new( @@lift_list , nil )
    lifts_menu = PPCurses::CompositeMenu.new( lift_type_menu, lift_rep_menu )
    add_lift_action = LiftAction.new( lift_type_menu, lift_rep_menu, db )

    lift_type_menu.set_global_action(add_lift_action)

    PPCurses::ShowMenuAction.new(lifts_menu)
  end


  # TODO -- display a selectable list of lifts.
  def config_action( config )

    lift_menu_items = []

    @@lift_list.each do |lift_name|
      item = PPCurses::MenuItem.new(lift_name )
      item.selectable=true
      # TODO -- get item state from the config object.
      lift_menu_items.push(item)
    end

    config_menu = PPCurses::Menu.new( lift_menu_items, nil )
    #config_menu.show
    #config_menu.menu_selection
    PPCurses::ShowMenuAction.new(config_menu)
  end

end