---
layout: post
title: Interesting Books
# tags:
# - art
image: /images/interestingbooks/img1.png
---

Books are great! Not only can you read them, but you can make computers read them, too. Once upon a time, my brother made a computer read a book and shared this result:

![Word to word comparison of a book](/images/interestingbooks/img1.png)

Quick side note: this post will probably not work very well on a mobile device. Sorry.

To make the image, I made the computer write every word in the book along the top and side of a table. Then it colored each cell black if the words in the top and the side are the same. For example:

<style>
table.bordered {
  border-collapse: collapse;
  border-spacing: 0;
  width: 100%;
}
table.bordered td {
  border: 1px solid grey;
  text-align: center;
  vertical-align: center;
}
table.bordered td.mark {
  background-color: black;
}
</style>
<table class="bordered">
  <tr>
    <td></td>
    <td>How</td>
    <td>much</td>
    <td>wood</td>
    <td>could</td>
    <td>a</td>
    <td>wood</td>
    <td>chuck</td>
    <td>chuck?</td>
  </tr>
  <tr>
    <td>How</td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>much</td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>wood</td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>could</td>
    <td></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>a</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>wood</td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>chuck</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td class="mark"></td>
  </tr>
  <tr>
    <td>chuck?</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td class="mark"></td>
    <td class="mark"></td>
  </tr>  
</table>

<br/>

However, some books are very, *very* long. *War and Peace* is about half a million words and an image that was half a million by half a million pixels big would be bigger than my screen. So instead of counting each word, the computer divides the book up into sections. It compares each section and counts the number of matching words. The total count is then used to color a pixel some shade of grey where white means no common words, and black means all the words are the same.

Also, I've made some other adjustements:

- Since each section of a book is the same as itself, I turn that middle diagonal line white so it's not distracting.
- Words like "the" and "a" are removed because they are so common. In fact, I remove all words that make up more than 1% of the total.

Alright, want to see some books and if these charts are useful or not? All of the text for these books came from [Project Gutenberg](https://www.gutenberg.org/).

<style>
.textpreview {
  background-color: rgba(0,0,0,0.02);
  padding: 2rem;
  border-radius: 6px;
  font-family: monospace;
  flex-basis: 50%;
  max-height: 10rem;
  overflow-y: auto;
  margin-bottom: 2rem;
}
.textpreview .match {
  background-color: rgba(255,251,205,1.0);
}
.box {
  overflow: visible;
  font-size: 0.7rem;
  white-space: nowrap;
}
</style>
<script>
const IMAGESIZE = 740;
function removeExts(x) {
  let parts = x.split('.');
  return parts.slice(0, parts.length - 2).join('.');
}
function debounce(func, delay) {
  let timer;
  return (...args) => {
    if (timer) {
      clearTimeout(timer);
    }
    timer = setTimeout(() => {
      clearTimeout(timer);
      func(...args);
    }, delay)
  }
}
let existing_boxes = {};
function toggleBox(key, color, x0, y0, x1, y1, label) {
  let fullkey = `${key} ${color} ${x0} ${y0} ${x1} ${y1} ${label}`;
  label = label || '';
  if (existing_boxes[fullkey]) {
    existing_boxes[fullkey].parentNode.removeChild(existing_boxes[fullkey]);
    delete existing_boxes[fullkey];
  } else {
    let wrap = document.querySelector(`#${key} .wrap`);
    let box = document.createElement('div');
    box.classList.add('box');
    box.setAttribute('style', `position: absolute; background-color: ${color};`);
    box.style.left = `${100 * x0/IMAGESIZE}%`;
    box.style.top = `${100 * y0/IMAGESIZE}%`;
    box.style.width = `${100 * (x1 - x0)/IMAGESIZE}%`;
    box.style.height = `${100 * (y1 - y0)/IMAGESIZE}%`;
    box.innerText = label;
    existing_boxes[fullkey] = box; 
    wrap.appendChild(box);
  }
}
function toggleCenterBox(key, color, start, end, label) {
  toggleBox(key, color, start, start, end, end, label);
}
var img_ids = 0;
function showInspectableImage(imageurl, key) {
  let img_id = key || "inspectable-" + img_ids++;
  
  let wrap = document.createElement('div');
  wrap.classList.add('wrap');
  wrap.setAttribute('style', 'position: relative');

  let img = document.createElement('img');
  img.src = imageurl;
  img.addEventListener('click', (ev) => {
    if (ev.shiftKey) {
      slider2.value = ev.offsetX;
      updateHighlight(1, Number(ev.offsetX));
    } else {
      slider1.value = ev.offsetX;
      updateHighlight(0, Number(ev.offsetX));
    }
  })

  let highlight1 = document.createElement('div');
  highlight1.setAttribute('style', 'width: 1px; height: 100%; background-color: rgba(255,0,0,0.5); position: absolute; top: 0; left: 0;');

  let highlight2 = document.createElement('div');
  highlight2.setAttribute('style', 'width: 1px; height: 100%; background-color: rgba(0,0,255,0.5); position: absolute; top: 0; left: 0;');

  wrap.appendChild(img);
  wrap.appendChild(highlight1);
  wrap.appendChild(highlight2);
  
  let text1 = '';
  let textpreview1 = document.createElement('div');
  textpreview1.classList.add('textpreview');
  let text2 = '';
  let textpreview2 = document.createElement('div');
  textpreview2.classList.add('textpreview');
  let previews = document.createElement('div');
  previews.setAttribute('style', 'display: flex;');
  previews.appendChild(textpreview1);
  previews.appendChild(textpreview2);

  let slider1 = document.createElement('input');
  slider1.setAttribute('type', 'range');
  slider1.setAttribute('min', '0');
  slider1.setAttribute('max', IMAGESIZE);
  slider1.setAttribute('value', '0');
  slider1.setAttribute('style', 'width: 100%;');

  let slider2 = document.createElement('input');
  slider2.setAttribute('type', 'range');
  slider2.setAttribute('min', '0');
  slider2.setAttribute('max', IMAGESIZE);
  slider2.setAttribute('value', '0');
  slider2.setAttribute('style', 'width: 100%;');
  
  function compareTexts() {
    console.log("comparing texts");
    if (!text1 || !text2) {
      return;
    }
    let parts1 = text1.split(' ');
    let s1 = new Set(parts1);
    let parts2 = text2.split(' ');
    let s2 = new Set(parts2);
    textpreview1.innerHTML = 'Chunk ' + textpreview1.getAttribute('chunk') + '\n' + parts1.map(word => {
      if (s2.has(word)) {
        return '<span class="match">' + word + '</span>'
      } else {
        return '<span>' + word + '</span>';
      }
    }).join('&nbsp;');
    textpreview2.innerHTML = 'Chunk ' + textpreview2.getAttribute('chunk') + '\n' + parts2.map(word => {
      if (s1.has(word)) {
        return '<span class="match">' + word + '</span>'
      } else {
        return '<span>' + word + '</span>';
      }
    }).join('&nbsp;');
  }

  function updateHighlight(which, val) {
    if (which === 0) {
      highlight1.style.left = `${val}px`;
    } else {
      highlight2.style.left = `${val}px`;
    }
    updatetext(which, val);
  }
  let updatetext = debounce((which, val) => {
    let chunkurl = removeExts(imageurl) + '/chunk' + val + '.txt'
    console.log(chunkurl);
    fetch(chunkurl)
      .then((response) => response.text())
      .then((text) => {
        let elem = which === 0 ? textpreview1 : textpreview2;
        elem.setAttribute('chunk', val);
        elem.innerText = `Chunk ${val}\n${text}`;
        if (which === 0) {
          text1 = text;
        } else {
          text2 = text;
        }
        // compareTexts();
      })
  }, 150)
  
  slider1.addEventListener('input', (ev) => {
    updateHighlight(0, Number(ev.target.value));
  });
  slider2.addEventListener('input', (ev) => {
    updateHighlight(1, Number(ev.target.value));
  });

  let root = document.createElement('div');
  root.setAttribute('id', img_id);
  root.appendChild(wrap);
  root.appendChild(slider1);
  root.appendChild(slider2);
  root.appendChild(previews);
  document.currentScript.after(root);
}
</script>

## Persuasion, by Jane Austen

I've not yet been convinced to read *Persuasion*. Perhaps if the title were more enticing. Anyway, take a look at this. Click or shift+click around, drag the sliders and see the text at different sections.

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/persuasion.1.png");</script>

It's fairly uniformly gray. There's that darker square near the end, but since I haven't read the book, I couldn't tell you why.

I made another variation of the chart by comparing word *pairs* rather than single words. For instance take

> prided himself on remaining single

and turn it into

> prided himself
>
> himself on
>
> on remaining
>
> remaining single

Here's what *Persuasion* looks like with that method:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/persuasion.2.png");</script>

Seems like it just filters out more stuff.

## Ben Franklin

I'm still not quite sure what these charts show other than similarity. It could be writing style similarity. It could be topical similarity. It could be diction similarity. Probably just a combination. Here's what Ben Franklin's autobiography looks like:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/ben_franklin.1.png", 'ben-franklin-1');</script>

It's overall lighter than *Persuasion*, which I guess means it has more variety? But also, there's <button onclick="toggleCenterBox('ben-franklin-1', 'rgba(0,127,0,0.2)',369, 380);">one small part</button> right in the middle of the book that is unlike any other part of the book! That section begins with him talking about a blacksmith making an ax. Again, I haven't read this book, so I don't know why that part is different.

## Authorship

I've wondered if these kinds of heatmaps can help you identify authors. Do isolated squares indicate different authors?  To test this, here's a look at *Pride and Prejudice* and *Persuasion*, both written by Jane Austen:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/pride_and_persuasion.1.png");</script>

And again using the word pair method, which shows <button onclick="toggleCenterBox('pride-persuasion-2', 'rgba(0,127,0,0.2)', 0, 438); toggleCenterBox('pride-persuasion-2', 'rgba(127,127,0,0.2)', 438, IMAGESIZE);">two definite chunks</button>.

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/pride_and_persuasion.2.png", 'pride-persuasion-2');</script>

Now let's add another contemporary author's book and see how different it is from the other two. Here's a compilation of *Pride and Prejudice*, *Persuasion* and *The Count of Monte Cristo* (finally, a book I've read!):

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/pride_persuade_crisco.1.png", 'ppc');</script>

I thought I could see where each book began, but I accidentally thought the first part of *Monte Cristo* was *Persuasion*. Here's where they <button onclick="toggleCenterBox('ppc', 'rgba(0,127,0,0.2)',0,135);toggleCenterBox('ppc', 'rgba(127,127,0,0.2)',135,227);toggleCenterBox('ppc', 'rgba(0,127,127,0.2)',227,IMAGESIZE);">actually begin and end</button>.

*Pride and Prejudice* is very much like *Persuasion*, which are both very different from the *The Count of Monte Cristo*. And both Austen books are very much more like themselves than *Monte Cristo* is like itself.

Here's *The Count of Monte Cristo* by itself:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/monte_cristo.1.png", 'cristo');</script>

That <button onclick="toggleBox('cristo', 'rgba(0,127,127,0.75)',133, 0, 136, IMAGESIZE);">white bar</button> is the moment Dante finds the treasure. It's a moment that divides the plot in two; how fun that it's a moment unlike most others in the story.

## Bible

The Bible is a book written by various people. How does it look? Here's the King James version:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/bible.1.png", 'bible');</script>

<script>
function showhidebible() {
  let bookstarts = [
    ["Genesis", 0],
    ["Exodus", 36],
    ["Leviticus", 66],
    ["Numbers", 89],
    ["Deuteronomy", 120],
    ["Joshua", 147],
    ["Judges", 164],
    ["Ruth", 182],
    ["Samuel 1", 184],
    ["Samuel 2", 208],
    ["Kings 1", 227],
    ["Kings 2", 250],
    ["Chronicles 1", 272],
    ["Chronicles 2", 291],
    ["Ezra", 316],
    ["Nehemiah", 323],
    ["Esther", 332],
    ["Job", 338],
    ["Psalms", 355],
    ["Proverbs", 395],
    ["Ecclesiastes", 409],
    ["Song of Solomon", 414],
    ["Isaiah", 416],
    ["Jeremiah", 451],
    ["Lamentations", 491],
    ["Ezekiel", 494],
    ["Daniel", 531],
    ["Hosea - Malachi", 547],
    // ["Hosea", 542],
    // ["Joel", 547],
    // ["Amos", 549],
    // ["Obadiah", 553],
    // ["Jonah", 553],
    // ["Micah", 555],
    // ["Nahum", 558],
    // ["Habakkuk", 559],
    // ["Zephaniah", 560],
    // ["Haggai", 562],
    // ["Zechariah", 563],
    // ["Malachi", 569],
    ["Matthew", 570],
    ["Mark", 593],
    ["Luke", 607],
    ["John", 631],
    ["Acts", 649],
    ["Romans - Jude", 672],
    // ["Corinthians 1", 681],
    // ["Corinthians 2", 689],
    // ["Galatians", 695],
    // ["Ephesians", 698],
    // ["Philippians", 701],
    // ["Colossians", 703],
    // ["Thessalonians 1", 705],
    // ["Thessalonians 2", 706],
    // ["Timothy 1", 707],
    // ["Timothy 2", 710],
    // ["Titus", 711],
    // ["Philemon", 712],
    // ["Hebrews", 712],
    // ["James", 719],
    // ["Peter 1", 721],
    // ["Peter 2", 723],
    // ["John 1", 725],
    // ["John 2", 727],
    // ["John 3", 727],
    // ["Jude", 728],
    ["Revelation", 728],
    ["", IMAGESIZE],
  ]
  let colors = [
    "rgba(0,127,0,0.2)",
    "rgba(0,127,127,0.2)",
    "rgba(127,127,0,0.2)",
    "rgba(0,0,127,0.2)",
    "rgba(127,0,127,0.2)",
    "rgba(127,0,0,0.2)",
  ]
  for (let i = 0; i < (bookstarts.length - 1); i++) {
    let color = colors[i % colors.length];
    let [book, start] = bookstarts[i];
    let [_, end] = bookstarts[i+1];
    toggleCenterBox('bible', color, start, end, book);
  }
}
</script>

<button onclick="showhidebible()">Show/hide the books</button>

The black square right in the middle is Psalms. It's interesting to see Deuteronomy's echo later in the book. The Gospels (Matthew, Mark, Luke and John) are very similar to each other, as are Paul's epistles.

The Bible is pretty evenly similar to itself&mdash;that is, not very similar for the most part. Not what I would have guessed. I was expecting more distinct squares. Perhaps it was evened out because it was translated into English by a smallish group in a shortish time?

## Book of Mormon

Anyway, back to the image from the beginning, which is also a book full of books: the Book of Mormon. Here it is again, but interactive:

<script>
function showhidebookofmormon() {
  let bookstarts = [
    ["1 Nephi", 0],
    ["2 Nephi", 71],
    ["Jacob", 153],
    ["Enos - Words of Mormon", 178],
    // ["Enos", 178],
    // ["Jarom", 181],
    // ["Omni", 183],
    // ["Words of Mormon", 187],
    ["Mosiah", 189],
    ["Alma", 275],
    ["Helaman", 509],
    ["3 Nephi", 566],
    ["4 Nephi", 645],
    ["Mormon", 651],
    ["Ether", 677],
    ["Moroni", 723], 
    ["", IMAGESIZE],
  ]
  let colors = [
    "rgba(0,127,0,0.2)",
    "rgba(0,127,127,0.2)",
    "rgba(127,127,0,0.2)",
    "rgba(0,0,127,0.2)",
    "rgba(127,0,127,0.2)",
    "rgba(127,0,0,0.2)",
  ]
  for (let i = 0; i < (bookstarts.length - 1); i++) {
    let color = colors[i % colors.length];
    let [book, start] = bookstarts[i];
    let [_, end] = bookstarts[i+1];
    toggleCenterBox('bookofmormon-1', color, start, end, book);
    toggleCenterBox('bookofmormon-2', color, start, end, book);
  }
}
</script>

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/bookofmormon.1.png", 'bookofmormon-1');</script>

<button onclick="showhidebookofmormon()">Show/hide the books</button>

This book looks different than all the others I've looked at.

Definitely the most unique section is the <button onclick="toggleCenterBox('bookofmormon-1', 'rgba(127,0,0,0.5)', 163, 173, 'Olive tree')">Allegory of the Olive Trees</button> in Jacob.  Here's the <button onclick="toggleCenterBox('bookofmormon-1', 'rgba(0,127,0,0.5)', 106, 139, 'Isaiah')">Isaiah chapters</button> in 2 Nephi.  Here is Jesus Christ's <button onclick="toggleCenterBox('bookofmormon-1', 'rgba(0,127,127,0.5)', 596, 644, 'Jesus Christ')">visit to the Americas</button>. 

Here it is again with the word pair method:

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/bookofmormon.2.png", "bookofmormon-2");</script>

So what does this mean? Does this prove the Book of Mormon is true? By "true" I mean "written by ancient prophets and translated by Joseph Smith."

Nah. It's just interesting. A computer's not going to be able to tell you if it's true or not.

If you're not familiar with the book, in brief: it's a record kind of like the Bible, but written in the American continent rather than around the Middle East. The book was assembled on golden plates by a prophet named Mormon (hence the title), buried in the ground by his son, Moroni, then given by Moroni (now an angel) to Joseph Smith in the 1800s who then translated it "by the gift and power of God" as he says.

Plenty of people dispute Joseph Smith's story. I can understand why&mdash;it does sound a bit outlandish. There have been attempts (and will continue to be attempts) to prove and disprove its authenticity. While interesting, to me, the proof is in the pudding.

The pudding, in this case, is what the Book of Mormon teaches. I'm a better person for reading the book.

If you hang around members of the Church of Jesus Christ of Latter-day Saints long enough, they'll eventually mention a promise Moroni wrote down near the end. Moroni promises that you can know whether the Book of Mormon is true by reading it, then asking God "in the name of Christ, if these things are not true ... with a sincere heart, with real intent, having faith in Christ." I believe Moroni's promise is true, and I have tested it and feel that the promise has been proved to me personally.

There's another thing Moroni suggests right before the promise, and it has been one of the most meaningful things I've ever done when reading the scriptures:

> when ye shall read these things, if it be wisdom in God that ye should read them, *that ye would remember how merciful the Lord hath been unto the children of men*, from the creation of Adam even down until the time that ye shall receive these things, and ponder it in your hearts.

Remember how merciful the Lord has been throughout all time. Throughout your life. Take some quiet time to ponder.

## Other ideas?

It was fun to recreate my brother's original image. Any other ideas for things you can make computers do to books?

Here's the [code used to make these images](https://github.com/iffy/book-analysis/blob/master/charts.nim) and here are a few more books:

### Anna Karenina

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/anna_karenina.1.png");</script>

### Little Women

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/little_women.1.png");</script>

### Sherlock Holmes

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/sherlock_holmes.1.png");</script>

### Ulysses

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/ulysses.1.png");</script>

### War and Peace

<script>showInspectableImage("{% if jekyll.environment == "development" %}http://127.0.0.1:8080/v1{% else %}https://www.iffycan.com/book-analysis/v1{% endif %}/war_and_peace.1.png");</script>