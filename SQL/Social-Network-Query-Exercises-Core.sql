-- Reference: https://gist.github.com/DmitrySandalov/1354852
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

-- Question 3
-- For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.
select h1.name, h1.grade, h2.name, h2.grade  from Likes l1, Likes l2, Highschooler h1, Highschooler h2
where l1.ID1=l2.ID2 and l2.ID1=l1.ID2 and l1.ID1=h1.ID and l1.ID2=h2.ID and h1.name<h2.name;

-- Question 4
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
select distinct name, grade
from highschooler 
except
select distinct name, grade
from highschooler h, likes l
where h.id = l.id1 or h.id = l.id2
order by 2, 1

-- Better short answer
select name,grade from Highschooler 
where ID not in 
(select ID1 from Likes union select ID2 from Likes) 
order by grade, name;

-- Question 5
-- For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades. 
select h1.name, h1.grade, h2.name, h2.grade
from highschooler h1, highschooler h2, likes l
where h1.id = l.id1 and h2.id = l.id2
and l.id2 not in (select id1 from likes) 

-- Question 6
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade. 
select name, grade from Highschooler
where ID not in (
  select ID1 from Highschooler H1, Friend, Highschooler H2
  where H1.ID = Friend.ID1 and Friend.ID2 = H2.ID and H1.grade <> H2.grade)
order by grade, name;

-- Question 7
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C. 
select distinct H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from Highschooler H1, Likes, Highschooler H2, Highschooler H3, Friend F1, Friend F2
where H1.ID = Likes.ID1 
and Likes.ID2 = H2.ID 
and H2.ID not in (select ID2 from Friend where ID1 = H1.ID) 
and H1.ID = F1.ID1 and F1.ID2 = H3.ID and H3.ID = F2.ID1 and F2.ID2 = H2.ID;

-- Question 8
-- Find the difference between the number of students in the school and the number of different first names. 
select count(1) - count(distinct name)
from highschooler

-- Question 9
-- Find the name and grade of all students who are liked by more than one other student. 
select name, grade
from highschooler, (
select id2, count(id1)
from likes 
group by id2
having count(id1) > 1) t
where highschooler.id = t.id2
