xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @community.name
    xml.author @user.first_name + ' ' + @user.last_name
    xml.description @community.description
    xml.link request.domain + '/communities/' + @community.id.to_s + '/podcast'
    xml.language "en"

    for post in @community.posts.where('audio_name is not null')
      xml.item do
        if post.title
          xml.title post.title
        else
          xml.title ""
        end
        xml.author post.user.first_name + ' ' + post.user.last_name
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link request.domain + '/posts/' + post.id.to_s
        xml.guid post.id

        text = post.description
        # if you like, do something with your content text here e.g. insert image tags.
        # Optional. I'm doing this on my website.
        unless post.image.nil?
          image_url = post.image.url
          image_caption = post.image_name
          image_align = ""
          image_tag = "
                <p><img src='" + image_url +  "' alt='" + image_caption + "' title='" + image_caption + "' align='" + image_align  + "' /></p>
              "
          text = text.sub('{image}', image_tag)
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end