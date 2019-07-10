---
layout: post
title: Entries
---
 
The list below provides an overview of all current entries in the database


{% for entry in site.data.entries %}
{% assign ent = entry[1] %}
  <h2>
      {{ ent.citationKey }} 
  </h2>
  * doi: <https://doi.org/{{ent.doi}}>
  * Study: {{ ent.study }}
{% endfor %}
 
