%w(lifts books music).each do |tsvType|
  out_file = "#{@webRoot}#{tsvType}.tsv"
  sql_cmd_file = "#{@theme_root}/_extract/#{tsvType}.sqlite"
  `sqlite3 #{@dbName} < #{sql_cmds} > #{out_file} `
end
