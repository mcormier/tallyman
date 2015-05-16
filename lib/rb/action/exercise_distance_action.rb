#
# Can be used for tracking an exercise that has time and distance.
#
# - Biking
# - Walking
# - Running
# - Swimming
#
class ExerciseDistanceAction
  
  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel
  
  def initialize
    @form = PPCurses::Form.new
    
    @distance = PPCurses::InputElement.new_integer_only(' Distance', 10)
    @duration = PPCurses::InputElement.new_integer_only(' Duration', 10)
    @day = PPCurses::DatePicker.new( '   Day')

    
    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(@distance)
    @form.add(@duration)
    @form.add(@day)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end

end


class ExerciseDistanceAction_old < PPCurses::InsertSQLDataAction

  def initialize(db, table_name)
    @db = db
    @table_name = table_name

    super( [PPCurses::GetIntegerAction.new('Distance: '),
            PPCurses::GetIntegerAction.new('Duration: '), ],
           "INSERT into #{@table_name}(distance_km, duration ) values (?, ?)", db )
  end


  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to( @table_name )
    end

  end

end