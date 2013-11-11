sql_cmds = @theme_root + "/_extract/lifts.sqlite"

out_file = @webRoot + 'lifts.tsv'

`sqlite3 #{@dbName} < #{sql_cmds} > #{out_file} `