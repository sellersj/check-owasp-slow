# For figuring out an issue when updating owasp

## Currently used to look at performance issues
Currently looking at:
https://github.com/jeremylong/DependencyCheck/issues/3408

## Setup
Run the script run-test.sh
It has a commented out purge of the data directories. Consider running those.

### How to check issues with h2
Start the server with `java -jar ~/.m2/repository/com/h2database/h2/1.4.199/h2-1.4.199.jar`
Go to `http://localhost:8082/`
Put in
Driver: org.h2.Driver
Location: jdbc:h2:file:~/.m2/repository/org/owasp/dependency-check-data/5.0/odc
Username: dcuser
Password: DC-Pass1337!

See core/src/main/resources/dependencycheck.properties

## Resolved issues

### NullPointerException for some artifacts fixed in 6.1.5
https://github.com/jeremylong/DependencyCheck/issues/3249

### Slow query fixed in 6.1.3
https://github.com/jeremylong/DependencyCheck/issues/3183

Run `EXPLAIN ANALYZE` on the query. In this case with a dummy value:
```
SELECT DISTINCT VENDOR, PRODUCT FROM CPEENTRY WHERE PART='a' AND ((REPLACE(VENDOR,'-','_')='bob' AND REPLACE(PRODUCT,'-','_')='bob') OR (REPLACE(VENDOR,'-','_')='bob' AND REPLACE(PRODUCT,'-','_')='bob') OR (REPLACE(VENDOR,'-','_')='bob' AND REPLACE(PRODUCT,'-','_')='bob') OR (REPLACE(VENDOR,'-','_')='bob' AND REPLACE(PRODUCT,'-','_')='bob'))
```

Result is
```
SELECT DISTINCT
    "VENDOR",
    "PRODUCT"
FROM "PUBLIC"."CPEENTRY"
    /* PUBLIC.IDXCPEENTRY: PART = 'a' */
    /* scanCount: 209373 */
WHERE ("PART" = 'a')
    AND ((((REPLACE("VENDOR", '-', '_') = 'bob')
    AND (REPLACE("PRODUCT", '-', '_') = 'bob'))
    AND (REPLACE("VENDOR", '-', '_') = REPLACE("PRODUCT", '-', '_')))
    OR ((((REPLACE("VENDOR", '-', '_') = 'bob')
    AND (REPLACE("PRODUCT", '-', '_') = 'bob'))
    AND (REPLACE("VENDOR", '-', '_') = REPLACE("PRODUCT", '-', '_')))
    OR (((REPLACE("VENDOR", '-', '_') = REPLACE("PRODUCT", '-', '_'))
    OR (REPLACE("VENDOR", '-', '_') = REPLACE("PRODUCT", '-', '_')))
    AND (((REPLACE("VENDOR", '-', '_') = 'bob')
    AND (REPLACE("PRODUCT", '-', '_') = 'bob'))
    AND (REPLACE("VENDOR", '-', '_') = REPLACE("PRODUCT", '-', '_'))))))
/*
reads: 5663
*/
```


### Original issue fixed in 6.0.3
This was fixed in 6.0.3 with [PR 2862](https://github.com/jeremylong/DependencyCheck/pull/2862)

If someone needs a work around, it can be like
```
echo "Applying work around for https://github.com/jeremylong/DependencyCheck/pull/2862/files"

mkdir target
mvn dependency:get -Dartifact=com.h2database:h2:1.4.199

echo "CREATE INDEX IF NOT EXISTS idxCpe ON cpeEntry(vendor, product);" > target/temp.sql
echo "" >> target/temp.sql

java -cp ~/.m2/repository/com/h2database/h2/1.4.199/h2-1.4.199.jar org.h2.tools.RunScript \
-url jdbc:h2:~/.m2/repository/org/owasp/dependency-check-data/5.0/odc \
-user "dcuser" -password DC-Pass1337! -script target/temp.sql -showResults
```
