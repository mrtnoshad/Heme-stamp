
--CREATE OR REPLACE TABLE Heme_stamp.feature_mat AS
(
SELECT demog.*, DX.* EXCEPT (ANON_ID, label), LR.* EXCEPT (ANON_ID, label), MH.* EXCEPT (ANON_ID, label)

--SELECT demog.*,  DX.autoimmune_hist,	DX.leukemia_hist,	DX.blood_dis_hist,
--      LR.lab_abn_WBC_bool,	LR.lab_abn_HMG_bool,	LR.lab_abn_PLT_bool,	LR.lab_abn_NTR_bool,
--      MH.PRED_med,	MH.METH_med,	MH.DEXA_med,	MH.RIT_med,	MH.HOR_med
FROM `Heme_stamp.demog` as demog
LEFT JOIN
    `Heme_stamp.DX_history` as DX USING (ANON_ID)
LEFT JOIN
    `Heme_stamp.LAB_RES` as LR USING (ANON_ID)
LEFT JOIN
    `Heme_stamp.med_hist` as MH USING (ANON_ID)
)
