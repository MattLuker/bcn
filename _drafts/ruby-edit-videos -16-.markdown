# Mark That Video

Sometimes it’s cool to let everyone know that you made a video by marking it with a logo, some would call it a watermark, to make things look more professional.

![](img/man_in_business_suit_levitating.svg)

Since we’re all about looking professional this post is going to cover inserting a PNG (a semi-transparent PNG) into every frame of a video.  That way the whole world, or at least those who view the video, will know how professional you are.

I’ve been toying with this idea for some time, but couldn’t seem to find a good Ruby library to edit a video in pure Ruby.  The reason is because I think that because utilities like [ffmpeg](https://www.ffmpeg.org/) exist no one has gone to the trouble to do it in pure Ruby. That’s totally fine with me.  We’ll call **ffmpeg** from using Ruby’s system call ability to make some edits to a video.

The main breakthrough with this topic came when I saw [this post](http://davidwalsh.name/watermark-images-videos) from David Walsh on Twitter.  In the post he goes into detail on adding watermarks to images and animated GIFs as well so I recommend you check it out.  As David sites in his post the command for editing video is from Kevin Sloan and can be found [here](http://ksloan.net/watermarking-videos-from-the-command-line-using-ffmpeg-filters/).  Like David, I also highly recommend Kevin’s post.

## ffmpeg with Ruby

To recap, executing other utilities in Ruby with backpacks:

```

home_files = `ls ~`

```

The out put of ```ls ~``` will be placed into the *home_files* variable as a string.

## Blast an Image Into a Video

The command to add an image to a video is:

```

ffmpeg -i wtf.mpg -i watermark.png -filter_complex "overlay=10:10" wtf-watermarked.mpg

```

Add that to a Ruby script:

```

#!/usr/bin/env ruby # # Watermark videos #  watermark = './data_files/levitating_man.png' video = './data_files/bcn_movie-1.mp4'   edit_output = `ffmpeg -i #{video} -i #{watermark} -filter_complex "overlay=30:30" ./output_files/bcn_movie-1.watermarked.mp4`   puts edit_output

```

## Conclusion

I’m not sure how mad I’d be if someone stole my video content, if I had any video content, and I’m also not too sure if a simple watermark will really deter someone from stealing content if they were really determined.  Like Anthony Hopkins says in that movie where he and Alec Baldwin fight bears: “What One Man Can Do, Another Can Do”…

Or undo…

Party On!