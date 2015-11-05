DROP PROC [bvt_staging].[UVLB_ParentID_ExternalUpload_PR]

GO


CREATE PROC [bvt_staging].[UVLB_ParentID_ExternalUpload_PR]

AS
BEGIN
	SET NOCOUNT ON;


INSERT INTO  UVAQ.bvt_prod.External_ID_linkage_TBL
(Source_System_ID, idSource_System_LU_FK, idSource_Field_Name_LU_FK)
SELECT ParentID, 1, 1 
FROM bvt_staging.UVLB_pID_FlightPlan_Clean
UNION (SELECT ParentID, 1,1 FROM bvt_staging.UVLB_pID_FlightPlan_Other)
UNION (SELECT ParentID, 1,1 FROM bvt_staging.UVLB_pID_FlightPlan_Dups)
UNION (SELECT ParentID, 1,1 FROM bvt_staging.UVLB_pID_FlightPlan_NoMatch);



INSERT INTO UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records
(idExternal_ID_linkage_TBL_FK, idFlight_Plan_Records_FK)
SELECT idExternal_ID_linkage_TBL, id_Flight_Plan_Records
	FROM UVAQ.bvt_prod.External_ID_linkage_TBL
	INNER JOIN (SELECT ParentID, id_Flight_Plan_Records FROM bvt_staging.UVLB_pID_FlightPlan_Clean
		UNION (SELECT ParentID, id_Flight_Plan_Records FROM bvt_staging.UVLB_pID_FlightPlan_Other)
		UNION (SELECT ParentID, id_Flight_Plan_Records FROM bvt_staging.UVLB_pID_FlightPlan_Dups)
		UNION (SELECT ParentID, id_Flight_Plan_Records FROM bvt_staging.UVLB_pID_FlightPlan_NoMatch)) a
	ON source_system_id=a.ParentID
	WHERE idExternal_ID_linkage_TBL NOT IN (SELECT idExternal_ID_linkage_TBL_FK FROM UVAQ.bvt_prod.External_ID_linkage_TBL_has_Flight_Plan_Records)
	AND (id_Flight_Plan_Records>0 OR id_Flight_Plan_Records IS NOT NULL)


END




GO


