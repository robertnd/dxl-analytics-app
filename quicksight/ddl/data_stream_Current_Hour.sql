-- cast(date_part( 'h', convert_timezone('EAT', sysdate) ) as integer) and 
select
    transactiontype, sourcesystem, servicename, productid, channel,
    cast (date_part('m', convert_timezone('EAT', eattimestamp)) as integer) as eventminute, windowaggregate,
    sum(itemcount) as itemcount, sum(amount) as amount
from data_stream_60secs
where 
eventhour = cast(date_part( 'h', convert_timezone('EAT', sysdate) ) as integer) and
    eventday = cast (date_part('d', convert_timezone('EAT', sysdate)) as integer) and
    eventmonth = cast (date_part('mon', convert_timezone('EAT', sysdate)) as integer) and
    eventyear = cast (date_part('y', convert_timezone('EAT', sysdate)) as integer)
group by transactiontype, sourcesystem, servicename, productid, channel, eventminute, windowaggregate