
CREATE OR REPLACE TABLE Heme_stamp.LAB_RES_v2 AS
(

WITH 

LR as
(select rit_uid, group_lab_name, lab_name, result_flag, ord_num_value, reference_low, reference_high, result_time_jittered
  from starr_datalake2018.lab_result
)

SELECT HM.ANON_ID, HM.label,
  sum(case when (LR.lab_name like '%WBC%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%WBC%') then 1 else 0 end) + 1)  as abn_WBC,
  
  sum(case when (LR.lab_name like '%Hemoglobin%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Hemoglobin%') then 1 else 0 end) + 1)  as abn_Hgb,
  
  sum(case when (LR.lab_name like '%RDW%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%RDW%') then 1 else 0 end) + 1)  as abn_RDW,
  
  sum(case when (LR.lab_name like '%MCV%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%MCV%') then 1 else 0 end) + 1)  as abn_MCV,
  
  sum(case when (LR.lab_name like '%Eosinophil%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Eosinophil%') then 1 else 0 end) + 1)  as abn_Esn,
  
  sum(case when (LR.lab_name like '%Monocyte%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Monocyte%') then 1 else 0 end) + 1)  as abn_Mnc,
  
  sum(case when (LR.lab_name like '%MCH%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%MCH%') then 1 else 0 end) + 1)  as abn_MCH,
  
  sum(case when (LR.lab_name like '%LDH%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%LDH%') then 1 else 0 end) + 1)  as abn_LDH,
    
  sum(case when (LR.lab_name like '%CD3+/CD4%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%CD3+/CD4%') then 1 else 0 end) + 1)  as abn_CD34,
  
  sum(case when (LR.lab_name like '%CD3 (Pan T)%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%CD3 (Pan T)%') then 1 else 0 end) + 1)  as abn_CD3PanT,
  
  sum(case when (LR.lab_name like '%CD4/CD8%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%CD4/CD8%') then 1 else 0 end) + 1)  as abn_CD48,

  sum(case when (LR.lab_name like '%CD19%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%CD19%') then 1 else 0 end) + 1)  as abn_CD19,

  sum(case when (LR.lab_name like '%Anion%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Anion%') then 1 else 0 end) + 1)  as abn_Anion,
  
  sum(case when (LR.lab_name like '%IgG, Serum%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%IgG, Serum%') then 1 else 0 end) + 1)  as abn_IgG,
  
  sum(case when (LR.lab_name like '%Basophils%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Basophils%') then 1 else 0 end) + 1)  as abn_Basophils,
  
  sum(case when (LR.lab_name like '%RBC%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%RBC%') then 1 else 0 end) + 1)  as abn_RBC,
  
  sum(case when (LR.lab_name like '%Globulin%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Globulin%') then 1 else 0 end) + 1)  as abn_Globulin,
  
  sum(case when (LR.lab_name like '%Lymphocyte%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Lymphocyte%') then 1 else 0 end) + 1)  as abn_Lym,
  
  sum(case when (LR.lab_name like '%Neutrophil%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Neutrophil%') then 1 else 0 end) + 1)  as abn_Ntr,
  
  sum(case when (LR.lab_name like '%BUN%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%BUN%') then 1 else 0 end) + 1)  as abn_BUN,
  
  sum(case when (LR.lab_name like '%eGFR%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%eGFR%') then 1 else 0 end) + 1)  as abn_eGFR,
  
  -- Negative correlation features
  sum(case when (LR.lab_name like '%Albumin%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Albumin%') then 1 else 0 end) + 1)  as abn_Albumin,
  
  sum(case when (LR.lab_name like '%Glucose, Ser%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Glucose, Ser%') then 1 else 0 end) + 1)  as abn_Glc,
  
  sum(case when (LR.lab_name like '%Calcium%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Calcium%') then 1 else 0 end) + 1)  as abn_Cal,
  
  sum(case when (LR.lab_name like '%Creatinine%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Creatinine%') then 1 else 0 end) + 1)  as abn_Crt,
  
  sum(case when (LR.lab_name like '%Alk%' AND LR.result_flag is not null) then 1 else 0 end)/
  (sum(case when (LR.lab_name like '%Alk%') then 1 else 0 end) + 1)  as abn_Alk
  
FROM Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 3 DAY) 
  AND CAST(LR.result_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 MONTH) 
  GROUP by HM.ANON_ID, HM.label
  ORDER BY HM.ANON_ID
)
