module PostsHelper
  def post_list_image(post)

    if params[:community] && @community
      border = "border: 5px solid #{@community.color}"
    elsif post.organization
      border = "border: 5px solid #{post.organization.color}"
    else
      border = ''
    end

    if post.image
      link_to post do
        image_tag post.image.thumb('75x75#').url, style: border
      end
    elsif post.og_image && post.og_image != '//:0' && !post.og_image.blank?
      link_to post do
       image_tag post.og_image, style: border
      end
    elsif post.start_date
      link_to post do
        image_tag 'calendar-icon.svg', size: '75x75', alt: post.title, style: border
      end
     else
      link_to post do
        image_tag 'bcn_logo_black.svg', size: '75x75', alt: post.title, style: border
       end
    end
  end

  def sortable(title, column, type)
    if (type == 'events')
      path = events_path
    else
      path = posts_path
    end

    path = path + "?sort=#{column}"

    color = sort_column == column ? 'secondary' : ''

    link_to path, class: "button small #{color}", id: column do
      "#{title}".html_safe
    end
  end
end
