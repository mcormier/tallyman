
# Tallyman #

Tallyman gathers data and generates a static website. It was built to collect personal data and can be easily customized to generate your own page of [statistics porn](http://chartporn.org). To see Tallyman in action check out the [demo page](http://mcormier.github.com/tallyman/).

![Website example] (http://mcormier.github.com/tallyman/images/previewSmall.png )

To generate the page you use a simple curses based interface to a database which then generates the webpage.

![Admin Interface => Database => Website] (http://mcormier.github.com/tallyman/images/tallymanArch.jpg )

## Motivation ##

**If you care about your data you should own it.** Many sites provide a free service where your data is the product.  Once you input the data into such a site you forgo some of your rights to that data, and a method to extract that data is rarely provided.

Not being able to export your data is an intentional design to retain users and create lock-in. Theoretically you have access to all your data as you can copy it manually, however, the more data you've input into a site, the more monumental a task this becomes. The web was not always a place where companies creating walled gardens was so common and accepted.

> "In the early part of this century, if you made a service that let users create or share content, the expectation was that they could easily download a full-fidelity copy of their data, or import that data into other competitive services, with no restrictions. Vendors spent years working on interoperability around data exchange purely for the benefit of their users, despite theoretically lowering the barrier to entry for competitors."
> - [Anil Dash - The Web We Lost](http://dashes.com/anil/2012/12/the-web-we-lost.html)

Whether the above statement is made with rose-coloured glasses or not, there has been a creeping awareness of this issue of data ownership as we continue to input more and more of our lives into these web applications.  Google has a [data liberation](http://www.dataliberation.org/) website.  [App.net](https://join.app.net/) although not free, is a reaction to twitter changing their API rules.  One of their core values is "You own your content". 

Sometimes your data isn't important, like many of the banal things posted on fartbook and tweeter, but you should own the data that is important to you.

Long story, long, my workout data is important to me so I wrote some software so I can geek out on the data. 

## Technical Details ##

Tallyman consists of a simple curses interface to an sqlite database and a script to extract that data to an XML format.  The XML is then converted to HTML with an XML style sheet (XSL).

![Admin Interface] (http://mcormier.github.com/tallyman/images/ncurses.gif )

Ruby + curses => SQLite => Ruby => XML data => xsltproc => HTML page


A curses interface was chosen to: 

1. Avoid creating a web-based CGI admin interface 
2. Keep the project scope small
3. Make rapid interface development possible

Theoretically no admin interface is necessary, you could simply connect to the database manually and insert the data by handcrafting SQL, and then run a script to regenerate the website. This isn't convenient though, and eventually even the most determined user would mostly forgoe such a process due to the inconvenience of contintually handcrafting SQL.

The final implementation is smoking fast.



## Design Pros and Cons ##

### Pros ###
1. You own your own data.
2. You can format the presentation of the data any way you like.
3. Log anything you want. Number of coffees per day if that's what floats your boat.
4. No possibility of a CGI security exploit since there is no web-based form interface.


### Cons ###
1. Requires an intial investment to setup and configure.  It's not as simple as filling out a web from with your name and email address.
2. User must be comfortable with running a command line interface to input their data
3. Custom formating the webpage requires knowledge of HTML and CSS
4. Customization requires knowledge of SQL and basic scripting
5. Technical nature of the design limits it to intermediate to advance users.

## Requirements ##
1. Ruby 1.9.1 or greater
2. SQLite 3
3. xsltcproc


## Configuration ##
1. Copy *config/config.properties.example* to *config.properties*
2. Modify the filenames in the configuration file as appropriate
3. Create your SQLite database with *bin/createDatabase*
4. Examine the themes under *data/themes* and copy the resources to your website root manually or with *bin/installTheme* 
5. Run *bin/tallyman* 


## Developing Locally ##

Some of the demos will generate Cross-Origin Request Blocked errors when doing
local development.  To see how the page will render when deployed on a server do the
following in Firefox. 

1.  view --> about:config

2.  set privacy.file\_unique\_origin  to false

--------------------------------------------------------------------
The feltron theme was heavily influenced, pretty much a direct copy of, Nicholas Feltron's [2006 annual report](http://feltron.com/ar06_01.html).

An alternative to setting up your own tallyman is to use [Daytum](http://daytum.com/) which does allow you to export your data as a CSV.  Daytum is free for the first 1000 items you log, they charge $4 a month if you require more space.


--------------------------------------------------------------------
Come, Mister tally man, tally me banana

