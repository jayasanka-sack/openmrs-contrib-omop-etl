MODEL(
        name omop_db.COHORT_DEFINITION,
        kind FULL,
        columns(
                cohort_definition_id INT NOT NULL,
                cohort_definition_name VARCHAR(255) NOT NULL,
                cohort_definition_description TEXT,
                definition_type_concept_id INT NOT NULL,
                cohort_definition_syntax TEXT,
                subject_concept_id INT NOT NULL,
                cohort_initiation_date DATE
        )
);

SELECT c.cohort_id                       AS cohort_definition_id,
       c.name                            AS cohort_definition_name,
       c.description                     AS cohort_definition_description,
       CASE
           WHEN c.definition_handler IS NOT NULL THEN 44819108 -- Criteria Based
           ELSE 44819114                                        -- Ad hoc
           END                           AS definition_type_concept_id,
       c.definition_handler_config       AS cohort_definition_syntax,
       0                                 AS subject_concept_id,
       DATE(c.startDate)                 AS cohort_initiation_date
FROM openmrs.cohort AS c
WHERE c.voided = 0;
