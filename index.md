---
layout: default
title: Home
---

Welcome. I document my journey in software engineering here, mixing written tutorials with deep-dive videos.

## Latest Updates

<ul class="post-list">
  {% for post in site.posts %}
    <li>
      <span class="post-meta">{{ post.date | date: "%B %-d, %Y" }}</span>
      <h3>
        <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </h3>
      <p>{{ post.excerpt | strip_html | truncatewords: 30 }}</p>
      {% if post.youtube_id %}
        <small style="color: #e74c3c; font-weight: bold;">▶ Watch Video</small>
      {% endif %}
    </li>
  {% endfor %}
</ul>