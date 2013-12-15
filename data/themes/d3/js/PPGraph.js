// Depends on d3 being loaded.
//
//
//

function PPRepGraphOrchestrator(divIdArray, tsvFile, gDim) {

  this.divIdArray = divIdArray;
  this.tsvFile = tsvFile;
  this.gDim = gDim;
  this.graphs = {};

  var that = this;
  var initBinder = function() { that.init(); };
  PPUtils.bind("load", window, initBinder );
}

PPRepGraphOrchestrator.prototype.init = function () {

  function type(d) {
    d.weight = +d.weight;     // coerce to number
    d.reps = +d.reps;         // coerce to number
    d.day = new Date(d.day);
    return d;
  }

  var that = this;
  var callbackBinder = function(error,data) { that.createGraphs(error,data); };
  d3.tsv( this.tsvFile,  type, callbackBinder  );
};


PPRepGraphOrchestrator.prototype.createGraphs = function (error,data) {
  if (error) { return; }

  for (var i=0; i < this.divIdArray.length ; i++ ) {

    var svgName = "d3Graph" + this.divIdArray[i].toLowerCase();
    svgName = svgName.replace(/ /g, ""); // Remove spaces from name
    svgName = svgName.replace(/&/g, "and"); // Remove spaces from name

    var graph = new PPRepGraph(svgName, this.tsvFile, this.divIdArray[i], this.gDim);
    graph.createGraph(error,data);
    this.graphs[svgName] = graph;
  }

} ;

PPRepGraphOrchestrator.prototype.toggleView = function (graphName) {
  var graph = this.graphs[graphName];
  graph.toggleView();
};


function PPRepGraph(divId, tsvFile, liftName, gDim) {

  this.tsvFile = tsvFile;
  this.divId = divId;
  this.liftName = liftName;

  this.d = {};
  this.d.m = [gDim.margin, gDim.margin, gDim.margin, gDim.margin];  
  this.d.w = gDim.w - this.d.m[1] - this.d.m[3];
  this.d.h = gDim.h - this.d.m[0] - this.d.m[2];

  this.formatter = new DateFmt("%n %d %y");

  this.view = "full";
}

// Global variable for all PPRepGraph classes
PPRepGraph.prototype.toolTip = null;

// Global method accessor
PPRepGraph.getToolTip = function() {
    if ( PPRepGraph.prototype.toolTip == null ) {
        PPRepGraph.prototype.toolTip = d3.select("body")
            .append("div")
            .attr("id", "PPRepGraphTooltip")
            .style("opacity", 1e-6);
    }

    return PPRepGraph.prototype.toolTip;
};

PPRepGraph.prototype.toggleView = function () {
  var that = this;

  var lastDay = this.liftData[this.liftData.length-1].day;
  var i = 0;

  if ( this.view == "full") {
    var yearBefore = new Date( lastDay.getFullYear(), lastDay.getMonth(),
      lastDay.getDate() - 365 );

    // find the first date a year from the last date
    for (i=0; i < this.liftData.length;i++) {
      if ( this.liftData[i].day.getTime() >= yearBefore.getTime() ) {
        break;
      }
    }
    this.view= "year";

  } else if ( this.view == "year") {

    var sixMosBefore = new Date( lastDay.getFullYear(), lastDay.getMonth(),
                                 lastDay.getDate() - 180 );

    // find the first date six months from the last date
    for (i=0; i < this.liftData.length;i++) {
      if ( this.liftData[i].day.getTime() >= sixMosBefore.getTime() ) {
        break;
      }
    }

    this.view = "last6Mos";
  } else {
    this.view = "full";
  }



  this.x = d3.time.scale()
    .domain([this.liftData[i].day, lastDay]  )
    .range([0, this.d.w]);

  // TODO -- number of ticks??
  var xAxis = d3.svg.axis().scale(this.x).ticks(20).tickSize(-this.d.h).tickSubdivide(true);

  // TODO -- transition length??
  var t = this.graph.transition().duration(750);

  t.select(".x.axis")
    .attr("transform", "translate(0," + this.d.h + ")")
    .call(xAxis)
    .selectAll("text")
    .attr("transform", "translate(20,25) rotate(55)");


  t.select(".oneLine").attr("d", this.line(this.rm1Data ) );
  t.select(".threeLine").attr("d", this.line(this.rm3Data ) );
  t.select(".fiveLine").attr("d", this.line(this.rm5Data ) );

  t.selectAll("circle").attr("cx", function(d) { return that.x(d.day); } );


};


PPRepGraph.prototype.mouseMove = function (d) {
  $("PPRepGraphTooltip").innerHTML = "Weight: <strong>" + d.weight + "</strong><BR>Date: <strong>" + this.formatter.format(d.day) + "</strong>";

  PPRepGraph.getToolTip().style("left", (d3.event.pageX - 34) + "px")
                         .style("top", (d3.event.pageY - 62) + "px");
};

PPRepGraph.prototype.mouseOver = function () {
    PPRepGraph.getToolTip().transition().duration(250)
      .style("opacity", 0.8);
};

PPRepGraph.prototype.mouseOut = function () {
    PPRepGraph.getToolTip().transition().duration(500)
      .style("opacity", 0);
};


PPRepGraph.prototype.buildRepArrays = function (j) {
  this.rm1Data = [];
  this.rm3Data = [];
  this.rm5Data = [];

  for ( i=j; i < this.liftData.length;i++) {
    if ( this.liftData[i].reps == 1) { this.rm1Data.push( this.liftData[i] ); }
    if ( this.liftData[i].reps == 3) { this.rm3Data.push( this.liftData[i] ); }
    if ( this.liftData[i].reps == 5) { this.rm5Data.push( this.liftData[i] ); }
  }

};

PPRepGraph.prototype.createGraph = function (error,data) {
  if (error) { return; }

  var that = this;

  var minMaxFunc= function(d) { return d.weight; };
  var xFunc = function (d) { return that.x(d.day); };
  var yFunc = function (d) { return that.y(d.weight); };


  this.liftData = [];

  for (var i=0; i <data.length;i++) {
    if ( data[i].name === this.liftName) {
      this.liftData.push(data[i]);
    }
  }

  this.buildRepArrays(0);


  this.x = d3.time.scale()
                  .domain([this.liftData[0].day, this.liftData[this.liftData.length-1].day]  )
                  .range([0, this.d.w]);

  this.y = d3.scale.linear().domain([d3.min(this.liftData, minMaxFunc ),
                                     d3.max(this.liftData, minMaxFunc ) ]).range([this.d.h, 0]);

  this.line = d3.svg.line().x( xFunc )
                          .y( yFunc )
                          .interpolate("linear");

  this.graph = d3.select("#" + this.divId).append("svg:svg")
              .attr("width", this.d.w + this.d.m[1] + this.d.m[3] )
              .attr("height", this.d.h + this.d.m[0] + this.d.m[2] )
          .append("svg:g")
            .attr("transform", "translate(" + this.d.m[3] + "," + this.d.m[0] + ")");

  var xAxis = d3.svg.axis().scale(this.x).ticks(20).tickSize(-this.d.h).tickSubdivide(true);

   // Add the x-axis. to the graph
  this.graph.append("svg:g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + this.d.h + ")")
    .call(xAxis)
    .selectAll("text")
    .attr("transform", "translate(20,25) rotate(55)");

  var yAxisLeft = d3.svg.axis().scale(this.y).ticks(8).orient("left");

  // Add the y-axis to the left
  this.graph.append("svg:g")
       .attr("class", "y axis")
       .attr("transform", "translate(-25,0)")
       .call(yAxisLeft);

  this.addLine( this.line(this.rm1Data), "oneLine");
  this.addLine( this.line(this.rm3Data), "threeLine");
  this.addLine( this.line(this.rm5Data), "fiveLine");

  this.addPoints( this.rm1Data, "onePoints");
  this.addPoints( this.rm3Data, "threePoints");
  this.addPoints( this.rm5Data, "fivePoints");

};

PPRepGraph.prototype.addLine = function (line, cssClassInfo) {
  this.graph.append("svg:g")
            .append("svg:path")
            .attr("d", line )
            .attr("class", cssClassInfo);
};

PPRepGraph.prototype.addPoints = function (data, cssClassInfo) {
  var that = this;
  var overBinder = function() { that.mouseOver(); };
  var moveBinder = function(d) { that.mouseMove(d); };
  var outBinder = function() { that.mouseOut(); };

  var points = this.graph.selectAll(".point").data(data);
 
  points.enter().insert("svg:circle")
              .attr("class", cssClassInfo )
              .attr("cx", function(d) { return that.x(d.day) })
              .attr("cy", function(d) { return that.y(d.weight) })
              .attr("r", function() { return 6 })
              .on("mouseover", overBinder )
              .on("mousemove", moveBinder)
              .on("mouseout", outBinder);
};


function PPPieGraph(divId, tsvFile, gDim, totalFunc, forEachFunc, fillFunc, labelFunc) {
  var that = this;

  this.divId = divId;
  this.tsvFile = tsvFile;
  this.forEachFunc = forEachFunc;
  this.fillDataFunc = fillFunc;
  this.totalFunc = totalFunc;
  this.labelFunc = labelFunc;


  this.color = d3.scale.ordinal().range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);
  this.width = gDim.w; 
  this.height = gDim.h;
  this.radius = Math.min(this.width, this.height) / 2;

  var initBinder = function() { that.init(); };
  PPUtils.bind("load", window, initBinder );
}

PPPieGraph.prototype.init = function () {
  var that = this;
  var callbackBinder = function(error,data) { that.createGraph(error,data); };
  d3.tsv( this.tsvFile, callbackBinder  );
};

PPPieGraph.prototype.createGraph = function (error,data) {
  if (error) { return; }

  var that = this;

  this.arc = d3.svg.arc()
                 .outerRadius(this.radius - 10)
                 .innerRadius(0);


  this.pie = d3.layout.pie().sort(null).value(that.totalFunc);


  this.svg = d3.select("#" + this.divId).append("svg")
                             .attr("width", this.width)
                             .attr("height", this.height)
                             .append("g")
                             .attr("transform", "translate(" + this.width / 2 + "," + this.height / 2 + ")");

  var forEachInternal = function(d) { return that.forEachFunc(d); };
  data.forEach( forEachInternal );

  this.g = this.svg.selectAll(".arc")
              .data(this.pie(data))
              .enter().append("g")
              .attr("class", "arc");

  var fillFuncInternal = function(d) { return that.color(that.fillDataFunc(d)); };

  this.g.append("path")
    .attr("d", this.arc)
    .style("fill", fillFuncInternal );


  this.g.append("text")
      .attr("transform", function(d) { return "translate(" + that.arc.centroid(d) + ")"; })
      .attr("dy", ".35em")
      .style("text-anchor", "middle")
      .text( that.labelFunc );



};

