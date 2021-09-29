#!/bin/bash

# exit if any of the commands return an error
set -e

OLDVERSION=6.3.1
NEWVERSION=6.3.2

# purge the repo
mvn org.owasp:dependency-check-maven:$OLDVERSION:purge
mvn org.owasp:dependency-check-maven:$NEWVERSION:purge

# update the repo
mvn org.owasp:dependency-check-maven:$OLDVERSION:update-only
mvn org.owasp:dependency-check-maven:$NEWVERSION:update-only

# run the tests
mvn -X -B org.owasp:dependency-check-maven:$OLDVERSION:check org.owasp:dependency-check-maven:$OLDVERSION:aggregate \
  -Dformat=ALL -DskipProvidedScope=true -DautoUpdate=false -DnuspecAnalyzerEnabled=false \
  -DassemblyAnalyzerEnabled=false -DnodeAuditAnalyzerEnabled=false -DnodeAnalyzerEnabled=false \
  -DrubygemsAnalyzerEnabled=false -DbundleAuditAnalyzerEnabled=false > $OLDVERSION.log
  
mvn -X -B org.owasp:dependency-check-maven:$NEWVERSION:check org.owasp:dependency-check-maven:$NEWVERSION:aggregate \
  -Dformat=ALL -DskipProvidedScope=true -DautoUpdate=false -DnuspecAnalyzerEnabled=false \
  -DassemblyAnalyzerEnabled=false -DnodeAuditAnalyzerEnabled=false -DnodeAnalyzerEnabled=false \
  -DrubygemsAnalyzerEnabled=false -DbundleAuditAnalyzerEnabled=false > $NEWVERSION.log
