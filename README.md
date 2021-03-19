# For figuring out an issue when updating owasp

## Currently used to look at performance issues
Curently looking at https://github.com/jeremylong/DependencyCheck/issues/3183

## Setup
Run the script run-test.sh
It has a commented out purge of the data directories. Consider running those.

## Original issue fixed in 6.0.3
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
