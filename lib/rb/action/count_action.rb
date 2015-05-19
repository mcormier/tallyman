class CountAction

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize(db)
  
    begin
      statement = db.prepare('SELECT DISTINCT event FROM countTable ORDER BY event ASC')
      rs = statement.execute

      count_types = []
      rs.each do |row|
        count_types.push(row[0])
      end

    ensure
      statement.close
    end
    
    
    @form = PPCurses::Form.new
    
    @event = PPCurses::ComboBox.new(' Event', count_types)
    @day = PPCurses::DatePicker.new( '   Day')

    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2

    @form.add(@event)
    @form.add(@day)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )

  end

  def clear
    @form.clear    
  end


  def data_array
    data = []
    
    data.push(@event.object_value_of_selected_item)
    
    date = @day.date
    data.push(date.strftime('%Y-%m-%d') )
    
    data
  end

end
