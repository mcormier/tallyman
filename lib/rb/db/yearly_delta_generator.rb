
class YearlyDeltaGenerator

  def initialize(out_file, db, lifts)
    @db = db
    @out_file = out_file
    @lifts = lifts
    @xmlEncoding = "ASCII"
  end


  def max_lift_for_year( db, lift_name, year)
    return_val = '0'
    query ='SELECT MAX(weight), day  FROM lifts WHERE name=? and reps=1 and date(day) < date(?);'
    year_str = year.to_s + '-12-31'

    value = db.get_first_value query, lift_name, year_str
    unless value.nil? then
      return_val = value
    end

    return_val
  end

  def generate_xml
    x = Builder::XmlMarkup.new( :indent => 2 )
    db = SQLite3::Database.open @db
    x.instruct! :xml, :encoding => @xmlEncoding

    File.open( @out_file, 'w' ) do |out|
      out.puts x.data {

        x.lifts {
          @lifts.each do |lift|
            begin

              x.lift {
                x.name lift
                x.max2012 max_lift_for_year( db, lift, 2012)
                x.max2013 max_lift_for_year( db, lift, 2013)
                x.max2013 max_lift_for_year( db, lift, 2014)
              }
            ensure
              #stm.close
            end
          end
        }
      }

    end

  end

end
