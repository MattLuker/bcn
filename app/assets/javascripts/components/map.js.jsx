var Map = React.createClass({
  initMap: function() {
    // Initialize the Open Street Map map.
    window.map = new L.Map('map');

    // # Create the tile layer with correct attribution.
    // #
    // # Need to figure out how to use our own service for the tile PNG files.
    // # If at any way possible.
    // #
    osmUrl='http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    osmAttrib='Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors';
    osm = new L.TileLayer(osmUrl, {minZoom: 6, maxZoom: 19, attribution: osmAttrib});

    // # Start the map over Boone, Appalachina Street to be exact.
    window.map.setView(new L.LatLng(this.state.lat, this.state.lon), this.state.zoom);
    window.map.addLayer(osm);

    // # Set the marker icon to custom SVG.
    window.divDefaultIcon = L.divIcon({
      className: 'marker-div-icon',
      html: get_svg('#632816', 30, 55),
      popupAnchor: [-9, -53],
      iconAnchor: [20, 55],
    });
  },
  componentDidMount: function() {
    this.initMap();
  },
  getInitialState: function() {
    return {
      lat: 36.2168253,
      lon: -81.6824657,
      zoom: 13
    }
  },
  render: function() {
    return <div id="map"></div>
  }
})
