

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

## Purchases ##

All forms of media

    SELECT Count(*) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31');

Total number of records bought

    SELECT Count(*) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31')
     AND media = 'Vinyl';

Total number of CDs bought

    SELECT Count(*) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31')
     AND media = 'CD';


## Cost ##

Amount spent in a year

    SELECT SUM(price) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31');

Amount spent in a year on Vinyl only

    SELECT SUM(price) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31')
       AND media = 'Vinyl';

Amount spent in a year on CDs only

    SELECT SUM(price) FROM music
     WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31')
       AND media = 'CD';

## Used vs New Purchases ##

All time

    SELECT ( SELECT CASE WHEN used = 0 THEN 'New' ELSE 'Pre Loved' END ) as Condition
          ,total
      FROM (
             SELECT used, count(*) as total
               FROM music
           GROUP BY used
           );

For a specific year

   SELECT ( SELECT CASE WHEN used = 0 THEN 'New' ELSE 'Pre Loved' END ) as Condition
          ,total
      FROM (
             SELECT used, count(*) as total
               FROM music
              WHERE date(dayPurchased) > date('2013-12-31') and date(dayPurchased) < date('2014-12-31')
           GROUP BY used
           );


# Books Data #