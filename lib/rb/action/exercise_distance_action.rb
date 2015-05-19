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
    
    @distance = PPCurses::InputElement.new_decimal_only(' Distance', 10)
    @duration = PPCurses::InputElement.new_time_only(' Duration', 10)
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

  def clear
    @form.clear    
  end

  def data_array
    data = []
    
    data.push(@distance.value)
    data.push(@duration.value)
        
    date = @day.date
    data.push(date.strftime('%Y-%m-%d') )
    
    data
  end

end
