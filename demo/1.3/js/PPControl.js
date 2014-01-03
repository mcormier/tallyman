
function PPSegmentedControl( parentGraphID, rootIDValue, segments, delegate ) {

  this.id = "graphControl"+rootIDValue;
  this.delegate = delegate;
  this.selectedItem = null;
  this.listItems = [];

  var graphNode = $(parentGraphID);

  this.rootElem = document.createElement('div');
  this.rootElem.addClass("graphControl");
  this.rootElem.setAttribute('id', this.id);

  var unList = document.createElement('ul');
  unList.addClass("ppSegmented-control");
  if ( segments.idVals.length == 2 ) {
    unList.addClass("twoValues");
  }

  for (var i =0; i < segments.labels.length; i++) {
    var listItem = this.addListItem(unList, segments.idVals[i], rootIDValue,  segments.labels[i] );
    this.listItems.push(listItem);
  }

  // TODO - size style info should be based on amount of parameters, width, etc

  this.rootElem.appendChild(unList);


  graphNode.parentNode.insertBefore( this.rootElem, graphNode.nextSibling );
}

PPSegmentedControl.prototype.addListItem = function (listNode, id, rootIDValue, label) {
  var that = this;
  var listItem = document.createElement('li');
  var idString = id + rootIDValue;

  listItem.setAttribute('id',idString);

  var link = document.createElement('a');
  link.innerHTML = label;
  link.setAttribute('id', 'link'+idString);

  var itemBinder = function() { that.callback(listItem, id); };
  PPUtils.bind("click", link, itemBinder );

  listItem.appendChild(link);

  listNode.appendChild(listItem);

  return listItem;
};

PPSegmentedControl.prototype.setSelectedByIndex = function (index) {
  this.setSelectedListItem(this.listItems[index]);
};

PPSegmentedControl.prototype.setSelectedListItem = function (listItem) {
  if ( listItem == this.selectedItem ) { return;}

  if (this.selectedItem != null) {
    this.selectedItem.removeClass("selected");
  }

  listItem.addClass("selected");
  this.selectedItem = listItem;
};

PPSegmentedControl.prototype.callback = function (listItem, id) {

  this.setSelectedListItem(listItem);
  if (this.delegate != null) {
    this.delegate.segmentChanged(id);
  }

};