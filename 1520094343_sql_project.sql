/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * 
FROM  `Facilities` 
WHERE membercost !=0
LIMIT 0 , 30

List of facilities that charge: Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2, Squash Court
/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * ) 
FROM  `Facilities` 
WHERE membercost =0

Count: 4
/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM  `Facilities` 
WHERE membercost < ( .2 * monthlymaintenance ) 
LIMIT 0 , 30

This produces a list of all facilities in the table.

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM  `Facilities` 
WHERE facid
IN ( 1, 5 ) 
LIMIT 0 , 30

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance >100
THEN  'expensive'
ELSE  'cheap'
END AS expensive
FROM  `Facilities` 
LIMIT 0 , 30


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, MAX( joindate ) 
FROM  `Members`

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by

SELECT
  f.name as tennis_court_name,
  CONCAT(m.surname, ",", " ", m.firstname) as member_full_name
FROM
  `Bookings` b
join
  `Facilities` f
on
  b.facid = f.facid
join
  `Members` m
on
  b.memid = m.memid
where
  f.name like '%Tennis Court%'
group by 1,2
order by member_full_name


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT  f.name, 
	CONCAT(m.surname, ",", " ", m.firstname) as member_full_name,
 	CASE WHEN member.firstname LIKE '%guest' THEN facility.guestcost * bookings.slots
	     WHEN member.firstname NOT LIKE '%guest%' THEN facility.membercost  * bookings.slots
	END AS cost
	FROM 'Members' m
	JOIN 'Bookings' b on b.memid = m.memid
	JOIN 'Facilities' f on f.facid = b.facid
	WHERE b.starttime LIKE '%2012-09-14%' AND cost > 30
	ORDER BY cost


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT  f.name, 
	CONCAT(m.surname, ",", " ", m.firstname) as member_full_name,
 	CASE WHEN m.firstname LIKE '%guest' THEN f.guestcost * b.slots
	     WHEN m.firstname NOT LIKE '%guest%' THEN f.membercost  * b.slots
	END AS cost
	FROM (select memid, facid from 'Bookings' b WHERE b.starttime LIKE '%2012-09-2014%')
	JOIN 'Members' m on b.memid = m.memid
	JOIN 'Facilities' f on f.facid = b.facid
	WHERE cost > 30
	ORDER BY cost

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT f.name, 
       CASE WHEN b.memid = 0 THEN f.guestcost * b.slots
	    WHEN b.memid != 0 THEN f.membercost * b.slots
	    END AS cost, 
	sum(cost) as revenue, 
	FROM 'Members' m
	JOIN 'Bookings' b on b.memid = m.memid
	JOIN 'Facilities' f on f.facid = b.facid
	GROUP BY f.name
	WHERE revenue < 1000