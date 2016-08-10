\o /home/opensrf/scripts/auto_reports/SAGE_wkly_hlds2.csv
\a
\f |
select * from
(
(
select aou.shortname as "Location",
case 
 when ahr.requestor=ahr.usr
  then 'Catalog'
 else 'Staff'
 END as "Station Type",
'Hold Placed' as "Circulation Type",
count(distinct ahr.id) as "Counts"
from
action.hold_request ahr
join actor.org_unit aou on aou.id=ahr.request_lib
where
(ahr.request_time >= date_trunc('week', CURRENT_TIMESTAMP - interval '1 week') and
ahr.request_time < date_trunc('week', CURRENT_TIMESTAMP))
--date_trunc('WEEK'::text, ahr.request_time) = date_trunc('WEEK'::text, now() - '1 week'::INTERVAL)
--ahr.request_time > (now()-'1 week'::interval)
AND aou.id IN (SELECT id FROM actor.org_unit_descendants(1))
-- 1=SAGE --
group by 1,2,3
order by aou.shortname
)
UNION
(select aou.shortname as "Location",
'Staff' as "Station Type",
'Hold Placed On Holdshelf' as "Circulation Type",
count(distinct ahr.id) as "Counts"
from
action.hold_request ahr
join actor.org_unit aou on aou.id=ahr.pickup_lib
where
(ahr.shelf_time >= date_trunc('week', CURRENT_TIMESTAMP - interval '1 week') and
ahr.shelf_time < date_trunc('week', CURRENT_TIMESTAMP))
--date_trunc('WEEK'::text, ahr.shelf_time) = date_trunc('WEEK'::text, now() - '1 week'::INTERVAL)
--ahr.shelf_time > (now()-'1 week'::interval)
AND aou.id IN (SELECT id FROM actor.org_unit_descendants(1))
-- 1=SAGE --
group by 1,2,3
order by aou.shortname
)
UNION
(
select aou.shortname as "Location",
'Staff' as "Station Type",
'Hold Fullfilled' as "Circulation Type",
count(distinct ahr.id) as "Counts"
from
action.hold_request ahr
join actor.org_unit aou on aou.id=ahr.pickup_lib
where
(ahr.fulfillment_time >= date_trunc('week', CURRENT_TIMESTAMP - interval '1 week') and 
ahr.fulfillment_time < date_trunc('week', CURRENT_TIMESTAMP))
--date_trunc('WEEK'::text, ahr.fulfillment_time) = date_trunc('WEEK'::text, now() - '1 week'::INTERVAL)
--ahr.fulfillment_time > (now()-'1 week'::interval)
AND aou.id IN (SELECT id FROM actor.org_unit_descendants(1))
-- 1=SAGE --
group by 1,2,3
order by aou.shortname
)
) as x
order by x."Location", x."Circulation Type", x."Station Type"
;
\o
