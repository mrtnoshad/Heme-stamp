
CREATE OR REPLACE TABLE Heme_stamp.DX_hist_v2 AS
(

WITH 

DX_Hist as
(select jc_uid, dx_name, timestamp
  from starr_datalake2018.diagnosis_code
)


SELECT HM.ANON_ID, HM.label,
  max(case when (DX_Hist.dx_name like '%chemotherapy%') then 1 else 0 end) as chemo_dx_hist,
  max(case when (DX_Hist.dx_name like '%Sezary%') then 1 else 0 end) as Sezary_dx_hist,
  max(case when (DX_Hist.dx_name like '%myelodysplastic%') then 1 else 0 end) as myelodysplastic_dx_hist,
  max(case when (DX_Hist.dx_name like '%hypertension%') then 1 else 0 end) as hypertension_dx_hist,
  max(case when (DX_Hist.dx_name like '%Myelofibrosis%') then 1 else 0 end) as Myelofibrosis_dx_hist,
  max(case when (DX_Hist.dx_name like '%neoplasm%') then 1 else 0 end) as neoplasm_dx_hist, --Secondary malignant neoplasm of bone
  max(case when (DX_Hist.dx_name like '%Mycosis%') then 1 else 0 end) as Mycosis_dx_hist
  
  
  
FROM Heme_stamp.Heme_stamp_data as HM 
  Left join DX_Hist
  ON DX_Hist.jc_uid = HM.ANON_ID
  AND CAST(DX_Hist.timestamp as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(DX_Hist.timestamp as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP By HM.ANON_ID, HM.label
)
