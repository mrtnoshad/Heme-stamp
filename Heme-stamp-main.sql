SELECT HM.ANON_ID,   HM.label, demo.birth_date_jittered, demo.gender,
  (CASE demo.gender WHEN 'Male' THEN 0 ELSE 1 END) AS gender_bool,
  
FROM `som-nero-phi-jonc101.Heme_stamp.Heme_stamp_data` as HM
-- add age and gender information
LEFT JOIN
  (select rit_uid, birth_date_jittered, gender
  from starr_datalake2018.demographic) demo 
  ON (rit_uid=ANON_ID)
-- add previous diagnosis info
LEFT JOIN
  (select jc_uid, pat_enc_csn_id_coded, timestamp, dx_name, icd9, icd10
  from starr_datalake2018.diagnosis_code
  where dx_name like '%Atrial fibrillation%') diag
ON diag.jc_uid = HM.ANON_ID
WHERE diag.timestamp < labels.emergencyAdmitTime

