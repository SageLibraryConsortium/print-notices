// Clear Expired Age Protection off of an item
UPDATE asset.copy SET age_protect=null WHERE id IN (SELECT ac.id FROM asset.copy ac INNER JOIN config.rule_age_hold_protect p ON ac.age_protect=p.id  
WHERE now()>ac.active_date + cast(p.age as interval));
