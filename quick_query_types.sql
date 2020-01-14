-- Define 

WITH
LR as
(select rit_uid, group_lab_name, lab_name, result_flag, ord_num_value, reference_low, reference_high
  from starr_datalake2018.lab_result
)

(Select lab_name, count(*) as cc --HM.ANON_ID, HM.label, count(*)
--(case when count(*)>0 then 1 else 0 end) as num
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN LR
  ON (HM.ANON_ID=LR.rit_uid)
  --WHERE group_lab_name like '%CBC%'
  --AND lab_name like '%WBC%'
  
  WHERE group_lab_name like '%CBC%' --'%Hemoglobin%'
  --WHERE lab_name like '%Hgb'
  GROUP BY lab_name
  ORDER BY cc desc
  --GROUP BY HM.ANON_ID, HM.label
)

