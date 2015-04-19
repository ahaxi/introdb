-- Question 1
-- Find the names of all students who are friends with someone named Gabriel. 
select h2.name
from highschooler h2
inner join (highschooler h1
inner join friend f
on h1.id = f.id1
and h1.name = 'Gabriel') s
where s.id2 = h2.id

-- Question 2
-- For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like. 
select distinct sName, sGrade, lName, lGrade
from (select h1.name as sName, h1.grade sGrade, h2.name as lName, h2.grade as lGrade, h1.grade-h2.grade as gradeDiff 
     from Highschooler h1, Likes, Highschooler h2
     where h1.ID=ID1 and h2.ID=ID2)
where gradeDiff>1;
