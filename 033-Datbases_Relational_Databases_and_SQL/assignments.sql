/*
SQL Movie-Rating Query Exercises
You've started a new movie-rating website, and you've been collecting data on reviewers' ratings of various movies. There's not much data yet, but you can still try out some interesting queries. Here's the schema:

Movie ( mID, title, year, director )
English: There is a movie with ID number mID, a title, a release year, and a director.

Reviewer ( rID, name )
English: The reviewer with ID number rID has a certain name.

Rating ( rID, mID, stars, ratingDate )
English: The reviewer rID gave the movie mID a number of stars rating (1-5) on a certain ratingDate.

Your queries will run over a small data set conforming to the schema. View the database. (You can also download the schema and data.)
*/

/*
Q1
1/1 point (graded)
Find the titles of all movies directed by Steven Spielberg.
*/

select title
FROM movie
where director = 'Steven Spielberg';


/*
Q2
1/1 point (graded)
Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.

Note: Your queries are executed using SQLite, so you must conform to the SQL constructs supported by
*/

select distinct year
FROM movie join rating r
on movie.mid = r.mid
where r.stars >= 4
order by year asc

/*
Q2
1/1 point (graded)
Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
*/

select distinct year
FROM movie join rating r
on movie.mid = r.mid
where r.stars >= 4
order by year asc

/*
Q3
1/1 point (graded)
Find the titles of all movies that have no ratings.
*/
select distinct movie.title
FROM movie, rating
where movie.mid not in (select mid from rating)

/*
Q4
1/1 point (graded)
Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date.
*/
select reviewer.name 
from reviewer join rating on reviewer.rid = rating.rid
where rating.ratingdate is Null


/*
Q5
1/1 point (graded)
Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
*/

select r.name, movie.title, r.stars, r.ratingdate 
from movie join
	(reviewer join rating on reviewer.rid = rating.rid) r 
	on movie.mid = r.mid
order by r.name, movie.title , r.stars


/*
Q6
1/1 point (graded)
For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, return the reviewer's name and the title of the movie.
*/
select name, title
from movie 
join rating r1 using(mid)
join rating r2 using(rid, mid)
join reviewer using(rid)
where r1.ratingdate > r2.ratingdate and r1.stars > r2.stars


/*
Q7
1/1 point (graded)
For each movie that has at least one rating, find the highest number of stars that movie received. Return the movie title and number of stars. Sort by movie title.
*/
select title, max(r1.stars)
from movie 
join rating r1 using(mid)
group by title 
order by title


/*
Q8
1/1 point (graded)
For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
*/
select title, max(mx-mn) as r
from (
	select title, min(stars) as mn, max(stars) as mx
	from movie
	join rating using(mid)
	group by title) s
group by s.title
order by r desc, title


/*
Q9
1/1 point (graded)
Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. Don't just calculate the overall average rating before and after 1980.)
*/

select avg(stb.avg)-avg(sta.avg)
from 
	(select avg(stars) as avg
	from movie
	join rating using(mid)
	where year < 1980
	group by mid) as stb,
	
	(select avg(stars) as avg
	from movie
	join rating using(mid)
	where year > 1980
	group by mid) as sta

/*
--------------------------------------------------------------------
SQL Movie-Rating Query Exercises Extras

Q1
0 points (ungraded)
Find the names of all reviewers who rated Gone with the Wind.
*/


select distinct name 
from reviewer r join
	(select r.rid
	from rating r join movie m on r.mid = m.mid
	where m.title = 'Gone with the Wind') r2
on r.rid = r2.rid

/*
Q2
0 points (ungraded)
For any rating where the reviewer is the same as the director of the movie, return the reviewer name, movie title, and number of stars.
*/

select r2.name, m.title, r.stars 
from rating r join movie m on r.mid = m.mid
	join reviewer r2 on r.rid = r2.rid 
where r2."name" = m.director 


/*
Q3
0 points (ungraded)
Return all reviewer names and movie names together in a single list, alphabetized. (Sorting by the first name of the reviewer and first word in the title is fine; no need for special processing on last names or removing "The".)
*/

select * 
from 
	(select r.name from reviewer r)
	union
	select m.title from movie m
order by name


/*
Q4
0 points (ungraded)
Find the titles of all movies not reviewed by Chris Jackson.
*/

select distinct m.title
from movie m
where m.mID not in (select r.mID 
					 from rating r
					where r.rID in (select re.rID
									from reviewer re
									where re.name = 'Chris Jackson'));
/*
Q5
0 points (ungraded)
For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. For each pair, return the names in the pair in alphabetical order.
*/

select name1, name2 
from 
	(select distinct rev1.name as name1, rev2.name as name2
	from  rating r1
	join rating r2 on r1.mid = r2.mid
	join reviewer rev1 on r1.rid = rev1.rid
	join reviewer rev2 on r2.rid = rev2.rid
	where r1.rid <> r2.rid 
	order by name1, name2 ) as s
where name1 < name2

/*
0 points (ungraded)
For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name, movie title, and number of stars.
*/

select rev.name, m.title, stars
from rating r 
join reviewer rev on r.rid = rev.rid 
join movie m on r.mid = m.mid
where stars = (select min(stars) from rating) 

/*
Q7
0 points (ungraded)
List movie titles and average ratings, from highest-rated to lowest-rated. If two or more movies have the same average rating, list them in alphabetical order.
*/

select m.title, avg(stars) as rt
from rating r
join movie m using(mid)
group by m.title
order by rt desc, title

/*
0 points (ungraded)
Find the names of all reviewers who have contributed three or more ratings. (As an extra challenge, try writing the query without HAVING or without COUNT.)
*/


select name
from 
	(select r.name, count(*) as c
	from rating
	join reviewer r using(rid)
	group by r.name) as s
where c >= 3


/*
Q9
0 points (ungraded)
Some directors directed more than one movie. For all such directors, return the titles of all movies directed by them, along with the director name. Sort by director name, then movie title. (As an extra challenge, try writing the query both with and without COUNT.)
*/

select title, director
from movie 
where director in  (select director 
				from
				(select  m.director , count(*) as c
				from movie m 
				group by m.director ) as s
			where c > 1) 
order by director, title;



/*
Q10
0 points (ungraded)
Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. (Hint: This query is more difficult to write in SQLite than other systems; you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.)
*/

select title, max(rat)
from (select title, r.mid, avg(stars) as rat
	from rating r
	join movie m using(mid)
	group by mid) 

/*
Q11
0 points (ungraded)
Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. (Hint: This query may be more difficult to write in SQLite than other systems; you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.)
*/

select title, rat 
from
	(select title, r.mid, avg(stars) as rat
	from rating r
	join movie m using(mid)
	group by mid
	)  as s
where rat = (select min(rat) 
					from (select r.mid, avg(stars) as rat
							from rating r
							group by mid) as s)

/*
0 points (ungraded)
For each director, return the director's name together with the title(s) of the movie(s) they directed that received the highest rating among all of their movies, and the value of that rating. Ignore movies whose director is NULL.
*/


select director, title, max(rat)
from ( 
	select director, title, m.mID, max(stars) as rat
	from movie m
	join rating r using(mid)
	where director is not NULL
	group  by director, mid ) as s
group by director


/*
SQL Social-Network Query Exercises

Q1
0/1 points (graded)
Find the names of all students who are friends with someone named Gabriel.
*/


select h.name
from Friend f
join Highschooler h on f.ID1 = h.ID
join Highschooler h2 on f.ID2 = h2.id
where h2.name = 'Gabriel'


/*
Q2
0/1 points (graded)
For every student who likes someone 2 or more grades younger than themselves, return that student's name and grade, and the name and grade of the student they like.
*/

select  h.name, h.grade, h2.name, h2.grade
from Likes l
join Highschooler h on l.ID1 = h.ID
join Highschooler h2 on l.ID2 = h2.id
where (h.grade - h2.grade) >= 2


/*
Q3
0/1 points (graded)
For every pair of students who both like each other, return the name and grade of both students. Include each pair only once, with the two names in alphabetical order.

*/

select h.name, h.grade, h2.name, h2.grade
from  Likes l
join Likes l2 on l.id1 = l2.ID2
join Highschooler h on l.id1 = h.id
join Highschooler h2 on l.id2 = h2.id
where l.id1 = l2.id2 and l.id2=l2.id1 and h.name < h2.name


/*
Q4
0/1 points (graded)
Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their names and grades. Sort by grade, then by name within each grade.
*/

select name, grade
from Highschooler h
where h.id not in (select id1
							from likes 
							union
							select id2
							from likes)
order by grade, name

/*
Q5
0/1 points (graded)
For every situation where student A likes student B, but we have no information about whom B likes (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
*/

select h1.name, h1.grade, h2.name, h2.grade
from Likes l
join Highschooler h1 on l.id1 = h1.id
join Highschooler h2 on l.id2 = h2.id
where l.id2 not in (select id1 from likes)

/*
Q6
0/1 points (graded)
Find names and grades of students who only have friends in the same grade. Return the result sorted by grade, then by name within each grade.
*/

select h1.name, h1.grade
from Friend f
join Highschooler h1 on f.id1 = h1.id
join Highschooler h2 on f.id2 = h2.id
except 
select h1.name, h1.grade
			from Friend f
			join Highschooler h1 on f.id1 = h1.id
			join Highschooler h2 on f.id2 = h2.id
			where h1.grade <> h2.grade
order by h1.grade, h1.name

/*
Q7
0/1 points (graded)
For each student A who likes a student B where the two are not friends, find if they have a friend C in common (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
*/

select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from (select likers.id1 as l1, likers.id2 as l2, f1.id2 as fr from Friend f1
		join (
			select *
			from likes 
			EXCEPT
			select * 
			from friend ) as likers
		on f1.id1 = likers.id1
		join Friend f2 on f2.id1 = likers.id2
		where f1.id2 = f2.id2) as s
join Highschooler h1 on s.l1 = h1.id
join Highschooler h2 on s.l2 = h2.id
join Highschooler h3 on s.fr = h3.id

/*
Q8
0/1 points (graded)
Find the difference between the number of students in the school and the number of different first names.
*/

select counts - names
from 
	(select count(*) as counts
	from Highschooler),
	(select count(name) as names
	from (select distinct name from Highschooler)) 

/*
Q9
0/1 points (graded)
Find the name and grade of all students who are liked by more than one other student.
*/

select name, grade
from (select  name, grade, count(l.id2) as lks
	from Highschooler h
	left join Likes l on h.id = l.ID2 
	group by h.id) as s
where s.lks > 1

/*

*/

/*

*/

/*

*/

/*

*/



