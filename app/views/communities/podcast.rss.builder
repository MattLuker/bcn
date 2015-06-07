xml.instruct! :xml, :version => "1.0"
xml.rss 'xmlns:itunes' => "http://www.itunes.com/dtds/podcast-1.0.dtd", 'version' => "2.0" do
  xml.channel do
    fullname = @user.first_name + ' ' + @user.last_name

    xml.title @community.name
    xml.author fullname
    xml.link 'http://' + request.domain + '/communities/' + @community.id.to_s
    xml.language 'en-us'
    xml.copyright '&#x2117; &amp; &#xA9; ' + DateTime.now.year.to_s + ' ' + @community.name
    xml.tag! "itunes:subtitle", @community.description
    xml.tag! 'itunes:author', fullname
    xml.tag! 'itunes:summary', @community.description
    #xml.tag! 'itunes:explicit', @community.explicit
    xml.description @community.description

    xml.tag! 'itunes:owner' do
      xml.tag! 'itunes:name', fullname
      xml.tag! 'itunes:email', @user.email
    end

    #xml.tag! 'itunes:image', 'href' => @community.image.url

    xml.tag! 'itunes:category', 'text' => 'Community' do
      xml.tag! 'itunes:category', 'text' => 'Local'
    end

    xml.tag! 'itunes:category', 'text' => 'Appalachia'


    for post in @community.posts.where('audio_name is not null')
      xml.item do
        if post.title
          xml.title post.title
        else
          xml.title ""
        end
        post_fullname = post.user.first_name + ' ' + post.user.last_name
        xml.author post_fullname
        xml.tag! 'itunes:author', post_fullname
        xml.tag! 'itunes:subtitle', post.description
        xml.tag! 'itunes:summary' do
          xml.cdata! post.description
        end
        xml.tag! 'itunes:image', 'href' => 'http://' + request.domain + post.image.url if post.image.url
        xml.tag! 'itunes:explicit', post.explicit

        xml.enclosure 'url' => 'http://' + request.domain + post.audio.url,
                      'length' => '8727310',
                      'type' => post.audio.mime_type
        xml.tag! 'itunes:duration', post.audio_duration

        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link 'http://' + request.domain + '/posts/' + post.id.to_s
        xml.guid post.id

        text = post.description
        if post.image
          image_tag = "<p><img src='" + post.image.url + "' /></p>"
          text = image_tag + text
          puts text
        end
        xml.description "<p>" + text + "</p>"

      end
    end
  end
end