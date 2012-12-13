
Tallyman
========
---

Tallyman gathers data and generates a static website. It was built to generate [stats.preenandprune.com](http://stats.preenandprune.com) but it can be easily customized to generate your own page.

To generate the page you use an admin interface to a database which then generates or regenerates a webpage.

Admin Interface => Database => Website 

Why did you build this?
-----------------------

I have been using [wodhub](http://wodhub.com/profiles/6534) for a while now to track my exercise data.  It's a free site.


Own your data.

![Cindy with a twist] (http://mcormier.github.com/tallyman/images/cindy.gif )



Why static?  PHP security holes/ Why regenerate the website if no data has changed?

Technical Details
--------------
---

Tallyman consists of a simple curses interface to an sqlite database.

Ruby + curses => sqlite => Ruby => xml data => xsltproc => html page

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