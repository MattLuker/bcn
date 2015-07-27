# Downloading Youtube Video with Ruby

## Legit Reasons

I know the main reason certain people want to be able to download videos from Youtube is to straight up violate copyright, but the copyright laws are different in each country so what is totally legal in one country can be a big no-no in another.

I think the "Standard Youtube License" is [Creative Commons](https://support.google.com/youtube/answer/2797468?hl=en), though I didn't research that too hard.  So seems like downloading certain videos would be A-ok based on the license no matter which country you're in.  Well as long as your country respects the CC license I guess.

Either way we're going to use a Ruby library [viddl-rb](https://github.com/rb2k/viddl-rb) to grab a [RailsConf](https://www.youtube.com/watch?v=9LfmrkyP81M) video from Youtube.

## viddl-rb FTW!

This little gem is the bees knees when it comes to grabbing video files from Youtube.  Well really what we're doing is downloading the stream and re-assembling it into a file on the hard drive (at least that's how I think the library works).

Install the gem with the good ol':

```
gem install viddl-rb
```

**Note:** remember to add **sudo** if you need to.

## Whip up a Script For Repeat Business

I'm going to create a script file named *youtube_download.rb*, but you go ahead and use whatever name you'd like.  Add these lines to the file:

```
require 'viddl-rb'
video_url = "https://www.youtube.com/watch?v=9LfmrkyP81M"

begin
  puts ViddlRb.get_urls(video_url)
  puts ViddlRb.get_names(video_url)
rescue ViddlRb::DownloadError => e
  puts "Could not get download url: #{e.message}"
rescue ViddlRb::PluginError => e
  puts "Plugin blew up! #{e.message}\n" +
           "Backtrace:\n#{e.backtrace.join("\n")}"
end

`viddl-rb -s output_files #{video_url}`
```

Pow! Run the script:

```
ruby youtube_download.rb
```

This may take a while depending on the length (translate that to file size) of the video.  After the script has finished you should have a  new video file in the **output** directory.  Unless you changed that option in the script that is. 

## Command Line Utility

Ok, ok the **viddl-rb** gem magic is really in the command line utility of the same name.  I wrapped the call to the *viddl-rb* utility in back ticks '`' to call it in a subshell.  It is kind of cool to print out some additional info about the video from Youtube though.  Isn't it?

There some awesome options to the utility as well.  Like the ability to extract just the audio from a video file, or select the quality of the video to download.

Overall **viddl-rb** is a very powerful and fun utility.

# Conclusion

As a wise man once said "With great power comes great responsibility".  These types of programs can get you into a lot of trouble if you use them outside of the law.  I recommend only using them for private use, and being sure that the license is Creative Commons or other share alike license.

Party On!
