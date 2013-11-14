sql_cmds = @theme_root + "/_extract/lifts.sqlite"
out_file = @webRoot + 'lifts.tsv'
`sqlite3 #{@dbName} < #{sql_cmds} > #{out_file} `

out_file = @webRoot + 'books.tsv'
sql_cmds = @theme_root + "/_extract/books.sqlite"
`sqlite3 #{@dbName} < #{sql_cmds} > #{out_file} `

out_file = @webRoot + 'music.tsv'
sql_cmds = @theme_root + "/_extract/music.sqlite"
`sqlite3 #{@dbName} < #{sql_cmds} > #{out_file} `
