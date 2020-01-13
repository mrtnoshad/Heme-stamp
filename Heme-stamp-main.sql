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
Select HM.ANON_ID, AI_HIST.autoimmune_hist, LK_HIST.leukemia_hist, BD_HIST.blood_dis_hist
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN AI_HIST USING (ANON_ID)
  LEFt JOIN LK_HIST USING (ANON_ID)
  LEFT JOIN BD_HIST USING (ANON_ID)
  -- add age and gender
  LEFT JOIN
  (select rit_uid, birth_date_jittered, gender
  from starr_datalake2018.demographic) demo 
  ON (demo.rit_uid=HM.ANON_ID)
