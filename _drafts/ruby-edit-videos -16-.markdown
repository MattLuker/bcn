# Mark That Video

Sometimes it’s cool to let everyone know that you made a video by marking it with a logo, some would call it a watermark, to make things look more professional.

![](img/man_in_business_suit_levitating.svg)

Since we’re all about looking professional this post is going to cover inserting a PNG (a semi-transparent PNG) into every frame of a video.  That way the whole world, or at least those who view the video, will know how professional you are.

## Install Rvideo

A great Ruby library for finding out information from videos is [Rvideo](http://rvideo.rubyforge.org/) which uses the [ffmpeg](https://www.ffmpeg.org/) library/utility to manipulate the files.

The **ffmpeg** library is the work horse of audio and video manipulation for most Open Source projects.

Install the *rvideo* gem with:

```

gem install rvideo

```

## Blast an Image Into a Video