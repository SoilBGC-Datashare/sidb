---
layout: post
title: Guidance
---
 
The links below provide recommendations and guidelines to perform and report information from incubation studies


{% for guide in site.guidances %}
  <h2>
    <a href="{{site.baseurl}}{{ guide.url }}">
      {{ guide.title }} 
    </a>
  </h2>
<!--  <p>{{ guide.content }}</p> -->
{% endfor %}
 
