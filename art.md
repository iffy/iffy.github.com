---
layout: page
title: Art
permalink: /art/
menu: main
---

I like making art. It's for fun. Here are the posts tagged with art.

<style>
table {
    border-collapse: collapse;
}
td {
    vertical-align: top;
    width: 50%;
    padding: 1rem;
}
td:first-child {
    sborder-right: 2px solid black;
}
td:last-child {
    background-color: rgba(240,240,240,1.0);
}
td img {
    margin-bottom: 1rem;
}
</style>

<table>
{% for post in site.posts %}
{% if post.tags contains "art" %}
<tr>
    <td>
{% if post.images %}
    {% for image in post.images %}
<img src="{{ image | prepend: site.baseurl }}">
    {% endfor %}
{% elsif post.image %}
<img src="{{ post.image | prepend: site.baseurl }}">
{% else %}
{% endif %}
    </td>
    <td>
        <a href="{{ post.url | prepend: site.baseurl }}">
            <div>{{ post.title }}</div>
            <div>{{ post.date | date: "%b %-d, %Y" }}</div>
        </a>
    </td>
</tr>
{% endif %}
{% endfor %}
</table>

