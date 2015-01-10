

Feature support for extracting yearly delta data is not complete.  In the interim, this file contains the SQL that can
be run to extract the data manually, massage that data and generate a report manually.


# Lift Data #


## Finding a Maximum lift value for all time ##

    SELECT MAX(weight), day  FROM lifts WHERE name='Deadlift' and reps=1;


## Finding a Maximum lift value for a specific year ##

    SELECT MAX(weight), day  FROM lifts
     WHERE name='Deadlift' and reps=1
       and date(day) > date('2013-12-31') and date(day) < date('2015-12-31');


# Music Data #

## CDS and Vinyl Bought ##

## Money spent on music in a year ##

    SELECT SUM(price) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2015-12-31');


# Books Data #