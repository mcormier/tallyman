
@data_file = @webRoot + 'outFile.xml'

generator = DataGenerator.new( @data_file, @dbName, @outputQueries, 
                               @webLifts, @liftQuery, @logger)
generator.generate_xml
