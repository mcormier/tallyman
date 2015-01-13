

Feature support for extracting yearly delta data is not complete.  In the interim, this file contains the SQL that can
be run to extract the data manually, massage that data and generate a report manually.


# Lift Data #


## Finding a Maximum lift value for all time ##

    SELECT MAX(weight), day  FROM lifts WHERE name='Deadlift' and reps=1;


## Print all Maximums achieved in a year ##

   SELECT name, reps, MAX(WEIGHT)
               FROM lifts
              WHERE date(day) > date('2013-12-31') AND date(day) < date('2014-12-31')
           GROUP BY name, reps;



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

For a specific year and a specific media format

  SELECT ( SELECT CASE WHEN used = 0 THEN 'New' ELSE 'Pre Loved' END ) as Condition
          ,total
      FROM (
             SELECT used, count(*) as total
               FROM music
              WHERE date(dayPurchased) > date('2013-12-31') AND date(dayPurchased) < date('2014-12-31')
                AND media = 'Vinyl'
           GROUP BY used
           );


# Books Data #

Number of books read in a year

    SELECT count(*)
      FROM books
     WHERE date(dateFinished) > date('2013-12-31') AND date(dateFinished) < date('2014-12-31');

Number of pages read in a year

   SELECT SUM(pages)
      FROM books
     WHERE date(dateFinished) > date('2013-12-31') AND date(dateFinished) < date('2014-12-31');
