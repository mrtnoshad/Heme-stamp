-- Define 
CREATE OR REPLACE TABLE Heme_stamp.LAB_RES AS
(
WITH
LR as
(select rit_uid, group_lab_name, lab_name, result_flag, ord_num_value, reference_low, reference_high, result_time_jittered
  from starr_datalake2018.lab_result
),

-- Define WBC_history
WBC as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as lab_abn_WBC
  from Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  WHERE LR.lab_name like '%WBC%'
  AND LR.result_flag is not null
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
),

-- Define Hemoglobin_history
HMG as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as lab_abn_HMG
  from Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  WHERE LR.lab_name like '%Hemoglobin%'
  AND LR.result_flag is not null
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
),

-- Define PLT_history
PLT as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as lab_abn_PLT
  from Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  WHERE LR.lab_name like '%Platelet%'
  AND LR.result_flag is not null
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
),

-- Define PLT_history
NTR as
(select HM.ANON_ID, 
  (CASE WHEN count(*)>0 THEN 1 ELSE 0 END) as lab_abn_NTR
  from Heme_stamp.Heme_stamp_data as HM 
  Left join LR
  ON LR.rit_uid = HM.ANON_ID
  WHERE LR.lab_name like '%Neutrophil%'
  AND LR.result_flag is not null
  AND CAST(LR.result_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 10 DAY) 
  GROUP by HM.ANON_ID
)

Select HM.ANON_ID, HM.label, 
  (case when WBC.lab_abn_WBC=1 then 1 else 0 end) as lab_abn_WBC_bool,
  (case when HMG.lab_abn_HMG=1 then 1 else 0 end) as lab_abn_HMG_bool,
  (case when PLT.lab_abn_PLT=1 then 1 else 0 end) as lab_abn_PLT_bool,
  (case when NTR.lab_abn_NTR=1 then 1 else 0 end) as lab_abn_NTR_bool
  
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN WBC USING (ANON_ID)
  LEFt JOIN HMG USING (ANON_ID)
  LEFT JOIN PLT USING (ANON_ID)
  LEFT JOIN NTR USING (ANON_ID)

  
)

