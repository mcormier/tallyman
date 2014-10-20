

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
create table music(media varchar(256), 
                   artist varchar(256), 
                   albumTitle varchar(256), 
                   price smallint, 
                   used boolean default 0, 
                   dayPurchased date default current_date );

-- Same as CountTable but for counting events with a value associated with them
-- i.e. 10 pushups ...
create table valueTable(event varchar(256),value smallint, day date default current_date );

.quit

