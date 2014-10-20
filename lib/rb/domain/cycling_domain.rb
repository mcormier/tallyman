require 'ppcurses'

class CyclingDomain < Domain

  def create_action( db )
    CycleAction.new(db)
  end

end





class CycleAction < PPCurses::InsertSQLDataAction

  def initialize(db)
    @db = db

    # TODO - table name shouldn't be hard coded.
    super( [PPCurses::GetIntegerAction.new('Distance: '),
            PPCurses::GetIntegerAction.new('Duration: '), ],
           'INSERT into cycleLog(distance_km, duration ) values (?, ?)', db )
  end


  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to('cycleLog')
    end

  end

end