
xsl_loc= @theme_root +'/xsl/createHTML.xsl'

cmd = 'xsltproc ' + xsl_loc + ' ' + @data_file + ' > ' + @outputHTMLFile
value = `#{cmd}`


