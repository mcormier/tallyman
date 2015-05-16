class GasAction
  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel
  
  def initialize
    
	@form = PPCurses::Form.new
	
	@unit_price = PPCurses::InputElement.new_integer_only(' Unit Price', 10)
    @cost = PPCurses::InputElement.new_integer_only('       Cost', 10)
    @day = PPCurses::DatePicker.new( '   Day')
	
	buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
	    
    @form.add(@unit_price)
    @form.add(@cost)
    @form.add(@day)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
  end
  
  
  
end