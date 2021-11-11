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

*/

/*

*/

/*

*/

/*

*/

/*

*/

/*

*/

/*

*/

/*

*/




