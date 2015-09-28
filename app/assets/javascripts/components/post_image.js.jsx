var PostImage = React.createClass({
  render: function() {
    // Default Post image.
    var imgSrc = window.image_path('bcn_logo_black.svg');

    if (this.props.src == '//:0') {
      if (this.props.start_date != null) {
        imgSrc = window.image_path('calendar-icon.svg');
      }
    } else {
      imgSrc = this.props.src;
    }

    return <div className="small-4 large-2 columns post-list-image">
      <img src={imgSrc} />
    </div>
  }
})
