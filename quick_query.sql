-- Define 

WITH
OM as
(select jc_uid, med_description, thera_class_name, end_time_jittered
  from starr_datalake2018.order_med
)

(Select HM.ANON_ID, HM.label, 
(case when count(*)>0 then 1 else 0 end) as num
from Heme_stamp.Heme_stamp_data as HM
  LEFT JOIN OM
  ON (HM.ANON_ID=OM.jc_uid)
  --WHERE OM.med_description like '%PREDNISONE%'
  --WHERE OM.med_description like '%METHYLPREDNISOLONE%' 
  --WHERE OM.med_description like  '%DEXAMETHASONE%'
  --where OM.med_description like '%RITUXIMAB%'
  WHERE thera_class_name like '%CHEMOTHERAPY%'
  GROUP BY HM.ANON_ID, HM.label
)
