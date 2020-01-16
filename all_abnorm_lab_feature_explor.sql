WITH 

LR as
(select rit_uid, group_lab_name, lab_name, result_flag, ord_num_value, reference_low, reference_high, result_time_jittered
  from starr_datalake2018.lab_result
)

select LR.lab_name , count(*)/49727 as perc  -- 51303/ 49727
  from Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  WHERE LR.result_flag is not null
  AND HM.label = 1.0 -- positive results
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  AND CAST(LR.result_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 12 MONTH) 
  GROUP BY LR.lab_name
  ORDER BY perc desc
