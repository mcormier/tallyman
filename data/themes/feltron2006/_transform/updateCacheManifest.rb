cache_manifest = @theme_root +'/cache/cache.manifest'

now = `date +"%s"`.strip!
cmd =  "sed '2 s/.*/#\ Version:#{now}/' #{cache_manifest} > #{@webRoot}/cache.manifest"

`#{cmd}`

