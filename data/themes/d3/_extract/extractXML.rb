
@data_file = @webRoot + "outFile.xml"

generator = DataGenerator.new( @data_file, @dbName,
                               @outputQueries, @webLifts, @liftQuery)
generator.generate_xml()
