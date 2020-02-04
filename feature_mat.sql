--CREATE OR REPLACE TABLE Heme_stamp.feature_mat AS
(
SELECT HMST.* EXCEPT (date_collected_jit), demog.* EXCEPT (ANON_ID, label), DX.* EXCEPT (ANON_ID, label), FM.* EXCEPT (ANON_ID, label), LR.* EXCEPT (ANON_ID, label), MH.* EXCEPT (ANON_ID, label)

--SELECT demog.*,  DX.autoimmune_hist,	DX.leukemia_hist,	DX.blood_dis_hist,
--      LR.lab_abn_WBC_bool,	LR.lab_abn_HMG_bool,	LR.lab_abn_PLT_bool,	LR.lab_abn_NTR_bool,
--      MH.PRED_med,	MH.METH_med,	MH.DEXA_med,	MH.RIT_med,	MH.HOR_med
FROM `Heme_stamp.Heme_stamp_data` as HMST
Left JOIN
`Heme_stamp.demog` as demog USING (ANON_ID)
Left JOIN
    `Heme_stamp.DX_hist_v2` as DX USING (ANON_ID)
Left JOIN
    `Heme_stamp.Family_hist_v2` as FM USING (ANON_ID)
Left JOIN
    `Heme_stamp.med_hist_v2` as MH USING (ANON_ID)
Left JOIN
    `Heme_stamp.LAB_RES_v4` as LR USING (ANON_ID)
)
