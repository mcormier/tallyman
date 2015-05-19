class ReadingAction

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize
    @form = PPCurses::Form.new
     
    @title =  PPCurses::InputElement.new('   Title', 30)
    @author =  PPCurses::InputElement.new('  Author', 30)
    @pages =  PPCurses::InputElement.new_integer_only('   Pages', 10)
    @format =   PPCurses::RadioButtonGroup.new(' Format', %w(Digital Analog) )
    @finished_date = PPCurses::DatePicker.new( 'Finished')
      
    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(@title)
    @form.add(@author)
    @form.add(@pages)
    @form.add(@format)
    @form.add(@finished_date)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end

  def clear
    @form.clear    
  end

 def data_array
    data = []
    
    data.push( @title.value )
    data.push( @author.value )
    # digital
    case @format.current_option
      when 0
        data.push(1)
      when 1 
        data.push(0)
    end
        
    data.push( @pages.value )
    
    date = @finished_date.date
    data.push(date.strftime('%Y-%m-%d') )
    
    
    data
    
 end
 

end
