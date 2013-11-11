
xsl_loc= @theme_root +'/_transform/xsl/createHTML.xsl'

cmd = 'xsltproc ' + xsl_loc + ' ' + @data_file + ' > ' + @outputHTMLFile
value = `#{cmd}`
