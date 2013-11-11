puts "TODO create graphs"

transform_root = @theme_root +'/_transform/'
graphing_root = transform_root + 'graphing/'

puts graphing_root


cmd = graphing_root + 'createGraphs.sh ' + @dbName + ' ' + @webRoot
value = `#{cmd}`

puts value
