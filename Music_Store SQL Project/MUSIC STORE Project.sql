/* 1. Who is the senior most employee based on job levels?*/
SELECT * FROM EMPLOYEE;

SELECT title,last_name,first_name
from employee
order by levels desc
limit 1;

/*2. Who is the most junior employee based on job levels?*/
SELECT title,last_name,first_name
from employee
order by levels asc
limit 1;

/*3. Which countries have the most Invoices? */
select * from invoice;
select billing_country, count(invoice_id)
from invoice
group by billing_country
order by count(invoice_id) desc
limit 1;

/*4.  whats the Total invoice values? */
select ROUND (sum(total)) from invoice;

/* 5. What are top 3 values of total invoice? */
select ROUND (total) from invoice
order by total desc
limit 3;

/* 6. Which city has the best customers? We would like to throw a promotional Music Festival in the city 
we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,ROUND(sum(total))
from invoice
group by billing_city
order by sum(total) desc
limit 1;

/* 7. Who is the best customer? The customer who has spent the most money will be declared 
the best customer. Write a query that returns the person who has spent the most money */

select customer.customer_id,first_name,last_name,sum(total)
from invoice inner join customer using (customer_id)
group by customer.customer_id,first_name,last_name
order by sum(total) desc
limit 1;

/* 8. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select * from genre
select * from track
select email,first_name,last_name

select distinct email,Last_name, First_name
from customer
inner join invoice using (customer_id)
inner join invoice_line using(invoice_id)
where track_id IN (
select track_id from track
inner join genre using (genre_id)
where genre.name like 'Rock')
order by email;

select distinct email, first_name, Last_name
from customer
inner join invoice using (customer_id)
inner join invoice_line using (invoice_id)
inner join track using (track_id)
inner join genre using (genre_id)
where genre.name = 'Rock'

/* 9. Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands */
SELECT * FROM ARTIST
SELECT artist.artist_id, artist.name, count(track_id)
from track
join album using (album_id)
join artist using (artist_id)
join genre using (genre_id)
where genre.name = 'Rock'
group by artist.artist_id, artist.name
order by count(track_id) desc
limit 10;

/* 10. Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first */

select name, milliseconds
from track
where milliseconds > (
select avg(milliseconds) AS Average_Track_length
from track)
order by milliseconds desc;

/* Find how much amount spent by each customer on artists? Write a query to return customer name, 
artist name and total spent */

select c.first_name, c.last_name, a.name as artist_name, 
       sum(il.unit_price * il.quantity) as total_spent 
from customer c
join invoice i on c.customer_id = i.customer_id 
join invoice_line il on i.invoice_id = il.invoice_id 
join track t on il.track_id = t.track_id 
join album al on t.album_id = al.album_id 
join artist a on al.artist_id = a.artist_id 
group by c.customer_id, a.artist_id 
order by total_spent desc;

/*We want to find out the most popular music Genre for each country. We determine the most popular genre as 
the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared return all Genres */

SELECT 
    i.billing_country, 
    g.name AS genre, 
    COUNT(il.invoice_line_id) AS purchase_count 
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id 
JOIN track t ON il.track_id = t.track_id 
JOIN genre g ON t.genre_id = g.genre_id 
GROUP BY i.billing_country, g.genre_id 
HAVING 
    COUNT(il.invoice_line_id) = (
        SELECT 
            MAX(genre_counts.purchase_count) 
        FROM 
            (SELECT 
                COUNT(il2.invoice_line_id) AS purchase_count 
             FROM invoice i2
             JOIN invoice_line il2 ON i2.invoice_id = il2.invoice_id 
             JOIN track t2 ON il2.track_id = t2.track_id 
             JOIN genre g2 ON t2.genre_id = g2.genre_id 
             WHERE i2.billing_country = i.billing_country 
             GROUP BY 
                g2.genre_id) AS genre_counts
    )
ORDER BY 
    i.billing_country, genre;
	
/* Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount */

select i.billing_country, c.first_name, c.last_name, sum(i.total) as total_spent 
from customer c
join invoice i on c.customer_id = i.customer_id 
group by i.billing_country, c.customer_id 
having sum(i.total) = (
   select max(total_spent) 
   from (select sum(i2.total) as total_spent 
         from invoice i2
         where i2.billing_country = i.billing_country 
         group by i2.customer_id) as customer_spending)
order by i.billing_country, total_spent desc;


