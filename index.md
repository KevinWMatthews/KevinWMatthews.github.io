{{ site.data.user.bio }}

![Picture of me]({{ site.data.user.avatar_url }}){:style="max-width: 128px; max-height: 128px"}

Hi, I'm Kevin.

Find me on [GitHub]({{site.data.user.html_url}}).

Find me on [LinkedIn](https://www.linkedin.com/in/{{ site.linkedin_username| cgi_escape | escape }}).

Check out my [website]({{site.data.user.blog}}).

Look through my repos with webpages, listed in alpabetical order:

{% for link in site.data.links %}
  * [{{ link.name }}]({{ link.url }}): {{ link.description }}
{% endfor %}
