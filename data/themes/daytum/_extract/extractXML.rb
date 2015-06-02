@data_file = @webRoot + "data.xml"

generator = DataGenerator.new( @data_file, @dbName,
                               @outputQueries, @lifts, @liftQuery)
generator.generate_xml()
