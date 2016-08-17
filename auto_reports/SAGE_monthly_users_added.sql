-- Simple Users Added Per Month
\o /home/opensrf/scripts/auto_reports/SAGE_monthly_users_added2.csv
\a
\f |
SELECT to_char (au.create_date, 'YYYY-MM') as "Month Added", aou2.shortname AS "System", aou.name AS "Library", COUNT(au.id) AS "Patrons Added"
   FROM actor.usr au
   JOIN actor.org_unit aou ON aou.id = au.home_ou
   JOIN actor.org_unit aou2 ON aou2.id= aou.parent_ou
  WHERE
  au.deleted IS FALSE AND date_trunc('MONTH'::text, au.create_date) = date_trunc('MONTH'::text, now() - '1 mon'::INTERVAL) 
  GROUP BY aou2.shortname, aou.name, "Month Added"
  ORDER BY aou2.shortname, aou.name;
  ;
\o
