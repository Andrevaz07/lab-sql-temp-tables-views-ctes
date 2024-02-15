#Step 1: Create a View
#First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_info_customer AS 
SELECT c.customer_id, CONCAT( first_name, " " , last_name ) AS client, email , COUNT(rental_id) AS number_of_rentals
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY customer_id
ORDER BY number_of_rentals DESC ;

#Step 2: Create a Temporary Table
#Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE total_amount_paid_byclient AS 
SELECT rc.client, SUM(amount) AS total_spent 
FROM rental_info_customer rc
JOIN payment p ON rc.customer_id = p.customer_id
GROUP BY rc.client
ORDER BY total_spent DESC;

#Step 3: Create a CTE and the Customer Summary Report
#Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. The CTE should include the customer's name, email address, rental count, and total amount paid.

WITH rental_summary AS (
    SELECT rc.client, email, number_of_rentals, total_spent
    FROM rental_info_customer rc 
    JOIN total_amount_paid_byclient tc ON rc.client = tc.client
)
SELECT *
FROM rental_summary;

