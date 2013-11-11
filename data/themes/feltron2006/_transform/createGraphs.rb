
transform_root = @theme_root +'/_transform/'
graphing_root = transform_root + 'graphing/'

cmd = graphing_root + 'createGraphs.sh ' + @dbName + ' ' + @webRoot
value = `#{cmd}`

# Uncomment this line if you want to see what the script did.
#puts value
