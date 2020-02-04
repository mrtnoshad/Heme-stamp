CREATE OR REPLACE TABLE Heme_stamp.med_hist_v2 AS
(

WITH 

Med_Hist as
(select jc_uid, med_description, order_time_jittered
  from starr_datalake2018.order_med
)


SELECT HM.ANON_ID, HM.label,
  max(case when (Med_Hist.med_description like '%DEXAMETHASONE%') then 1 else 0 end) as DEXAMETHASONE_med_hist,
  max(case when (Med_Hist.med_description like '%BOLUS%') then 1 else 0 end) as IV_BOLUS_med_hist,
  max(case when (Med_Hist.med_description like '%ONDANSETRON%') then 1 else 0 end) as ONDANSETRON_med_hist,
  max(case when (Med_Hist.med_description like '%LIDOCAINE%') then 1 else 0 end) as LIDOCAINE_med_hist,
  max(case when (Med_Hist.med_description like '%HEPARIN%') then 1 else 0 end) as HEPARIN_hist,
  max(case when (Med_Hist.med_description like '%SODIUM CHLORIDE%') then 1 else 0 end) as SODIUM_CHLORIDE_hist,
  max(case when (Med_Hist.med_description like '%ALTEPLASE%') then 1 else 0 end) as ALTEPLASE_hist,
  max(case when (Med_Hist.med_description like '%EPINEPHRINE%') then 1 else 0 end) as EPINEPHRINE_hist,
  max(case when (Med_Hist.med_description like '%CHEMO%') then 1 else 0 end) as CHEMO_med_hist
  
FROM Heme_stamp.Heme_stamp_data as HM 
  Left join Med_Hist
  ON Med_Hist.jc_uid = HM.ANON_ID
  AND CAST(Med_Hist.order_time_jittered as DATETIME) <  DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 1 DAY) 
  AND CAST(Med_Hist.order_time_jittered as DATETIME) > DATETIME_SUB( CAST(HM.date_collected_jit as DATETIME), INTERVAL 18 MONTH) 
  GROUP By HM.ANON_ID, HM.label
)
