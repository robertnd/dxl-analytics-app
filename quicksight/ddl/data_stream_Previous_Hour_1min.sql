select
    transactiontype, sourcesystem, servicename, productid, channel, eventhour, eventday, eventmonth, eventyear, weekinmonth, weekinyear, dayinweek, dayinmonth, dayinyear, isweekday, dayname, monthname, windowaggregate,
    sum(itemcount) as itemcount, sum(amount) as amount
from data_stream_60secs
where 
eventhour between cast(date_part('h', dateadd(hour,-2,convert_timezone('EAT', sysdate)) ) as integer) and cast(date_part('h', dateadd(hour,-1,convert_timezone('EAT', sysdate)) ) as integer) and
    eventday = cast (date_part('d', convert_timezone('EAT', sysdate)) as integer) and
    eventmonth = cast (date_part('mon', convert_timezone('EAT', sysdate)) as integer) and
    eventyear = cast (date_part('y', convert_timezone('EAT', sysdate)) as integer)
group by transactiontype, sourcesystem, servicename, productid, channel, eventhour, eventday, eventmonth, eventyear, weekinmonth, weekinyear, dayinweek, dayinmonth, dayinyear, isweekday, dayname, monthname, windowaggregate