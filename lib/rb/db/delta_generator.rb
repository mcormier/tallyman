#noinspection RubyResolve
require 'builder'

#
# Given a set of table names generates an XML delta file
#
# <delta>
#   <table>lifts</table>
# </delta>
#
# noinspection RubyResolve
class DeltaGenerator

  def initialize(delta_set)
    @delta_set = delta_set
  end

  def generate( filename = nil)
    delta_array = @delta_set.to_a()

    if filename.nil? then
      out = STDOUT
    else
      out = File.open(filename, 'w')
    end

    x = Builder::XmlMarkup.new( :indent => 2 )
    x.instruct! :xml, :encoding => 'ASCII'

    out.puts x.delta {
      delta_array.each do |table_name|
        x.table table_name
      end
    }
  end

end