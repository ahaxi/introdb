-- Question 1
-- Find the names of all reviewers who rated Gone with the Wind.
select distinct a.name
from reviewer a
inner join rating b 
on a.rid = b.rid
inner join movie c
on b.mid = c.mid
where c.title = 'Gone with the Wind'

-- Question 2
-- For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
select distinct a.name, c.title, b.stars
from reviewer a
inner join rating b 
on a.rid = b.rid
inner join movie c
on b.mid = c.mid
where c.director = a.name

-- Question 3
-- Return all reviewer names and movie names together in a single list, alphabetized.  (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
select title 
from movie
union 
select name
from reviewer

-- Question 4
-- Find the titles of all movies not reviewed by Chris Jackson.
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

-- Question 5
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct name1, name2
from ( 
select R1.rID, Re1.name as name1, R2.rID, Re2.name as name2, R1.mID
from Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
where R1.mID = R2.mID
and R1.rID = Re1.rID
and R2.rID = Re2.rID
and Re1.name <> Re2.name
order by Re1.name ) as Pair
where name1 < name2

-- Question 6
-- For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
select name, title, stars
from Reviewer, Movie, Rating
where stars = ( select min(stars) from Rating)
and Reviewer.rID = Rating.rID 
and Rating.mID = Movie.mID

-- Question 7
-- List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order. 
select title, avg_rating
from movie a 
inner join (
  select mid, avg(stars) avg_rating
  from rating
  group by mid
) b
on a.mid = b.mid
order by 2 desc, 1

-- Question 8
-- Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from reviewer a, (select rid, count(mid)
from rating
group by rid
having count(mid) >= 3) b
on a.rid = b.rid

-- This is from https://github.com/yangchenyun/dbclass-exercises/blob/master/2.sql-exercise/movie-rating/core_set.sql#L94
-- challenging solution
select name
from Reviewer, (
  select distinct R1.rID
  from Rating R1, Rating R2, Rating R3
  where R1.rID = R2.rID and (R1.mID <> R2.mID or R1.ratingDate <> R2.ratingDate)
  and R1.rID = R3.rID and (R1.mID <> R3.mID or R1.ratingDate <> R3.ratingDate)
  and R3.rID = R2.rID and (R3.mID <> R2.mID or R3.ratingDate <> R2.ratingDate)
) ActiveUser
where Reviewer.rID = ActiveUser.rID

-- Question 9
-- Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.) 
select title, a.director
from movie a, (
select director, count(mid)
from movie
group by director
having count(mid) > 1
) b
where a.director = b.director
order by 2, 1

-- Question 10
-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select m.title, avg(r.stars) as strs 
from rating r
join movie m 
on m.mid = r.mid 
group by r.mid
having strs = (select max(s.stars) as stars from (select mid, avg(stars) as stars from rating
group by mid) as s)

-- This is from https://github.com/rilian/db_course_stanford_winter2013/blob/master/sql/sql_movie_rating_query_ex_challenge.md
-- Question 11
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) \
select m.title, avg(r.stars) as strs 
from rating r
join movie m 
on m.mid = r.mid 
group by r.mid
having strs = (select min(s.stars) as stars from (select mid, avg(stars) as stars from rating
group by mid) as s)

-- Question 12
-- For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
select distinct director, title, stars
from (movie join rating using (mid)) m
where stars in (select max(stars) 
                from rating join movie using (mid) 
                where m.director = director)
