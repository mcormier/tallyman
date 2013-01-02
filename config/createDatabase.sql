
create table books(title varchar(256), 
                   author varchar(256), 
                   digital boolean default 0,
                   pages smallint, 
                   dateFinished date default current_date );

-- Lifts
-- =====
-- Used for tracking 1RM, 3RM and 5RM  olympic lifts
--
create table lifts(name varchar(256), weight smallint, 
                   reps smallint default 1, day date default current_date );

-- CountTable
-- ==========
-- A table for counting events that occur infrequently, and will occur once a day at most.
-- i.e. Stubbed Toe - March 12th
-- 
create table countTable(event varchar(256), day date default current_date ); 

-- Music
-- =====
-- Media (CD, Record, MP3)
-- Used 0 = False, 1 = True
--
create table music(media varchar(256), artist varchar(256), albumTitle varchar(256), 
                   price smallint, used boolean default 0, dayPurchased date default current_date ); 

.quit

