#!/usr/bin/env bash
# Validate FHIR resources
#
# Set FHIR service root
#
root=http://localhost:9080

#
# Validate resources
# $1 = Resource
# $2 = FHIR Version (DSTU1, DSTU2, etc.)
# $3 = Format (xml or json)
#
validate() {
	java -jar validate.jar $2 $3 ${root}/$2 $1 
}
#
# Person (DSTU2 only)
#
validate Person/1 DSTU2 xml
validate Person DSTU2 xml
validate Person/1 DSTU2 json
validate Person DSTU2 json
#
# Patient
#
validate Patient/1 DSTU1 xml
validate Patient DSTU1 xml
validate Patient/1 DSTU2 xml
validate Patient DSTU2 xml
validate Patient/1 DSTU1 json
validate Patient DSTU1 json
validate Patient/1 DSTU2 json
validate Patient DSTU2 json
#
# Encounter
#
validate Encounter/1 DSTU1 xml
validate Encounter DSTU1 xml
validate Encounter/1 DSTU2 xml
validate Encounter DSTU2 xml
validate Encounter/1 DSTU1 json
validate Encounter DSTU1 json
validate Encounter/1 DSTU2 json
validate Encounter DSTU2 json
#
# Condition
#
validate Condition/1 DSTU1 xml
validate Condition DSTU1 xml
validate Condition/1 DSTU2 xml
validate Condition DSTU2 xml
validate Condition/1 DSTU1 json
validate Condition DSTU1 json
validate Condition/1 DSTU2 json
validate Condition DSTU2 json
#
# Observation
#
validate Observation/VT-1-1 DSTU1 xml
validate Observation DSTU1 xml
validate Observation/VT-1-1 DSTU2 xml
validate Observation DSTU2 xml
validate Observation/VT-1-1 DSTU1 json
validate Observation DSTU1 json
validate Observation/VT-1-1 DSTU2 json
validate Observation DSTU2 json
#
# DocumentReference
#
validate DocumentReference/1 DSTU1 xml
validate DocumentReference DSTU1 xml
validate DocumentReference/1 DSTU2 xml
validate DocumentReference DSTU2 xml
validate DocumentReference/1 DSTU1 json
validate DocumentReference DSTU1 json
validate DocumentReference/1 DSTU2 json
validate DocumentReference DSTU2 json
#
# Immunization
#
validate Immunization/1 DSTU1 xml
validate Immunization DSTU1 xml
validate Immunization/1 DSTU2 xml
validate Immunization DSTU2 xml
validate Immunization/1 DSTU1 json
validate Immunization DSTU1 json
#validate Immunization/1 DSTU2 json
#validate Immunization DSTU2 json
#
# Alert/Flag
#
#validate Alert/1 DSTU1 xml
validate Alert DSTU1 xml
#validate Flag/1 DSTU2 xml
validate Flag DSTU2 xml
#validate Alert/1 DSTU1 json
validate Alert DSTU1 json
#validate Flag/1 DSTU2 json
#validate Flag DSTU2 json
#
# Location
#
validate Location/1 DSTU1 xml
validate Location DSTU1 xml
validate Location/1 DSTU2 xml
validate Location DSTU2 xml
validate Location/1 DSTU1 json
validate Location DSTU1 json
validate Location/1 DSTU2 json
validate Location DSTU2 json
#
# Medication
#
validate Medication/11 DSTU1 xml
validate Medication DSTU1 xml
validate Medication/11 DSTU2 xml
validate Medication DSTU2 xml
validate Medication/11 DSTU1 json
validate Medication DSTU1 json
validate Medication/11 DSTU2 json
validate Medication DSTU2 json
#
# MedicationPrescription
#
validate MedicationPrescription/1 DSTU1 xml
validate MedicationPrescription DSTU1 xml
validate MedicationPrescription/1 DSTU2 xml
validate MedicationPrescription DSTU2 xml
validate MedicationPrescription/1 DSTU1 json
validate MedicationPrescription DSTU1 json
validate MedicationPrescription/1 DSTU2 json
validate MedicationPrescription DSTU2 json
#
# Order
#
validate Order/1 DSTU1 xml
validate Order DSTU1 xml
validate Order/1 DSTU2 xml
validate Order DSTU2 xml
validate Order/1 DSTU1 json
validate Order DSTU1 json
validate Order/1 DSTU2 json
validate Order DSTU2 json
#
# OperationOutcome
#
validate OperationOutcome/9981008 DSTU1 xml
validate OperationOutcome DSTU1 xml
validate OperationOutcome/9981008 DSTU2 xml
validate OperationOutcome DSTU2 xml
validate OperationOutcome/9981008 DSTU1 json
validate OperationOutcome DSTU1 json
validate OperationOutcome/9981008 DSTU2 json
validate OperationOutcome DSTU2 json
