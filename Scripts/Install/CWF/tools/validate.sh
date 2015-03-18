#!/usr/bin/env bash
# Validate FHIR resources
#
# Set FHIR service roots
#
root1="http://localhost:9080/DSTU1"
root2="http://localhost:9080/DSTU2"
dstu1="java -jar validate.jar DSTU1 ${root1}"
dstu2="java -jar validate.jar DSTU2 ${root2}"
max=100
#
# Person
#
resource="Person"
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Patient
#
resource="Patient"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Encounter
#
resource="Encounter"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Condition
#
resource="Condition"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Observation
#
resource="Observation"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/VT-1-1
${dstu1} Patient/1/${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/VT-1-1
${dstu2} Patient/1/${resource}?_count=$max
#
# DocumentReference
#
resource="DocumentReference"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Immunization
#
resource="Immunization"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Alert/Flag
#
resource="Alert"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
#resource="Flag"
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Location
#
resource="Location"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max
#
# Medication
#
resource="Medication"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/11
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/11
${dstu2} ${resource}?_count=$max
#
# MedicationPrescription
#
resource="MedicationPrescription"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}?_count=$max
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}?_count=$max

