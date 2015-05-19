class LiftAction

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize( enabled_lifts )
    @form = PPCurses::Form.new
    
    @lift = PPCurses::ComboBox.new('   Lift', enabled_lifts)
    @reps = PPCurses::RadioButtonGroup.new('  Reps', %w(1RM 3RM 5RM) )
    @weight = PPCurses::InputElement.new_integer_only(' Weight', 5)
    @day = PPCurses::DatePicker.new( '    Day')

    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2

    @form.add(@lift)
    @form.add(@reps)
    @form.add(@weight)
    @form.add(@day)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end
  
  def clear
    @form.clear    
  end

  def data_array
    data = []
  
    data.push(@lift.object_value_of_selected_item)
    
    data.push(@weight.value)
    
    case @reps.current_option
      when 0
        data.push(1)
      when 1 
        data.push(3)
      when 2
        data.push(5)
    end
        
    
    date = @day.date
    data.push(date.strftime('%Y-%m-%d') )
    
    data
  end


end
