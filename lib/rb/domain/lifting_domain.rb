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


  def receive_message(menu_item)

    title = menu_item.title

    if menu_item.state == PPCurses::PP_ON_STATE
      @lifting_config.enabled_lifts.add(title)
    else
      @lifting_config.enabled_lifts.delete(title)
    end
  end



  # Displays a selectable list of lifts.
  def config_action( config )

    @lifting_config = config.get_domain_config('lifting')

    if @lifting_config.nil?
      @lifting_config = LiftingConfig.new
    end

    lift_menu_items = []

    @@lift_list.each do |lift_name|
      item = PPCurses::MenuItem.new(lift_name )
      item.selectable=true

      if @lifting_config.lift_enabled?(lift_name)
        item.state=PPCurses::PP_ON_STATE
      end

      item.target=method(:receive_message)

      lift_menu_items.push(item)
    end


    config.set_domain_config( @lifting_config, 'lifting')

    config_menu = PPCurses::Menu.new( lift_menu_items, nil )
    PPCurses::ShowMenuAction.new(config_menu)
  end

end


class LiftingConfig

  attr_accessor :enabled_lifts

  def initialize
    @enabled_lifts = Set.new
  end

  def lift_enabled?(lift_name)
    if enabled_lifts.nil?
      return false
    end

    enabled_lifts.member?(lift_name)

  end


end