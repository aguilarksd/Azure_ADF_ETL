SELECT name AS schema_name,
       schema_id,
       USER_NAME(principal_id) AS schema_owner
FROM sys.schemas
ORDER BY schema_name;

SELECT * FROM source.orders;