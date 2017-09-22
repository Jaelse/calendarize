
--Creating table for my_stocks: 

create table my_stocks (
symbol
varchar(20) not null,
n_shares
integer not null,
date_acquired
date not null
);

-- 7 Loading the data from text file into the database :

COPY my_stocks FROM '/home/priyanka/Desktop/stocktable.txt' DELIMITER E'\t';

-- Creating table for stock_price:

create table newly_acquired_stocks (
symbol
varchar(20) not null,
n_shares
integer not null,
date_acquired
date not null
);

-- 8 Copying Data from One Table to Another :
 
SELECT * INTO stock_price from (SELECT symbol, current_date as quote_date, 31.415 as price FROM my_stocks) AS foo;
        
-- 8 Copying half rows from my stocks into newly acquired stocks:

INSERT INTO newly_acquired_stocks SELECT * FROM my_stocks WHERE n_shares>=50;


-- 9 JOINing my stocks and stock prices :
 
SELECT M.symbol, M.n_shares, (M.n_shares/S.price) AS price_per_share, (M.n_shares*S.price) AS current_value FROM my_stocks M JOIN stock_price S ON M.symbol = S.symbol;


-- 10 Inserting a row into my stocks :

INSERT INTO my_stocks VALUES('SSNLF',52,'1994-09-27');

-- 10 Using OUTER JOIN :
 
SELECT M.symbol, M.n_shares, (M.n_shares/S.price) AS price_per_shares, (M.n_shares*S.price) AS current_value FROM  my_stocks M FULL OUTER JOIN stock_price S ON M.symbol = S.symbol;

--PL/SQL FUNCTION FOR ASCII :
create or replace function sumascii (str varchar) returns integer as $$
     
declare
x integer := 0;
i integer;
begin
    for i in 1..length (str)
    loop
        x := x + ascii (substr (str, i, 1)) ;
    end loop;
    return x;
end;
$$ language plpgsql;



-- 11 PL/SQL Function for ASCII values :
 
select symbol, sumascii(symbol) from my_stocks;

-- 11 Update stock prices to set each stock’s value to whatever is returned : 

UPDATE stock_price set price=sumascii(symbol);

-- 11 PL/SQL CURSOR FOR LOOP:
Create or replace function Portfolio() returns integer as $$

declare
   temp record;
   count_step integer default 0; 


c1 cursor
for SELECT (M.n_shares*S.price) AS current_value FROM my_stocks M JOIN stock_price S ON M.symbol = S.symbol;
 

BEGIN 
open c1;
loop

fetch c1 into temp;
exit when not found;
count_step := count_step + temp.current_value;
end loop;
close c1;
return count_step;
end;
$$
language plpgsql;

-- 11 PL/SQL Cursor FOR LOOP :

select portfolio();

++++++++++++++++++++

-- 12 Double your holdings in all the stocks whose price is higher than average :

insert into my_stocks select symbol, n_shares, current_date as date_acquired from my_stocks where symbol in (select symbol from stock_price where price > (select avg(price) from stock_price));

-- 12 Select..group by.. query from my stocks to produce a report of symbols and total shares held :

select symbol as report_of_symbols, SUM(n_shares) as total_shares_held from my_stocks GROUP BY symbol;

-- 12 Select..group by.. query JOINing with stock prices to produce a report of symbols and total value held per symbol.

select M.symbol as report_of_symbols, (SUM(M.n_shares)*S.price) as total_value_held_per_symbol from my_stocks M JOIN stock_price S ON M.symbol = S.symbol GROUP BY M.symbol, S.price;

-- 12 Select..groupby..having..query to produce a report of symbols, total shares held, and total value held per symbol restricted to symbols

select M.symbol as report_of_symbols, SUM(n_shares) as total_shares_held, (SUM(M.n_shares)*S.price) as total_value_held_per_symbol from my_stocks M JOIN stock_price S ON M.symbol = S.symbol GROUP BY M.symbol, M.n_shares, S.price having COUNT(M.symbol) > 1;




