

generator = DataGenerator.new( @webRoot + "outFile.xml", @dbName,
                               @outputQueries, @webLifts, @liftQuery)
generator.generate_xml()
