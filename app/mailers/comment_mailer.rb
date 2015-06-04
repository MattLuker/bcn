class CommentMailer < ApplicationMailer
  default_url_options[:host] = "localhost:3000"
  default from: 'robot@boonecommunitynetwork.com'

  def new_comment(user, post, comment, commenter)
    @user = user
    @post = post
    @comment = comment
    @commenter = commenter
    mail(to: "#{user.first_name} #{user.last_name} <#{user.email}>", subject: "New comment on #{@post.title}")
  end
end
