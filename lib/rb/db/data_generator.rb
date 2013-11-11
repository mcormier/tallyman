
require 'builder'
require "sqlite3"

#
# Given a set of table names generates an XML delta file
#
# <data>
#  <settings>
#     <enableGraphs>true</enableGraphs>
#  </settings>
#  <item>
#    <title>Books Read</title>
#    <value>8</value>
#  </item>
#  <item>
#    <title>Total Pages Read</title>
#    <value>2586</value>
#  </item>
#  <lifts>
#    <lift>
#      <name>Deadlift</name>
#      <svgname>deadlift</svgname>
#      <onerm>330</onerm>
#      <threerm>310</threerm>
#      <fiverm>270</fiverm>
#    </lift>
#  <lifts>


class DataGenerator

  def initialize(out_file, db, item_queries, lifts, lift_query)
    @db = db
    @out_file = out_file
    @item_queries = item_queries
    @lifts = lifts
    @lift_query = lift_query
  end


  def query_lift_data( db, query, lift_name, rep)
    return_value = '0'

    value = db.get_first_value query, lift_name, rep
    unless value.nil? then
      return_value = value
    end

    return_value
  end


  def get_svg_lift_name( name )
    lower = name.downcase
    replace_ampersand = lower.gsub(/&/, 'and')
    replace_ampersand.gsub(/\s+/, '')
  end

  #  <item>
  #    <title>Books Read</title>
  #    <value>8</value>
  #  </item>
  #  <item>
  #    <title>Total Pages Read</title>
  #    <value>2586</value>
  #  </item>
  def create_items(db, x)
    @item_queries.each do |queryInfo|
      begin
        stm = db.prepare queryInfo[1]
        rs = stm.execute
        row = rs.next
        x.item{
          x.title queryInfo[0]
          x.value row.join "\s"
        }
      ensure
        stm.close
      end
    end
  end


  #  <lifts>
  #    <lift>
  #      <name>Deadlift</name>
  #      <svgname>deadlift</svgname>
  #      <onerm>330</onerm>
  #      <threerm>310</threerm>
  #      <fiverm>270</fiverm>
  #    </lift>
  #  <lifts>
  def create_lifts(db, x)
    x.lifts {
      @lifts.each do |lift|
        begin

          x.lift {
            x.name lift
            x.svgname get_svg_lift_name(lift)

            x.onerm query_lift_data( db, @lift_query, lift, 1)
            x.threerm query_lift_data( db, @lift_query, lift, 3)
            x.fiverm  query_lift_data( db, @lift_query, lift, 5)
          }
        ensure
          #stm.close
        end
      end
    }
  end

  def generate_xml
    x = Builder::XmlMarkup.new( :indent => 2 )
    db = SQLite3::Database.open @db
    x.instruct! :xml, :encoding => @xmlEncoding

    File.open( @out_file, 'w' ) do |out|

      out.puts x.data {
        #x.settings {
        #  x.enableGraphs @enableGraphs
        #}

        create_items(db, x)
        create_lifts(db, x)

      }

    end

  end

end
