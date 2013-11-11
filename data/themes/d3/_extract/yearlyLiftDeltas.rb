@year_file = @webRoot + "yearlyLiftMaxes.xml"

generator = YearlyDeltaGenerator.new( @year_file, @dbName, @lifts)
generator.generate_xml()