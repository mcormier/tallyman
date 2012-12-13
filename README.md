
Tallyman
========
---

Tallyman gathers data and generates a static website. It was built to generate [stats.preenandprune.com](http://stats.preenandprune.com) but it can be easily customized to generate your own page.

To generate the page you use an admin interface to a database which then generates or regenerates a webpage.

Admin Interface => Database => Website 

Why?
-----------------------

I have been using [wodHub](http://wodhub.com/profiles/6534) for a while now to track my exercise data.  It's a free site for individuals and has expanded as a product sold to people running gyms. It helped me track my gym benchmarks but like all free web applications it has a major issue.  You don't control your data, the person that is paying to run that site owns your data.  It's free to use but the hidden cost is that you lose control of your data.  If the individual who is running wodHub goes bankrupt tomorrow then I lose all my data.

This concern was compounded by the fact that some of the main bench mark names changed unexpectedly.  There is a Crossfit benchmark called Cindy which was unexplicably renamed to "Cindy with a twist" for several months now.

![Cindy with a twist] (http://mcormier.github.com/tallyman/images/cindy.gif )

![Cindy with a twist] (http://mcormier.github.com/tallyman/images/Cindy2.gif )

There has been a slow change in the tech industry to make users data available to them and not keep it locked in to the website.

Google has a [data liberation](http://www.dataliberation.org/) website.

[App.net](https://join.app.net/) is a reaction to twitter changing their API rules.  One of their core values is "You own your content".

This is definitely not an industry standard but seems to be something that is gaining awareness as people put more data in more social web platforms. Linked-in, facebook, twitter, the list goes on.

Sometimes your data isn't important, like many of the banal things posted on facebook and twitter.

But you should own the data that is important to you.



Technical Details
--------------
---

Tallyman consists of a simple curses interface to an sqlite database.

Ruby + curses => sqlite => Ruby => xml data => xsltproc => html page


Why static?  PHP security holes/ Why regenerate the website if no data has changed?

Requirements
--------------
---
1. Ruby 1.9.1 or greater
2. SQLite 3
3. xsltcproc


Configuration
-------------
---
1. Create your SQLite database with data/createDatabase.sh
2. Copy config/config.properties.example to config.properties


--------------------------------------------------------------------
http://feltron.com/ar06_01.html  + http://daytum.com/ + http://wodhub.com/profiles/6534

--------------------------------------------------------------------
Come, Mister tally man, tally me banana