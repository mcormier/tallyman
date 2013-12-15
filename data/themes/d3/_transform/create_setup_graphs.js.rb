
@js_out_file = "#{@webRoot}/js/setupGraphs.js"

js_lift_array =  '[ '

@webLifts.each do |liftName|
  js_lift_array = "#{js_lift_array}'#{liftName}',"
end

js_lift_array = js_lift_array[0...-1] + ']'  # Remove last comma

`echo "var gDim = { 'w': 780, 'h': 300, 'margin': 80 };" > #{@js_out_file}`

`echo "var liftNames = #{js_lift_array};" >> #{@js_out_file}`

`echo "var orchid = new PPRepGraphOrchestrator(liftNames, 'lifts.tsv',  gDim);" >> #{@js_out_file}`