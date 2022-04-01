#!/bin/bash

# exit if any of the commands return an error
set -e

OLDVERSION=6.5.3
NEWVERSION=7.0.3

# purge and reupdate the repo for the old version
mvn org.owasp:dependency-check-maven:$OLDVERSION:purge
mvn org.owasp:dependency-check-maven:$OLDVERSION:update-only

# run the tests
mvn -X -B org.owasp:dependency-check-maven:$OLDVERSION:check org.owasp:dependency-check-maven:$OLDVERSION:aggregate \
  -Dformat=ALL -DskipProvidedScope=true -DautoUpdate=false -DnuspecAnalyzerEnabled=false \
  -DassemblyAnalyzerEnabled=false -DnodeAuditAnalyzerEnabled=false -DnodeAnalyzerEnabled=false \
  -DrubygemsAnalyzerEnabled=false -DbundleAuditAnalyzerEnabled=false > $OLDVERSION.log

# purge and reupdate the repo for the new version
mvn org.owasp:dependency-check-maven:$NEWVERSION:purge
mvn org.owasp:dependency-check-maven:$NEWVERSION:update-only

mvn -X -B org.owasp:dependency-check-maven:$NEWVERSION:check org.owasp:dependency-check-maven:$NEWVERSION:aggregate \
  -Dformat=ALL -DskipProvidedScope=true -DautoUpdate=false -DnuspecAnalyzerEnabled=false \
  -DassemblyAnalyzerEnabled=false -DnodeAuditAnalyzerEnabled=false -DnodeAnalyzerEnabled=false \
  -DrubygemsAnalyzerEnabled=false -DbundleAuditAnalyzerEnabled=false > $NEWVERSION.log
