
WITH

OM as
(select jc_uid, med_description, thera_class_name, end_time_jittered
  from starr_datalake2018.order_med
)

(Select med_description, count(*) as med_count --HM.ANON_ID, HM.label, count(*)
--(case when count(*)>0 then 1 else 0 end) as num
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN OM
  ON (HM.ANON_ID=OM.jc_uid)

  GROUP BY OM.med_description 
  ORDER BY med_count desc
  --GROUP BY HM.ANON_ID, HM.label
)

