create table books(name varchar(256), pages smallint, dateFinished datetime default current_timestamp );
create table lifts(name varchar(256), weight smallint, reps smallint default 1, date datetime default current_timestamp );
.quit

