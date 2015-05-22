---
title: Making your webapp 10x faster
layout: post
tags: programming, Buckets
---

I cringed while watching my sister-in-law use [Buckets](https://www.bucketsisbetter.com) on her iPhone.  It was so *painfully* slow.  I knew it was slow, but I didn't know how bad it was.  So I decided to make it faster&mdash;here's how:

# tl;dr #

If you have previously put no effort into the speed of a webapp, then **almost any effort** will buy you huge gains :)  It's easy to make something 10x faster than molasses.  Just try something.


# 1. Make something terrible #

The first step to making something fast is to make something.  It can be terrible.  Mine was.


# 2. DevTools #

The next step is to get some data.  I pulled up Chrome DevTools and watched the landing page load:

![Landing page load](/images/making-your-app-faster/landing-page-1.png)

Ouch! Twenty seconds just to load the first page.  No real user would wait that long.


# 3. Images #

Turns out I was asking the browser to download 180 KB of images.  I reduced the quality and size of each of the three images (yes, 180 KB for *three* images) to about 27 KB of images.  I used [gifsicle](http://www.lcdf.org/gifsicle/) and [ImageMagick](http://www.imagemagick.org/script/index.php) for that.  Here's a part of my `Makefile`:

{% highlight Makefile %}
PNGS := $(patsubst static/img/%.png,static/img/opt/%.png,$(wildcard static/img/*.png))
GIFS := $(patsubst static/img/%.gif,static/img/opt/%.gif,$(wildcard static/img/*.gif))

optimized-images: $(PNGS) $(GIFS)

static/img/opt/%.png: static/img/%.png
        convert -quality 90 -depth 5 $^ $@

static/img/opt/%.gif: static/img/%.gif
        gifsicle -O -o $@ $^
{% endhighlight %}

I might get `webpack` to do this in the future.


# 4. Unused JavaScript/CSS #

Some time ago, I had this bright idea of loading all the application JavaScript and CSS on the landing page, so that users would experience no delay when they went to use the app.

I repented.

And saved 1.1 MB.


# 5. webpack #

I heard about [webpack](http://webpack.github.io/) a while ago and thought it might be neat, but also thought, "Ugh... [why another module bundler?](http://webpack.github.io/docs/what-is-webpack.html#why-another-module-bundler)"  After watching my sister-in-law suffer through my app, though, I watched the following talk by Pete Hunt, which convinced me to give webpack a real try.

<iframe width="560" height="315" src="https://www.youtube.com/embed/VkTCL6Nqm6Y" frameborder="0" allowfullscreen></iframe>

Webpack is confusing at first, but later it's still confusing (okay, it gets a *little* better with practice).  Eventually, you can get it to do what you want.  And for Buckets it has been worth the effort.  I see real speed benefits now, but I also foresee great modularity/reuseability benefits on the horizon.

Using webpack is a good choice.


# 6. Don't embed YouTube videos #

I had an embedded YouTube video on the landing page.  It ate up ~500 KB over several sequential requests.  Now, I have a fake "embedded" video link to YouTube.  I might later make the embedded video load after the user clicks the fake "embedded" video link.


# Results #

Here are some measurements of three distinct pages of the app before and after doing the above.  All measurements were taken by accessing a local dev server with Chrome's DevTools simulating a Normal 3G connection (750 Kbps, 100ms RTT).

<table>
    <tr>
        <th></th>
        <th>Before</th>
        <th>After</th>
    </tr>
    <tr>
        <td>Landing page</td>
        <td>
            <ul>
                <li>time: 20.78 s</li>
                <li>size: 1.8 MB</li>
                <li>DOM:  20.13 s</li>
                <li>load: 20.78 s</li>
            </ul>
        </td>
        <td>
            <ul>
                <li>time: <strong>2.07 s</strong></li>
                <li>size: <strong>115 KB</strong></li>
                <li>DOM:  <strong>842 ms</strong></li>
                <li>load: <strong>1.22 s</strong></li>
            </ul>
        </td>
    </tr>
    <tr>
        <td><a href="https://www.bucketsisbetter.com/sandbox">Sandbox</a></td>
        <td>
            <ul>
                <li>time: 16.51 s</li>
                <li>size:   1.4 MB</li>
                <li>DOM:  13.46 s</li>
                <li>load: 16.51 s</li>
            </ul>
        </td>
        <td>
            <ul>
                <li>time: 13.63 s</li>
                <li>size:   1.1 MB</li>
                <li>DOM:    645 ms</li>
                <li>load: 12.87 s</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td>App</td>
        <td>
            <ul>
                <li>time: 16.36 s</li>
                <li>size:  1.4 MB</li>
                <li>DOM:  13.31 s</li>
                <li>load: 16.36 s</li>
            </ul>
        </td>
        <td>
            <ul>
                <li>time: 12.60 s</li>
                <li>size:  1.0 MB</li>
                <li>DOM:   615 ms</li>
                <li>load: 11.77 s</li>
            </ul>
        </td>
    </tr>
</table>

I'm rather pleased that the landing page loads visually in about 1 second and completely in 2.  The other pages are slightly faster and smaller.  I will continue to optimize them.

Feel free to [give Buckets a try](https://www.bucketsisbetter.com).
