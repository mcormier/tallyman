require 'ppcurses'

class CyclingDomain < Domain

  def create_action( db )
    CycleAction.new(db, table_name)
  end

end



class CycleAction < PPCurses::InsertSQLDataAction

  def initialize(db, table_name)
    @db = db
    @table_name = table_name

    super( [PPCurses::GetIntegerAction.new('Distance: '),
            PPCurses::GetIntegerAction.new('Duration: '), ],
           "INSERT into #{@table_name}(distance_km, duration ) values (?, ?)", db )
  end


  def after_actions
    new_data_added = super

    if new_data_added then
      @db.data_added_to( @table_name )
    end

  end

end