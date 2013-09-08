require 'ppcurses'

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