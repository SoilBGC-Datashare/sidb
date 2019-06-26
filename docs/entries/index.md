---
layout: post
title: Entries
---
 
The links below provide an overview of each entry in the database


{% for entry in site.data.entries %}
{% assign ent = entry[1] %}
  <h2>
      {{ ent.citationKey }} 
  </h2>
  * doi: {{ent.doi}}
  * Study site: {{ ent.siteInfo.site }}
  * Country: {{ ent.siteInfo.country }}
{% endfor %}
 
