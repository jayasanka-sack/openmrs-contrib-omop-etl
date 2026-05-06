MODEL(
        name omop_db.DRUG_STRENGTH,
        kind FULL,
        columns(
                drug_concept_id INT NOT NULL,
                ingredient_concept_id INT NOT NULL,
                amount_value NUMERIC,
                amount_unit_concept_id INT,
                numerator_value NUMERIC,
                numerator_unit_concept_id INT,
                denominator_value NUMERIC,
                denominator_unit_concept_id INT,
                box_size INT,
                valid_start_date DATE NOT NULL,
                valid_end_date DATE NOT NULL,
                invalid_reason VARCHAR(1)
        )
);

SELECT COALESCE(drug_cm.conceptId, 0)               AS drug_concept_id,
       COALESCE(ingredient_cm.conceptId, 0)         AS ingredient_concept_id,
       di.strength                                   AS amount_value,
       unit_cm.conceptId                             AS amount_unit_concept_id,
       NULL                                          AS numerator_value,
       NULL                                          AS numerator_unit_concept_id,
       NULL                                          AS denominator_value,
       NULL                                          AS denominator_unit_concept_id,
       NULL                                          AS box_size,
       DATE(d.date_created)                          AS valid_start_date,
       COALESCE(DATE(d.date_retired), '2099-12-31')  AS valid_end_date,
       IF(d.retired = 1, 'D', NULL)                  AS invalid_reason
FROM openmrs.drug AS d
         INNER JOIN openmrs.drug_ingredient AS di ON d.drug_id = di.drug_id
         LEFT JOIN raw.CONCEPT_MAPPING drug_cm ON d.concept_id = drug_cm.sourceCode
         LEFT JOIN raw.CONCEPT_MAPPING ingredient_cm ON di.ingredient_id = ingredient_cm.sourceCode
         LEFT JOIN raw.CONCEPT_MAPPING unit_cm ON di.units = unit_cm.sourceCode;
