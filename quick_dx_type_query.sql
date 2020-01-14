
WITH
LR as
(select *
  from starr_datalake2018.diagnosis_code
)

(Select dx_name, count(*) as dx_count --HM.ANON_ID, HM.label, count(*)
--(case when count(*)>0 then 1 else 0 end) as num
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN LR
  ON (HM.ANON_ID=LR.jc_uid)

  GROUP BY dx_name
  ORDER BY dx_count desc
  --GROUP BY HM.ANON_ID, HM.label
)

