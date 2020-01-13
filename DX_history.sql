CREATE OR REPLACE TABLE `Heme_stamp.DX_history` as 
(
-- import Heme_stamp_data
With

-- Define autoimmune_history
AI_HIST as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as autoimmune_hist
  from Heme_stamp.Heme_stamp_data as HM 
  Left join
  starr_datalake2018.diagnosis_code as diag
  ON diag.jc_uid = HM.ANON_ID
  where dx_name like '%autoimmune%'
  AND CAST(diag.timestamp_utc as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
),

-- Define '%leukemia%'
LK_HIST as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as leukemia_hist
  from Heme_stamp.Heme_stamp_data as HM 
  Left join
  starr_datalake2018.diagnosis_code as diag
  ON diag.jc_uid = HM.ANON_ID
  where dx_name like '%leukemia%'
  AND CAST(diag.timestamp_utc as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
),

-- Define '%blood disorder%'
BD_HIST as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as blood_dis_hist
  from Heme_stamp.Heme_stamp_data as HM 
  Left join
  starr_datalake2018.diagnosis_code as diag
  ON diag.jc_uid = HM.ANON_ID
  where dx_name like '%blood disorder%'
  AND CAST(diag.timestamp_utc as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
)

-- Define 
Select HM.ANON_ID, HM.label, 
  (case when AI_HIST.autoimmune_hist=1 then 1 else 0 end) as autoimmune_hist, 
  (case when LK_HIST.leukemia_hist = 1 then 1 else 0 end) as leukemia_hist, 
  (case when BD_HIST.blood_dis_hist = 1 then 1 else 0 end) as blood_dis_hist
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN AI_HIST USING (ANON_ID)
  LEFt JOIN LK_HIST USING (ANON_ID)
  LEFT JOIN BD_HIST USING (ANON_ID)

)

