-- Challenge 1 - Most Profiting Author:

-- Step 1
SELECT titles.title_id as title_id,
		titleauthor.au_id as au_id,
		((titles.advance*titleauthor.royaltyper)/100) AS advance,
		(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royality
FROM titles
JOIN titleauthor ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
;


-- Step 2
SELECT title_id, au_id, sum(sales_royality) as sum_royality
FROM
(
	SELECT titles.title_id as title_id,
		titleauthor.au_id as au_id,
		((titles.advance*titleauthor.royaltyper)/100) AS advance,
		(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royality
	FROM titles
	JOIN titleauthor ON titleauthor.title_id = titles.title_id
	JOIN sales ON titles.title_id = sales.title_id
) as query1
GROUP BY title_id, au_id
order by sum_royality desc
;


-- Step 3
SELECT title_id, (sum_advance + sum_royality) as profit
FROM
(
	SELECT title_id, au_id, sum(sales_royality) as sum_royality, sum(advance) as sum_advance
	FROM
	(
		SELECT titles.title_id as title_id,
			titleauthor.au_id as au_id,
			((titles.advance*titleauthor.royaltyper)/100) AS advance,
			(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royality
		FROM titles
		JOIN titleauthor ON titleauthor.title_id = titles.title_id
		JOIN sales ON titles.title_id = sales.title_id
	) as query1
GROUP BY title_id, au_id
order by sum_royality desc
) as query2
GROUP BY title_id, profit
ORDER BY profit desc
;


-- Challenge 2 - Alternative Solution

CREATE TEMPORARY TABLE table1
(
SELECT titles.title_id as title_id,
		titleauthor.au_id as au_id,
		((titles.advance*titleauthor.royaltyper)/100) AS advance,
		(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royality
FROM titles
JOIN titleauthor ON titleauthor.title_id = titles.title_id
JOIN sales ON titles.title_id = sales.title_id
)
;

SELECT * FROM table1;

-- here we use the same query using the temporary table

SELECT title_id, au_id, sum(sales_royality) as sum_royality
FROM table1
GROUP BY title_id, au_id
order by sum_royality desc
;

-- Challenge 3

CREATE TABLE table2
(
SELECT title_id, (sum_advance + sum_royality) as profit
FROM
(
	SELECT title_id, au_id, sum(sales_royality) as sum_royality, sum(advance) as sum_advance
	FROM
	(
		SELECT titles.title_id as title_id,
			titleauthor.au_id as au_id,
			((titles.advance*titleauthor.royaltyper)/100) AS advance,
			(titles.price*sales.qty*(titles.royalty/100)*(titleauthor.royaltyper/100)) AS sales_royality
		FROM titles
		JOIN titleauthor ON titleauthor.title_id = titles.title_id
		JOIN sales ON titles.title_id = sales.title_id
	) as query1
GROUP BY title_id, au_id
order by sum_royality desc
) as query2
GROUP BY title_id, profit
ORDER BY profit desc
)
;
