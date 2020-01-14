Create OR REPLACE TABLE `Heme_stamp.Heme_stamp_data_unique` as
(
SELECT ANON_ID, max(label) as label, min(date_collected_jit) as date_collected_jit FROM `som-nero-phi-jonc101.Heme_stamp.Heme_stamp_data` 
GROUP BY ANON_ID
ORDER BY ANON_ID
)
