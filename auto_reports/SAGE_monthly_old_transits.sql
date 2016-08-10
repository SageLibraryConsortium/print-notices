-- Show list of copies in transit that have been in transit for a month or more.
\o /home/opensrf/scripts/auto_reports/SAGE_monthly_old_transits2.csv
\a
\f |
select aousource.shortname as "Source Location",
to_char (atc.source_send_time, 'YYYY-MM-DD') as "Sent On",
aoudest.shortname as "Destination Location",
aoucirclib.shortname as "Copy Circ Lib",
acscp.name as "Current Status",
acs.name as "Status Before Transit",
acp.barcode as "Barcode",
initcap(rssr.title) AS "Title",
initcap(rssr.author) AS "Author",
acnp.label||' '||
acn.label as "Call Number",
acl.name as "Shelving Location",
acp.circ_modifier AS "Circ Modifier",
bmp.label as "[If Exists] Part Name"
from action.transit_copy atc
join config.copy_status acs on (acs.id=atc.copy_status)
join actor.org_unit aousource on (atc.source=aousource.id)
join actor.org_unit aoudest on (atc.dest=aoudest.id)
join asset.copy acp on (atc.target_copy = acp.id)
join config.copy_status acscp on (acscp.id=acp.status)
join actor.org_unit aoucirclib on (acp.circ_lib = aoucirclib.id)
join asset.copy_location acl on (acp.location = acl.id)
join asset.call_number acn on (acp.call_number=acn.id)
left outer join asset.call_number_prefix acnp on (acnp.id=acn.prefix)
left outer join asset.copy_part_map acpm on (acpm.target_copy=acp.id)
left outer join biblio.monograph_part bmp on (bmp.id=acpm.part)
join reporter.super_simple_record rssr on (acn.record=rssr.id)
where 
source_send_time <= now()-'1 month'::interval
and dest_recv_time is null
order by atc.source, atc.source_send_time, atc.dest
;
\o
