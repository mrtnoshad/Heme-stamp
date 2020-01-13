CREATE OR REPLACE TABLE `Heme_stamp.med_hist` as 
(

With

-- Define autoimmune_history
OM as
(select jc_uid, med_description, thera_class_name, end_time_jittered
  from starr_datalake2018.order_med
),


-- Define PREDNISONE_history
PRED_MED as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as PREDNISONE_MED
  from Heme_stamp.Heme_stamp_data as HM 
  Left join OM
  ON OM.jc_uid = HM.ANON_ID
  WHERE OM.med_description like '%PREDNISONE%'
  AND CAST(OM.end_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 30 DAY) 
  GROUP by HM.ANON_ID
),


-- Define METHYLPREDNISOLONE_history
METH_MED as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as METHYLPREDNISOLONE_MED
  from Heme_stamp.Heme_stamp_data as HM 
  Left join OM
  ON OM.jc_uid = HM.ANON_ID
  WHERE OM.med_description like '%METHYLPREDNISOLONE%'
  AND CAST(OM.end_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 30 DAY) 
  GROUP by HM.ANON_ID
),

-- Define DEXAMETHASONE_history
DEXA_MED as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as DEXAMETHASONE_MED
  from Heme_stamp.Heme_stamp_data as HM 
  Left join OM
  ON OM.jc_uid = HM.ANON_ID
  WHERE OM.med_description like '%DEXAMETHASONE%'
  AND CAST(OM.end_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 30 DAY) 
  GROUP by HM.ANON_ID
),

-- Define RITUXIMAB_history
RIT_MED as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as RITUXIMAB_MED
  from Heme_stamp.Heme_stamp_data as HM 
  Left join OM
  ON OM.jc_uid = HM.ANON_ID
  WHERE OM.med_description like '%RITUXIMAB%'
  AND CAST(OM.end_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 30 DAY) 
  GROUP by HM.ANON_ID
),

-- Define HORMONE_history
HOR_MED as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as HORMONES_MED
  from Heme_stamp.Heme_stamp_data as HM 
  Left join OM
  ON OM.jc_uid = HM.ANON_ID
  WHERE OM.med_description like '%HORMONES%'
  AND CAST(OM.end_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 30 DAY) 
  GROUP by HM.ANON_ID
)

-- Main part 
Select HM.ANON_ID, HM.label, 
  (case when PRED_MED.PREDNISONE_MED=1 then 1 else 0 end) as PRED_med, 
  (case when METH_MED.METHYLPREDNISOLONE_MED = 1 then 1 else 0 end) as METH_med, 
  (case when DEXA_MED.DEXAMETHASONE_MED = 1 then 1 else 0 end) as DEXA_med,
  (case when RIT_MED.RITUXIMAB_MED = 1 then 1 else 0 end) as RIT_med,
  (case when HOR_MED.HORMONES_MED = 1 then 1 else 0 end) as HOR_med
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN PRED_MED USING (ANON_ID)
  LEFt JOIN METH_MED USING (ANON_ID)
  LEFT JOIN DEXA_MED USING (ANON_ID)
  LEFT JOIN RIT_MED USING (ANON_ID)
  LEFT JOIN HOR_MED USING (ANON_ID)

)



  --(case when DM.gender='Male' then 0 else 1 end) as gender_bool, 
  --DATETIME_DIFF( CAST(HM.date_collected_jit as DATETIME) ,CAST( DM.birth_date_jittered as DATETIME), YEAR) as age
