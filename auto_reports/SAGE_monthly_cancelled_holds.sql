-- Monthly Holds Cancelled Report --

SELECT * FROM (SELECT	EXTRACT(YEAR FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time") || '-' || LPAD(EXTRACT(MONTH FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time")::text,2,'0') AS "Hold Cancel Date",
	"743560702872e3e6d9c272eaa7e36b74"."shortname" AS "Patron's Home Library",
	"4f6ab23c031294937877e3e686649b0e"."shortname" AS "Pickup Library",
	"3aadd3567d41d9d82dacb9441a3f4076"."label" AS "Cancellation Cause",
	COUNT("3aadd3567d41d9d82dacb9441a3f4076"."id") AS "Count"
  FROM	action.hold_request AS "3b0d7d05c65006de7b2ca20f5fe39690"
	LEFT OUTER JOIN action.hold_request_cancel_cause AS "3aadd3567d41d9d82dacb9441a3f4076" ON ("3b0d7d05c65006de7b2ca20f5fe39690"."cancel_cause" = "3aadd3567d41d9d82dacb9441a3f4076"."id")
	INNER JOIN actor.usr AS "b7ef782e491021c8b18982b09cede6dd" ON ("3b0d7d05c65006de7b2ca20f5fe39690"."usr" = "b7ef782e491021c8b18982b09cede6dd"."id")
	INNER JOIN actor.org_unit AS "743560702872e3e6d9c272eaa7e36b74" ON ("b7ef782e491021c8b18982b09cede6dd"."home_ou" = "743560702872e3e6d9c272eaa7e36b74"."id")
	INNER JOIN actor.org_unit AS "4f6ab23c031294937877e3e686649b0e" ON ("3b0d7d05c65006de7b2ca20f5fe39690"."pickup_lib" = "4f6ab23c031294937877e3e686649b0e"."id")
  WHERE	EXTRACT(YEAR FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time") || '-' || LPAD(EXTRACT(MONTH FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time")::text,2,'0') BETWEEN EXTRACT(YEAR FROM $_10618$2016-08-19 13:29:06.686237-07$_10618$::TIMESTAMPTZ + $_10618$-1 months$_10618$) || $_10618$-$_10618$ || LPAD(EXTRACT(MONTH FROM $_10618$2016-08-19 13:29:06.686237-07$_10618$::TIMESTAMPTZ + $_10618$-1 months$_10618$)::text,2,$_10618$0$_10618$) AND EXTRACT(YEAR FROM $_10618$2016-08-19 13:29:06.686237-07$_10618$::TIMESTAMPTZ + $_10618$-1 months$_10618$) || $_10618$-$_10618$ || LPAD(EXTRACT(MONTH FROM $_10618$2016-08-19 13:29:06.686237-07$_10618$::TIMESTAMPTZ + $_10618$-1 months$_10618$)::text,2,$_10618$0$_10618$)
  GROUP BY 1, 2, 3, 4
  ORDER BY EXTRACT(YEAR FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time") || '-' || LPAD(EXTRACT(MONTH FROM "3b0d7d05c65006de7b2ca20f5fe39690"."cancel_time")::text,2,'0') ASC, "743560702872e3e6d9c272eaa7e36b74"."shortname" ASC, "4f6ab23c031294937877e3e686649b0e"."shortname" ASC, "3aadd3567d41d9d82dacb9441a3f4076"."label" ASC, COUNT("3aadd3567d41d9d82dacb9441a3f4076"."id") ASC
) limited_to_1048575_hits LIMIT 1048575;
