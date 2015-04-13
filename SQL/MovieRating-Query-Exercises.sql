-- Movie ( mID, title, year, director )
-- Reviewer ( rID, name )
-- Rating ( rID, mID, stars, ratingDate )
select distinct a.name
from reviewer a
inner join rating b 
on a.rid = b.rid
inner join movie c
on b.mid = c.mid
where c.title = 'Gone with the Wind'


-- Movie ( mID, title, year, director )
-- Reviewer ( rID, name )
-- Rating ( rID, mID, stars, ratingDate )
select distinct a.name, c.title, b.stars
from reviewer a
inner join rating b 
on a.rid = b.rid
inner join movie c
on b.mid = c.mid
where c.director = a.name



select title 
from movie
union 
select name
from reviewer



select title
from movie
except
select distinct c.title
from reviewer a
inner join rating b 
on a.rid = b.rid
inner join movie c
on b.mid = c.mid
where a.name = 'Chris Jackson'
