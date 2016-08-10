--Top 50 Holds Report
\o /home/opensrf/scripts/auto_reports/SAGE_weekly_top50holds2.csv
\a
\f |
SELECT * FROM (SELECT "210446682bb49afb05aad68eb78b4d4a"."hold_count" AS "Active Holds",
  "da9f0cb56ef4349e224632f85fbf25f8"."title" AS "Title",
  "da9f0cb56ef4349e224632f85fbf25f8"."author" AS "Author",
  "210446682bb49afb05aad68eb78b4d4a"."hold_copy_ratio" AS "Hold/Copy Ratio",
  "210446682bb49afb05aad68eb78b4d4a"."copy_count" AS "Holdable Copy Count",
  "9d45f36e3ae17a229e66552c812dbdf7"."id" AS "Record ID"
  FROM  (

            -- -- If we uncomment the RIGHT JOIN against biblio.record_entry, then we'll get a row for every non-deleted bib, whether it has active holds or not.
            -- -- If we expect to use pcrud to query against specific bibs, we probably want to do this.  However, if we're using this to populate a report, we
            -- -- may not.
            -- SELECT
            --     bre.id AS "bib_id",
            --     COALESCE( z.copy_count, 0 ) AS "copy_count",
            --     COALESCE( z.hold_count, 0 ) AS "hold_count",
            --     COALESCE( z.copy_hold_ratio, 0 ) AS "hold_copy_ratio"
            -- FROM (
                SELECT
                    y.bre AS "id",
                    COALESCE( x.copy_count, 0 ) AS "copy_count",
                    y.hold_count AS "hold_count",
                    (y.hold_count::REAL / (CASE WHEN x.copy_count = 0 OR x.copy_count IS NULL THEN 0.1 ELSE x.copy_count::REAL END)) AS "hold_copy_ratio"
                FROM (
                        SELECT
                            (SELECT bib_record FROM reporter.hold_request_record r WHERE r.id = h.id LIMIT 1) AS "bre",
                            COUNT(*) AS "hold_count"
                        FROM action.hold_request h
                        WHERE
                            cancel_time IS NULL
                            AND fulfillment_time IS NULL
                            -- AND NOT frozen  -- a frozen hold is still a desired hold, eh?
                        GROUP BY 1
                    )y LEFT JOIN (
                        SELECT 
                            (SELECT id
                                FROM biblio.record_entry 
                                WHERE id = (SELECT record FROM asset.call_number WHERE id = call_number and deleted is false)
                            ) AS "bre", 
                            COUNT(*) AS "copy_count"
                        FROM asset.copy
                            JOIN asset.copy_location loc ON (copy.location = loc.id AND loc.holdable)
                        WHERE copy.holdable 
                            AND NOT copy.deleted 
                            AND copy.status IN ( SELECT id FROM config.copy_status WHERE holdable ) 
                        GROUP BY 1
                    )x ON x.bre = y.bre
                -- )z RIGHT JOIN (
                --     SELECT id
                --     FROM biblio.record_entry
                --     WHERE NOT deleted
                -- )bre ON (z.bib_id = bre.id)
                

    ) AS "210446682bb49afb05aad68eb78b4d4a"
  LEFT OUTER JOIN biblio.record_entry AS "9d45f36e3ae17a229e66552c812dbdf7" ON ("210446682bb49afb05aad68eb78b4d4a"."id" = "9d45f36e3ae17a229e66552c812dbdf7"."id")
  LEFT OUTER JOIN reporter.materialized_simple_record AS "da9f0cb56ef4349e224632f85fbf25f8" ON ("9d45f36e3ae17a229e66552c812dbdf7"."id" = 
"da9f0cb56ef4349e224632f85fbf25f8"."id")
  WHERE (("9d45f36e3ae17a229e66552c812dbdf7"."deleted") IS NULL OR "9d45f36e3ae17a229e66552c812dbdf7"."deleted" = $_23614$f$_23614$)
  GROUP BY 1, 2, 3, 4, 5, 6
  ORDER BY "210446682bb49afb05aad68eb78b4d4a"."hold_count" DESC, "da9f0cb56ef4349e224632f85fbf25f8"."title" ASC, "da9f0cb56ef4349e224632f85fbf25f8"."author" ASC, 
"210446682bb49afb05aad68eb78b4d4a"."hold_copy_ratio" ASC, "210446682bb49afb05aad68eb78b4d4a"."copy_count" ASC, "9d45f36e3ae17a229e66552c812dbdf7"."id" ASC
) limited_to_1048575_hits LIMIT 50;
\o
