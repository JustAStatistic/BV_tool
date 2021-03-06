USE [UVAQ_STAGING]
GO
/****** Object:  StoredProcedure [bvt_staging].[ACQ_ParentID_FlightRecord_Link_PR]    Script Date: 04/19/2016 09:31:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [bvt_staging].[ACQ_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;


IF Object_ID('bvt_staging.ACQ_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.ACQ_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.ACQ_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.ACQ_pID_FlightPlan_other

IF Object_ID('bvt_staging.ACQ_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.ACQ_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.ACQ_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.ACQ_pID_FlightPlan_Dups


INSERT INTO UVAQ.bvt_processed.ACQ_ActiveCampaigns

SELECT DISTINCT a.Project_ID, a.ParentID, a.eCRW_Cell_ID, a.CallStrat_ID, a.Start_Date, a.eCRW_Project_Name, a.Campaign_Name, a.Media_Code, a.URL_List,
 a.Toll_Free_Numbers, a.ExcludeFromScorecard, b.tfn_type_name, CAST(GETDATE() as Date) as AssignDate
	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_list_WB_2017 a
	LEFT JOIN javdb.PGSNAPSHOT.dbo.cells_view  b
		on a.eCRW_Cell_ID = b.ecrw_cell_id
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy_2017 AS c
      ON a.tactic_id=c.id
WHERE c.att_program_code ='INFA'
AND c.scorecard_lob_tab = 'Acquisition'
AND a.End_Date_Traditional>='12/28/15'
AND a.campaign_name NOT LIKE '%Commitment View%'
AND a.campaign_name NOT LIKE '%Remaining data%'
AND a.campaign_name NOT LIKE '%best View Objectives%'
and a.Media_Code = 'dm'
AND a.ParentID not in (Select ParentID from UVAQ.bvt_processed.ACQ_ActiveCampaigns)
Order by a.Start_Date, a.eCRW_Project_Name, a.ParentID


Select ParentID,
CASE 
WHEN eCRW_Project_Name LIKE '%GIGA%' THEN 1193 --Fiber Monthly Acquisition DM

WHEN Campaign_Name LIKE '%Non PQ%' THEN 1671 --ACQ GM DM DMDR
WHEN Campaign_Name LIKE '%PQ_frm%' THEN 1670 --ACQ Pre-Quals/Formers DM DMDR
WHEN Campaign_Name LIKE '%UVTV%' THEN 1679 --ACQ Non DTV Elig, UVTV Elig DMDR
WHEN Campaign_Name LIKE '%NonDTVElig%' THEN 1672 --ACQ Non DTV, IPBB Elig Only DMDR

WHEN Campaign_Name LIKE '%All Rem%' THEN 1671 --ACQ GM DM DMDR


ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.ACQ_ActiveCampaigns
where AssignDate = CAST(GETDATE() as Date)

/* Will need to change the flight plan records in the case statement when we get to a new year*/	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, 
CASE WHEN a.idProgram_Touch_Definitions = 1252 AND start_Date BETWEEN '12/28/15' AND '12/25/16' THEN 24303
	WHEN a.idProgram_Touch_Definitions = 1256 AND start_Date BETWEEN '12/28/15' AND '12/25/16' THEN 24304
	WHEN a.idProgram_Touch_Definitions = 1255 AND start_Date BETWEEN '12/28/15' AND '12/25/16'  THEN 24307 
 ELSE c.idFlight_Plan_Records END AS idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID 
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
      , URL_Ind
		FROM UVAQ.bvt_prod.ACQ_Flight_Plan_VW a
	JOIN UVAQ.bvt_prod.Flight_Plan_Records_Volume b
		on a.idFlight_Plan_Records = b.idFlight_Plan_Records_FK
		where Volume <> 0 AND Volume IS NOT NULL) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN (CASE WHEN a.idProgram_Touch_Definitions = 1670 THEN Dateadd(D, -5,b.[Start_Date])
WHEN a.idProgram_Touch_Definitions = 1671 THEN Dateadd(D, 2,b.[Start_Date]) 
WHEN a.idProgram_Touch_Definitions in (1679,1672) THEN dateadd(D, 9,b.[Start_Date]) END) AND
(CASE WHEN a.idProgram_Touch_Definitions = 1670 THEN dateadd(D, 5,b.[Start_Date])
WHEN a.idProgram_Touch_Definitions = 1671 THEN dateadd(D, 12,b.[Start_Date]) 
WHEN a.idProgram_Touch_Definitions in (1679,1672) THEN dateadd(D, 19,b.[Start_Date]) END)   )) 
ORDER BY a.idProgram_Touch_Definitions



--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.ACQ_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]

FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.ACQ_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.ACQ_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]

FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.ACQ_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.Start_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.

INSERT INTO bvt_staging.ACQ_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]

FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.ACQ_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate = Convert(date, getdate())
ORDER BY Start_Date, a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.ACQ_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]

FROM #ParentID_ID_Link2 a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT DISTINCT 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[Campaign_Name]
      ,[InHome_Date]
      ,[Touch_Name]
      ,[Program_Name]
      ,[Tactic]
      ,[Media]
      ,[Campaign_Type]
      ,[Audience]
      ,[Creative_Name]
      ,[Offer]
		FROM UVAQ.bvt_prod.ACQ_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate = Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


END






