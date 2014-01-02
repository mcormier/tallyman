
@js_out_file = "#{@webRoot}/js/setupGraphs.js"

js_lift_array =  '[ '

@webLifts.each do |liftName|
  js_lift_array = "#{js_lift_array}'#{liftName}',"
end

js_lift_array = js_lift_array[0...-1] + ']'  # Remove last comma

`echo "var gDim = { 'w': 830, 'h': 300, 'topMargin': 20, 'bottomMargin':80, 'leftMargin': 80, 'rightMargin': 80 };" > #{@js_out_file}`

`echo "var liftNames = #{js_lift_array};" >> #{@js_out_file}`

`echo "var orchid = new PPRepGraphOrchestrator(liftNames, 'lifts.tsv',  gDim);" >> #{@js_out_file}`