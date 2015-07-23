#
# Replace Recent Posts on the home page with the next 5 after 30 seconds.
#
@scroller =
  update_posts: () ->
    console.log('Updating posts...')
    $.ajax({
      url: '/api/posts'
    })


  delay: (ms, func) -> setTimeout func, ms


