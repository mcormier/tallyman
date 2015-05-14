class MusicAction_10

  attr_accessor :form
  attr_accessor :btn_submit, :btn_cancel

  def initialize(db)
    @db = db

    @form = PPCurses::Form.new

    media =  PPCurses::RadioButtonGroup.new(' Media Type', %w(CD Vinyl MP3) )
    artist = PPCurses::InputElement.new('      Artist', 20)
    title =  PPCurses::InputElement.new(' Album Title', 20)
    price =  PPCurses::InputElement.new_integer_only('       Price', 10)
    used =   PPCurses::RadioButtonGroup.new('  Condition', %w(Used New) )

    buttons = PPCurses::ButtonPair.new('Cancel', 'Submit')
    @btn_cancel = buttons.button1
    @btn_submit = buttons.button2
    
    @form.add(media)
    @form.add(artist)
    @form.add(title)
    @form.add(price)
    @form.add(used)
    @form.add(buttons)
    
    @form.setFrameOrigin( PPCurses::Point.new(1, 2) )
    
  end


  # TODO duplicate logic
  def after_actions

  end

end

# @deprecated.  Remove in Tallyman 1.4.
class MusicAction < PPCurses::InsertSQLDataAction

  def initialize(db)
    @db = db

    super( [PPCurses::GetEnumeratedStringAction.new('Media Type? ',
                                                    %w(CD Vinyl MP3)),
            PPCurses::GetStringAction.new('Artist: '),
            PPCurses::GetStringAction.new('Album Title: '),
            PPCurses::GetIntegerAction.new('Price: '),
            PPCurses::GetBooleanAction.new('Used? '), ],
           'INSERT into music(media, artist, albumTitle, price, used) values (?, ?, ?, ?, ?)', db )

  end



  # TODO duplicate logic
  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to('music')
    end

  end

end