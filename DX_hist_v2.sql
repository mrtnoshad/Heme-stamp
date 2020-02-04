
CREATE OR REPLACE TABLE Heme_stamp.DX_hist_v2 AS
(

WITH 

DX_Hist as
(select jc_uid, dx_name, timestamp
  from starr_datalake2018.diagnosis_code
)


SELECT HM.ANON_ID, HM.label,
  max(case when (DX_Hist.dx_name like '%chemotherapy%') then 1 else 0 end) as chemo_dx_hist,
  max(case when (DX_Hist.dx_name like '%Other long term (current) drug therapy%') then 1 else 0 end) as other_long_therapy_dx_hist,
  max(case when (DX_Hist.dx_name like '%MDS%') then 1 else 0 end) as MDS_dx_hist,
  max(case when (DX_Hist.dx_name like '%Thrombocytopenia%') then 1 else 0 end) as Thrombocytopenia_dx_hist,
  max(case when (DX_Hist.dx_name like '%Neoplasm%') then 1 else 0 end) as Neoplasm_dx_hist,
  max(case when (DX_Hist.dx_name like '%skin eruption%') then 1 else 0 end) as skin_eruption_dx_hist,
  max(case when (DX_Hist.dx_name like '%Sezary%') then 1 else 0 end) as Sezary_dx_hist,
  max(case when (DX_Hist.dx_name like '%myelodysplastic%') then 1 else 0 end) as myelodysplastic_dx_hist,
  max(case when (DX_Hist.dx_name like '%hypertension%') then 1 else 0 end) as hypertension_dx_hist,
  max(case when (DX_Hist.dx_name like '%Myelofibrosis%') then 1 else 0 end) as Myelofibrosis_dx_hist,
  max(case when (DX_Hist.dx_name like '%Mycosis%') then 1 else 0 end) as Mycosis_dx_hist
  
  
  
FROM Heme_stamp.Heme_stamp_data as HM 
  Left join DX_Hist
  ON DX_Hist.jc_uid = HM.ANON_ID
  AND CAST(DX_Hist.timestamp as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(DX_Hist.timestamp as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP By HM.ANON_ID, HM.label
)
