select
    transactiontype, sourcesystem, servicename, productid, channel, eventhour, eventday, eventmonth, eventyear, weekinmonth, weekinyear, dayinweek, dayinmonth, dayinyear, isweekday, dayname, monthname, windowaggregate,
    sum(itemcount) as itemcount, sum(amount) as amount
from data_stream_900secs
where 
eventyear = cast (date_part('y', convert_timezone('EAT', sysdate)) as integer)
group by transactiontype, sourcesystem, servicename, productid, channel, eventhour, eventday, eventmonth, eventyear, weekinmonth, weekinyear, dayinweek, dayinmonth, dayinyear, isweekday, dayname, monthname, windowaggregate