CREATE OR REPLACE TABLE `Heme_stamp.demog` as 
(

With

-- Define autoimmune_history
DM as
(select rit_uid, birth_date_jittered, gender
  from starr_datalake2018.demographic
)

-- Define 
Select HM.ANON_ID, HM.label, 
  (case when DM.gender='Male' then 0 else 1 end) as gender_bool, 
  DATETIME_DIFF( CAST(HM.date_collected_jit as DATETIME) ,CAST( DM.birth_date_jittered as DATETIME), YEAR) as age
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN DM 
  ON (HM.ANON_ID=DM.rit_uid)

)

