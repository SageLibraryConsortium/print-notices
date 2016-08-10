-- Combo Circ/Patron Served Stats
\o /home/opensrf/scripts/auto_reports/SAGE_monthly_circ_stats2.csv
\a
\f |
SELECT
 EXTRACT(YEAR FROM "ac"."xact_start") || '-' || LPAD(EXTRACT(MONTH FROM "ac"."xact_start")::text,2,'0') AS "Month",
   aouol."shortname" AS "Location",
  rct."type" AS "Circulation Type",
  COUNT(DISTINCT ac."id") AS "Circ Count",
  COUNT(DISTINCT ac.usr) AS "Patrons Served"
FROM
  reporter.circ_type AS rct
  LEFT OUTER JOIN action.circulation AS ac ON (rct."id" = ac."id")
  LEFT OUTER JOIN actor.usr AS au ON (ac."usr" = au."id")
  LEFT OUTER JOIN actor.org_unit AS aouol ON (ac."circ_lib" = aouol."id")
  WHERE
  date_trunc('MONTH'::text, ac."xact_start") = date_trunc('MONTH'::text, now() - '1 mon'::INTERVAL)
  AND aouol."id" IN (SELECT id FROM actor.org_unit_descendants(1))
  GROUP BY 1, 2, 3
  ORDER BY aouol."shortname" ASC, rct."type" ASC
  ;
\o
