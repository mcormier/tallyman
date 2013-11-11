
#puts "webRoot: " + @webRoot
#puts "database: " + @dbName

# TODO - make generic
sqlCmds = "/Users/mcormier/Portfolio/GIT/tallyman/data/themes/d3/lifts.sqlite"

outFile = @webRoot + 'lifts.tsv'

value = `sqlite3 #{@dbName} < #{sqlCmds} > #{outFile} `

