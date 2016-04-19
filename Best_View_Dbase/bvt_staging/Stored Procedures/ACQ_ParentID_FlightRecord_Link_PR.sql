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

SELECT DISTINCT d.ParentID, b.scorecard_program_Channel, a.eCRW_Project_Name, a.Campaign_Name, a.Start_Date, a.Media_Code, a.Vendor
, a.eCRW_Classification_Name, a.Cell_DTV_flag, CAST(GETDATE() as Date) as AssignDate
	FROM JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List a
	JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy AS b
      ON a.tactic_id=b.id
    JOIN JAVDB.IREPORT.dbo.IR_Camp_Data_Latest_MAIN_2012 d
    on RIGHT(d.ParentID,6) = a.ParentID
WHERE b.Scorecard_Top_Tab = 'Direct Marketing'
AND (b.scorecard_program_channel like '%U-verse Prospect%' OR b.scorecard_program_Channel like '%Value Prospect%')
AND b.scorecard_program_channel not like '%mobility%'
AND a.eCRW_Project_Name NOT LIKE '%GIGA%' AND a.eCRW_Project_Name NOT LIKE '%GP%'
AND a.End_Date_Traditional>='28-DEC-2015'
AND a.Media_Code <> 'DR'
AND a.campaign_name NOT LIKE '%Commitment View%'
AND a.campaign_name NOT LIKE '%Remaining data%'
AND a.campaign_name NOT LIKE '%best View Objectives%'
and a.Media_Code = 'dm'
AND d.ParentID not in (Select ParentID from UVAQ.bvt_processed.ACQ_ActiveCampaigns)
Order by scorecard_program_Channel, eCRW_Classification_Name, Cell_DTV_Flag




Select ParentID,
CASE 
--HSIA Opp DM
-- Still missing: 1251,1252,1002,1246,1003,1001
--This will need more work once we see more of the Aspen UPRO naming structure.
WHEN Scorecard_program_Channel = 'U-verse Prospect - DM' THEN 1000 --UPRO Touch 1 Regular DM 

--IPDSL Opp DM
--Still Missing: 1256,1253,1254,1255,1247,1249
WHEN Scorecard_program_Channel = 'Value Prospect - Combo Pool IPDSL' and eCRW_Classification_Name = 'Combo Pool IPDSL' AND Cell_DTV_Flag = 'DTV' AND (eCRW_Project_Name LIKE '%Pure%Prospect%' OR eCRW_Project_Name LIKE '%OV%' OR eCRW_Project_Name LIKE '%MASA%') AND eCRW_Project_Name NOT LIKE '%DTV Only%' AND eCRW_Project_Name NOT LIKE '%Mobility%' THEN 1005 -- VPRO Pure Pospect DTV Opp DM
WHEN Scorecard_program_Channel = 'Value Prospect - Combo Pool IPDSL' and eCRW_Classification_Name = 'Combo Pool IPDSL' AND Cell_DTV_Flag = 'Non-DTV' AND (eCRW_Project_Name LIKE '%Pure%Prospect%' OR eCRW_Project_Name LIKE '%OV%' OR eCRW_Project_Name LIKE '%MASA%') AND eCRW_Project_Name NOT LIKE '%DTV Only%' AND eCRW_Project_Name NOT LIKE '%Mobility%' THEN 1006 -- VPRO Pure Pospect No DTV Opp DM
WHEN Scorecard_program_Channel = 'Value Prospect - Hispanic IPDSL' and eCRW_Classification_Name = 'Multicultuural IPDSL' AND Cell_DTV_Flag = 'DTV' AND (eCRW_Project_Name LIKE '%Pure%Prospect%' OR eCRW_Project_Name LIKE '%OV%' OR eCRW_Project_Name LIKE '%MASA%') AND eCRW_Project_Name NOT LIKE '%DTV Only%' AND eCRW_Project_Name NOT LIKE '%Mobility%' THEN 1007 -- VPRO Hispanic Pospect DTV Opp DM
WHEN Scorecard_program_Channel = 'Value Prospect - Hispanic IPDSL' and eCRW_Classification_Name = 'Multicultural IPDSL' AND Cell_DTV_Flag = 'Non-DTV' AND (eCRW_Project_Name LIKE '%Pure%Prospect%' OR eCRW_Project_Name LIKE '%OV%' OR eCRW_Project_Name LIKE '%MASA%') AND eCRW_Project_Name NOT LIKE '%DTV Only%' AND eCRW_Project_Name NOT LIKE '%Mobility%' THEN 1008 -- VPRO Hispanic Pospect No DTV Opp DM

WHEN Scorecard_program_Channel = 'Value Prospect - Hispanic IPDSL' OR scorecard_program_Channel =  'Value Prospect - Hispanic Legacy' THEN 1256 --VPRO Hispanic Prospect Actuals
WHEN scorecard_program_Channel = 'Value Prospect - Combo Pool IPDSL' OR scorecard_program_Channel =  'Value Prospect - Combo Pool Legacy' THEN 1255 --VPRO Pure Prospect Actuals

ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM UVAQ.bvt_processed.ACQ_ActiveCampaigns

/* Will need to change the flight plan records in the case statement when we get to a new year*/	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, 
CASE WHEN a.idProgram_Touch_Definitions = 1256 THEN 24304 WHEN a.idProgram_Touch_Definitions = 1255 THEN 24307 ELSE c.idFlight_Plan_Records END AS idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN UVAQ.bvt_processed.ACQ_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.ACQ_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' And Forecast <> 0) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.[Start_Date]) AND  Dateadd(D, 5, b.[Start_Date])))
ORDER BY a.idProgram_Touch_Definitions




--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.

INSERT INTO bvt_staging.ACQ_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer], b.scorecard_program_Channel, b.eCRW_Classification_Name, b.Cell_DTV_flag

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
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer], b.scorecard_program_Channel, b.eCRW_Classification_Name, b.Cell_DTV_flag
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
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer], b.scorecard_program_Channel, b.eCRW_Classification_Name, b.Cell_DTV_flag

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
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.Start_Date, b.Vendor,
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer], b.scorecard_program_Channel, b.eCRW_Classification_Name, b.Cell_DTV_flag
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






