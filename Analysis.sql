############################# Creating schema Assignment #############################
create schema assignment;

############### Importing file using the Import wizard of MySQL workbench ############
use assignment;
set SQL_SAFE_UPDATES = 0;

############## Describe the data types of all the table #############
select * from bajaj_auto;
select * from eicher_motors;
select * from hero_motocorp;
select * from infosys;
select * from tcs;
select * from tvs_motors;

######### Creating temporary table with the convertred Date column from text datatype to Datetime datatype ########
create table bajaj_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from bajaj_auto; 
create table eicher_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from eicher_motors;
create table hero_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from hero_motocorp;
create table infosys_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from infosys;
create table tcs_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tcs;
create table tvs_temp select str_to_date(Date,'%d-%M-%Y') Date,`Close Price` from tvs_motors;

## Part 1: Create a new table named 'bajaj1' containing the date, close price, 20 Day MA and 50 Day MA. (This has to be done for all 6 stocks) ##
#################################################################################################################################################

##### For Bajaj #####
create table bajaj1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from bajaj_temp
window w as (order by Date asc);
select * from bajaj1 limit 100;

#### For Eicher #####
create table eicher1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from eicher_temp
window w as (order by Date asc);
select * from eicher1 limit 100;

#### For Hero motocorp ####
create table hero1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from hero_temp
window w as (order by Date asc);
select * from hero1 limit 100;

#### For Infosys ####
create table infosys1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from infosys_temp
window w as (order by Date asc);
select * from infosys1 limit 100;

#### For TCS ####
create table tcs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tcs_temp
window w as (order by Date asc);
select * from tcs1 limit 100;

#### For TVS motors ####
create table tvs1
select row_number() over w as Day, Date,`Close Price`,
if((ROW_NUMBER() OVER w) > 19, (avg(`Close Price`) OVER (order by Date asc rows 19 PRECEDING)), null) `20 Day MA`,
if((ROW_NUMBER() OVER w) > 49, (avg(`Close Price`) OVER (order by Date asc rows 49 PRECEDING)), null) `50 Day MA`
from tvs_temp
window w as (order by Date asc);
select * from tvs1 limit 100;

############## Dropping Temporary tables #############
drop table bajaj_temp;
drop table eicher_temp;
drop table hero_temp;
drop table infosys_temp;
drop table tcs_temp;
drop table tvs_temp;


###################################################################################################################################################
## Part2: Create a master table containing the date and close price of all the six stocks. (Column header for the price is the name of the stock) ##

create table master_table 
select 
b.Date as Date,
b.`Close Price` as Bajaj, 
e.`Close Price` as Eicher, 
h.`Close Price` as Hero, 
i.`Close Price` as Infosys, 
t.`Close Price` as TCS, 
tv.`Close Price` as TVS
from bajaj1 b
left join eicher1 e on b.Date = e.Date 
left join hero1 h on b.Date = h.Date
left join infosys1 i on b.Date = i.Date
left join tcs1 t on b.Date = t.Date
left join tvs1 tv on b.Date = tv.Date;

select * from master_table;

###########################################################################################################################
## Part 3: Use the table created in Part(1) to generate buy and sell signal. Store this in another table named 'bajaj2'. ##
## Perform this operation for all stocks. #################################################################################

######### Creating temporary tables to get the previous day value for 20day MA and 50day MA ############

create table bajajx
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from bajaj1
window w as (order by Day);
select * from bajajx;

create table eicherx
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from eicher1
window w as (order by Day);
select * from eicherx;

create table herox
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from hero1
window w as (order by Day);
select * from herox;

create table infosysx
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from infosys1
window w as (order by Day);
select * from infosysx;

create table tcsx
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from tcs1
window w as (order by Day);
select * from tcsx;

create table tvsx
select 
Day, 
Date, 
`Close Price`, 
`20 Day MA`, 
lag(`20 Day MA`,1) over w as 20_MA_prev, 
`50 Day MA`, 
lag(`50 Day MA`,1) over w as 50_MA_prev
from tvs1
window w as (order by Day);
select * from tvsx;

############## Generating BUY/SELL/HOLD signal tables ##################

### For Bajaj ###
create table bajaj2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from bajajx;
select * from bajaj2 limit 100;

### For Eicher motors ###
create table eicher2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from eicherx;
select * from eicher2 limit 100;

### For Hero motocorp ###
create table hero2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from herox;
select * from hero2 limit 100;

### For Infosys ###
create table infosys2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from infosysx;
select * from infosys2 limit 100;

### For TCS ###
create table tcs2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from tcsx;
select * from tcs2 limit 100;

### For TVS ###
create table tvs2
select Date,`Close Price`,
(case when Day > 49 and `20 Day MA` > `50 Day MA` and 20_MA_prev < 50_MA_prev then 'BUY'
	 when Day > 49 and `20 Day MA` < `50 Day MA` and 20_MA_prev > 50_MA_prev then 'SELL'
else 'HOLD' end) as 'Signal'
from tvsx;
select * from tvs2 limit 100;

################### drop temporary tables #########################
drop table bajajx;
drop table eicherx;
drop table infosysx;
drop table herox;
drop table tcsx;
drop table tvsx;

##############################################################################################################################################################
## Part 4: Create a User defined function, that takes the date as input and returns the signal for that particular day (Buy/Sell/Hold) for the Bajaj stock. ##

delimiter $$
create function get_signal (s date)
returns char(10) deterministic
begin
declare s_value varchar(10);
set s_value = (select `Signal` from bajaj2 where Date = s);
return s_value;
end
$$
delimiter ;
select get_signal('2018-06-21') as `signal`;

###########################################################################################################################################################
