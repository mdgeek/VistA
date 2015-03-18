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
# Observation
#
resource="Observation"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/VT\;1\;1
${dstu1} Patient/1/${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/VT\;1\;1
${dstu2} Patient/1/${resource}
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
# Immunization
#
resource="Immunization"
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
#resource="Flag"
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Location
#
resource="Location"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}
#
# Medication
#
resource="Medication"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/11
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/11
${dstu2} ${resource}
#
# MedicationPrescription
#
resource="MedicationPrescription"
echo Validating resource ${resource} @ ${root1}
${dstu1} ${resource}/1
${dstu1} ${resource}
echo Validating resource ${resource} @ ${root2}
${dstu2} ${resource}/1
${dstu2} ${resource}

