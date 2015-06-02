class LiftingDomain < Domain

  @@lift_list =  ['Deadlift', 'Shoulder Press', 'Clean', 'Front Squat', 'Push Jerk', 'Overhead Squat', 'Snatch']


  def create_action( db, config )
    load_config(config)      
    LiftAction.new(enabled_lifts_list)    
  end


  def enabled_lifts_list
    @lifting_config.disabled_lifts

    lift_set = @@lift_list.to_set

    lift_set.subtract( @lifting_config.disabled_lifts).to_a
  end


  def load_config( config )
    @lifting_config = config.get_domain_config('lifting')

    if @lifting_config.nil?
      @lifting_config = LiftingConfig.new
    end
  end


  def receive_message(menu_item)

    title = menu_item.title

    if menu_item.state == PPCurses::PP_OFF_STATE
      @lifting_config.disabled_lifts.add(title)
    else
      @lifting_config.disabled_lifts.delete(title)
    end
  end


  # Displays a selectable list of lifts.
  def config_action( config )

    load_config(config)

    lift_menu_items = []

    @@lift_list.each do |lift_name|
      item = PPCurses::MenuItem.new(lift_name )
      item.selectable=true

      unless @lifting_config.lift_enabled?(lift_name)
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

  attr_accessor :disabled_lifts

  def initialize
    @disabled_lifts = Set.new
  end

  def lift_enabled?(lift_name)
    if @disabled_lifts.nil?
      return true
    end

    @disabled_lifts.member?(lift_name)

  end


end