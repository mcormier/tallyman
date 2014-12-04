class MusicAction_10


  def initialize(db)
    @db = db

    @win = Window.new(9,60,0,0)
    @win.keypad(true)
    @win.box('|', '-')
    @form = PPCurses::Form.new(@win)

    media = PPCurses::RadioButtonGroup.new('      Media Type', %w(CD Vinyl MP3) )
    artist = PPCurses::InputElement.new('Artist', 20)
    title = PPCurses::InputElement.new(' Album Title', 10)
    price = PPCurses::InputElement.new(' Price', 10)
    used = PPCurses::RadioButtonGroup.new('  ', %w(Used New) )

    @form.add(media)
    @form.add(artist)
    @form.add(title)
    @form.add(price)
    @form.add(used)

  end

  def execute
    @form.handle_input

    @win.clear
    @win.refresh
  end

  # TODO duplicate logic
  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to('music')
    end

  end

end

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