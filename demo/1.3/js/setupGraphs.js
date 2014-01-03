var gDim = { 'w': 830, 'h': 300, 'topMargin': 20, 'bottomMargin':80, 'leftMargin': 80, 'rightMargin': 80 };
var liftNames = [ 'Deadlift','Shoulder Press','Clean','Front Squat','Push Jerk','Overhead Squat','Snatch'];
var orchid = new PPRepGraphOrchestrator(liftNames, 'lifts.tsv',  gDim);
