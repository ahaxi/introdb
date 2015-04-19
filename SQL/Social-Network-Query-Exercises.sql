-- Reference: https://github.com/MathWay/db_course_stanford_winter2013/blob/master/06_SQL/06%20SQL%20Social-Network%20Query%20Exercises%20%28extra%20practice%29.md
-- Question 1
-- For every situation where student A likes student B, but student B likes a different student C, return the names and grades of A, B, and C. 
select (select name from Highschooler where id=l1.id1), 
       (select grade from Highschooler where id=l1.id1), 
       (select name from Highschooler where id=l1.id2), 
       (select grade from Highschooler where id=l1.id2), 
       (select name from Highschooler where id=l2.id2), 
       (select grade from Highschooler where id=l2.id2)
from likes l1 join likes l2  on l1.id2=l2.id1
where l1.id1 <> l2.id2

-- Question 2
-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names and grades. 
select name, grade
from Highschooler h1
where not grade in 
(
	select grade 
	from (Highschooler h2 
			join friend on h2.id=id1) a 
	where a.id2=h1.id
)

-- Question 3
-- What is the average number of friends per student? (Your result should be just one number.) 
select avg(c_friend)
from (
	select id1, count(*) c_friend
	from 
		(select id1 id1, id2 id2
		from friend
		union 
		select id2 id1, id1 id2
		from friend) s 
	group by id1
) ss

-- Question 4
-- Find the number of students who are either friends with Cassandra or are friends of friends of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend. 
select count(id2) from friend where id1 in (
  select id2 from friend where id1 in (select id from highschooler where name='Cassandra')
)
and id1 not in (select id from highschooler where name='Cassandra')

-- Question 5
-- Find the name and grade of the student(s) with the greatest number of friends. 
select h.name, h.grade from highschooler h, friend f where
h.id = f.id1 group by f.id1 having count(f.id2) = (
select max(r.c) from
(select count(id2) as c from friend group by id1) as r)

