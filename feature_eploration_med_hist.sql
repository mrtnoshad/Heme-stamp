
--CREATE OR REPLACE TABLE Heme_stamp.med_hist_v2 AS


WITH 

Med_Hist as
(select jc_uid, med_description, order_time_jittered
  from starr_datalake2018.order_med
),

Label0 as
(
select Med_Hist.med_description , count(distinct Med_Hist.jc_uid) as perc  -- 51303/ 49727
  from Heme_stamp.Heme_stamp_data as HM 
  Left join Med_Hist
  ON Med_Hist.jc_uid = HM.ANON_ID
  -- WHERE LR.result_flag is not null
  AND HM.label = 0.0 -- positive results
  AND CAST(Med_Hist.order_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(Med_Hist.order_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP BY Med_Hist.med_description
  ORDER BY perc desc
),  
  
Label1 as
(
select Med_Hist.med_description , count(distinct Med_Hist.jc_uid) as perc  -- 51303/ 49727
  from Heme_stamp.Heme_stamp_data as HM 
  Left join Med_Hist
  ON Med_Hist.jc_uid = HM.ANON_ID
  -- WHERE LR.result_flag is not null
  AND HM.label = 1.0 -- positive results
  AND CAST(Med_Hist.order_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(Med_Hist.order_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP BY Med_Hist.med_description
  ORDER BY perc desc
)


 select Label0.med_description, (Label1.perc - Label0.perc) as diff
 From Label0
 Left Join Label1
 Using (med_description)
 Order by diff desc
