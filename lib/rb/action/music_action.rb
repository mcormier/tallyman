class MusicAction

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize

    @form = PPCurses::Form.new

    @media =  PPCurses::RadioButtonGroup.new('  Media Type', %w(CD Vinyl MP3) )
    @artist = PPCurses::InputElement.new('       Artist', 40)
    @title =  PPCurses::InputElement.new('  Album Title', 40)
    @price =  PPCurses::InputElement.new_decimal_only('        Price', 10)
    @used =   PPCurses::RadioButtonGroup.new('   Condition', %w(Used New) )
    @purchase_date = PPCurses::DatePicker.new( 'Purchase Date')

    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(@media)
    @form.add(@artist)
    @form.add(@title)
    @form.add(@price)
    @form.add(@used)
    @form.add(@purchase_date)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
    
  end

  def clear
    @form.clear    
  end

  def data_array
    data = []
    
    case @media.current_option
      when 0
        data.push('CD')
      when 1 
        data.push('Vinyl')
      when 2
        data.push('MP3')
    end
  
    data.push( @artist.value )
    data.push( @title.value )
    data.push( @price.value )
    
    case @used.current_option
      when 0
        data.push(1)
      when 1 
        data.push(0)
    end
    
    date = @purchase_date.date
    data.push(date.strftime('%Y-%m-%d') )
     
    data
  end



end