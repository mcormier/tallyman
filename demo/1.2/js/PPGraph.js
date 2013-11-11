// Depends on d3 being loaded.
//
//
//
function PPRepGraph(divId, tsvFile, liftName, castFunc, gDim) {

  this.tsvFile = tsvFile;
  this.castFunc = castFunc;
  this.divId = divId;
  this.liftName = liftName;

  this.d = {};
  this.d.m = [gDim.margin, gDim.margin, gDim.margin, gDim.margin];  
  this.d.w = gDim.w - this.d.m[1] - this.d.m[3];
  this.d.h = gDim.h - this.d.m[0] - this.d.m[2];

  this.formatter = new DateFmt("%n %d %y");

  var that = this;
  var initBinder = function() { that.init(); };
  PPUtils.bind("load", window, initBinder );
};

PPRepGraph.prototype.init = function () {
  var that = this;
  var callbackBinder = function(error,data) { that.createGraph(error,data); }
  d3.tsv( this.tsvFile,  this.castFunc, callbackBinder  );
};


PPRepGraph.prototype.createToolTip = function () {
 this.tTip = d3.select("body")
                .append("div")
                .attr("class", "pointInfo")
                .style("opacity", 1e-6);
}

PPRepGraph.prototype.mousemove = function (d,i) {
  this.tTip.text("Weight: " + d.weight + " " + this.formatter.format(d.day));

  this.tTip.style("left", (d3.event.pageX - 34) + "px")
           .style("top", (d3.event.pageY - 62) + "px");
}

PPRepGraph.prototype.mouseover = function (d,i) { 
  this.tTip.transition().duration(250)
      .style("opacity", 0.8);
}

PPRepGraph.prototype.mouseout = function (d,i) {
  this.tTip.transition().duration(500)
      .style("opacity", 0);
}


PPRepGraph.prototype.createGraph = function (error,data) {
  if (error) { return; }

  var that = this;

  this.createToolTip();

  var minMaxFunc= function(d) { return d.weight; };
  var xFunc = function (d,i) { return that.x(d.day); };
  var yFunc = function (d,i) { return that.y(d.weight); };

  var rm1Data = new Array();
  var rm3Data = new Array();
  var rm5Data = new Array();

  var liftData = new Array();

  for (var i=0; i <data.length;i++) {
    if ( data[i].name === this.liftName) {
      liftData.push(data[i]);
    }
  }
  for (var i=0; i < liftData.length;i++) {
      if ( liftData[i].reps == 1) { rm1Data.push( liftData[i] ); }
      if ( liftData[i].reps == 3) { rm3Data.push( liftData[i] ); }
      if ( liftData[i].reps == 5) { rm5Data.push( liftData[i] ); }
  }

  this.x = d3.time.scale()
                  .domain([liftData[0].day, liftData[liftData.length-1].day]  )
                  .range([0, this.d.w]);

  this.y = d3.scale.linear().domain([d3.min(liftData, minMaxFunc ),
                                     d3.max(liftData, minMaxFunc ) ]).range([this.d.h, 0]);

  var line = d3.svg.line().x( xFunc )
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

  this.addLine( line(rm1Data), "oneLine");
  this.addLine( line(rm3Data), "threeLine");
  this.addLine( line(rm5Data), "fiveLine");

  this.addPoints( rm1Data, "onePoints");
  this.addPoints( rm3Data, "threePoints");
  this.addPoints( rm5Data, "fivePoints");

}

PPRepGraph.prototype.addLine = function (line, cssClassInfo) {
  this.graph.append("svg:g")
            .append("svg:path")
            .attr("d", line )
            .attr("class", cssClassInfo);
}

PPRepGraph.prototype.addPoints = function (data, cssClassInfo) {
  var that = this;
  var overBinder = function(d,i) { that.mouseover(d,i); };
  var moveBinder = function(d,i) { that.mousemove(d,i); };
  var outBinder = function(d,i) { that.mouseout(d,i); };

  this.graph.selectAll(".point")
             .data(data)
           .enter().append("svg:circle")
              .attr("class", cssClassInfo )
              .attr("cx", function(d, i) { return that.x(d.day) })
              .attr("cy", function(d, i) { return that.y(d.weight) })
              .attr("r", function(d, i) { return 6 })
              .on("mouseover", overBinder )
              .on("mousemove", moveBinder)
              .on("mouseout", outBinder);
}


