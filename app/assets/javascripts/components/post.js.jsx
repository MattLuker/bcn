var Post = React.createClass({
  render: function() {
    var postTitle = this.props.title;
    var linkTarget = '_self';

    if (postTitle == null) {
      postTitle = this.props.og_title
      linkTarget = '_blank'
    }

    if (postTitle.length > 100) {
      postTitle = postTitle.slice(0,25)
    }

    var dateTxt = 'On: ';
    if (this.props.start_date != null) {
      dateTxt += moment(this.props.start_date).format('M/D/YYYY')

      if (this.props.start_time != null) {
        dateTxt += ' @ ' + moment(this.props.start_time).format('h:mm a')
      }
    } else {
      dateTxt = moment(this.props.created_at).fromNow()
    }

    var postCreator = 'Anonymous';
    var creatorHref = '';
    if (this.props.organization != null) {
      postCreator = this.props.organization.name;
      creatorHref = '/organizations/' + this.props.organization.id;
    } else if (this.props.user != null && this.props.user.username != null) {
      postCreator = this.props.user.username;
      creatorHref = '/users/' + this.props.user.id;
    }

    return <li className={"post row post_" + this.props.id}>
        <div className="row">
          <PostImage src={this.props.image_web_url} start_date={this.props.start_date} />

          <div className="large-10 columns">

            <span className="post-title">
              <a href={'/posts/' + this.props.id} target={linkTarget} id={'post_' + this.props.id}>{postTitle}</a>
            </span>

            <br/>

          <span className="grey post-date smaller-text">
            {dateTxt}

            &nbsp;by&nbsp;

            <a href={creatorHref} className="grey-link">{postCreator}</a>
          </span>

          <span className="grey comment-count smaller-text">
            &nbsp; {this.props.comments != null ? this.props.comments.length + 'Comments' : ''}
          </span>

          </div>

        </div>
      </li>
  }
});
