
CREATE OR REPLACE TABLE Heme_stamp.Family_hist_v2 AS
(

WITH 

Family_Hist as
(select jc_uid, medical_hx
  from starr_datalake2018.family_hx
)


SELECT HM.ANON_ID, HM.label,
  max(case when (Family_Hist.medical_hx like '%ancer%') then 1 else 0 end) as Cancer_med_hist, -- cancer
  max(case when (Family_Hist.medical_hx like '%Other%') then 1 else 0 end) as Other_med_hist, -- cancer
  max(case when (Family_Hist.medical_hx like '%CAD%') then 1 else 0 end) as CAD_med_hist -- cancer
  
   
FROM Heme_stamp.Heme_stamp_data as HM 
  Left join Family_Hist
  ON Family_Hist.jc_uid = HM.ANON_ID
  --AND CAST(Med_Hist.order_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  --AND CAST(Med_Hist.order_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP By HM.ANON_ID, HM.label
)
