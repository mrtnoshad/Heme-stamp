WITH 

DX_Hist as
(select jc_uid, dx_name, timestamp
  from starr_datalake2018.diagnosis_code
)



select DX_Hist.dx_name , count(*)/50000 as perc  -- 51303/ 49727
  from Heme_stamp.Heme_stamp_data as HM 
  Left join DX_Hist
  ON DX_Hist.jc_uid = HM.ANON_ID
  -- WHERE LR.result_flag is not null
  AND HM.label = 0.0 -- positive results
  AND CAST(DX_Hist.timestamp as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(DX_Hist.timestamp as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP BY DX_Hist.dx_name
  ORDER BY perc desc
