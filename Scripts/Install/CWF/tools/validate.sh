#!/usr/bin/env bash
# Validate FHIR resources
#
# Set FHIR service roots
#
root1="http://localhost:9080/DSTU1"
root2="http://localhost:9080/DSTU2"
dstu1="java -jar validate-dstu1.jar ${root1}"
dstu2="java -jar validate-dstu2.jar ${root2}"
#
# Patient
#
resource="Patient"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Encounter
#
resource="Encounter"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Condition
#
resource="Condition"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# DocumentReference
#
resource="DocumentReference"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Alert/Flag
#
resource="Alert"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
resource="Flag"
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
