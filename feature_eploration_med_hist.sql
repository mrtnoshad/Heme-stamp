WITH 

Med_Hist as
(select jc_uid, med_description, order_time_jittered
  from starr_datalake2018.order_med
)


select Med_Hist.med_description , count(*)/50000 as perc  -- 51303/ 49727
  from Heme_stamp.Heme_stamp_data as HM 
  Left join Med_Hist
  ON Med_Hist.jc_uid = HM.ANON_ID
  -- WHERE LR.result_flag is not null
  AND HM.label = 1.0 -- positive results
  AND CAST(Med_Hist.order_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(Med_Hist.order_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP BY Med_Hist.med_description
  ORDER BY perc desc
