{{ site.data.user.bio }}

![Picture of me]({{ site.data.user.avatar_url }}){:style="max-width: 128px; max-height: 128px"}

Hi, I'm Kevin.

Find me on [LinkedIn](https://www.linkedin.com/in/{{ site.linkedin_username| cgi_escape | escape }}) or [GitHub]({{site.data.user.html_url}}).

Check out my [website](https://www.kevinwmatthews.com) and [blog](https://blog.kevinwmatthews.com).

Peruse my repo webpages:

{% for link in site.data.links %}
  * [{{ link.name }}]({{ link.url }}): {{ link.description }}
{% endfor %}
