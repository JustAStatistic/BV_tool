DROP PROC [bvt_staging].[UCLM_ParentID_FlightRecord_Link_PR]

GO

USE [UVAQ_STAGING]
GO

/****** Object:  StoredProcedure [bvt_staging].[UCLM_ParentID_FlightRecord_Link_PR]    Script Date: 10/02/2015 11:40:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*removed gigapower to put in seperate program. KL 10/2/15

*/

CREATE PROC [bvt_staging].[UCLM_ParentID_FlightRecord_Link_PR]

AS
BEGIN
	SET NOCOUNT ON;


IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_Clean') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_Clean

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_other') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_other

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_NoMatch') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_NoMatch

IF Object_ID('bvt_staging.UCLM_pID_FlightPlan_Dups') IS NOT NULL
TRUNCATE TABLE bvt_staging.UCLM_pID_FlightPlan_Dups


INSERT INTO bvt_staging.UCLM_ActiveCampaigns
SELECT DISTINCT a.ParentID, a.Campaign_Name, a.start_date as [In_Home_Date], a.Media_Code,  a.eCRW_Project_Name, GETDATE()

	FROM JAVDB.IREPORT.dbo.IR_Campaign_Data_Latest_MAIN_2012 AS a JOIN JAVDB.IREPORT_2015.dbo.WB_00_Reporting_Hierarchy AS b
      ON a.tactic_id=b.id
    LEFT JOIN JAVDB.IREPORT_2015.dbo.WB_01_Campaign_List d
	ON a.ParentID = d.ParentID
     WHERE b.Scorecard_Top_Tab = 'Direct Marketing'
AND  b.Scorecard_LOB_Tab = 'U-verse'
AND  b.Scorecard_tab = 'U-verse CLM'


AND (a.[Start_Date]<= '27-DEC-2016' AND a.End_Date_Traditional>='28-DEC-2014') 
	AND a.Media_Code <> 'DR'
	AND a.ParentID > 1334
	AND a.parentID  NOT IN (SELECT parentID from bvt_staging.UCLM_ActiveCampaigns)
	AND a.campaign_name NOT LIKE '%Commitment View%'
	AND a.campaign_name NOT LIKE '%Remaining data%'
	AND a.campaign_name NOT LIKE '%best View Objectives%'
	AND a.Start_Date >= '10/1/14'
	AND ((a.Media_COde IN ('DM','EM','FPC') AND a.eCRW_Project_Name NOT LIKE '%Giga%')
		OR a.Media_Code in ('BI','FYI','Device/Tablet'))



Select ParentID,
CASE 

--Bill Media -- Bill Inserts
/*still missing 206,207,209,210,217,226,239,567,573,630,631*/

WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HBO%' THEN 208 -- HBO BI 
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HD%' AND Campaign_Name NOT LIKE '%Premium%' THEN 211 -- HD BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HD%' AND Campaign_Name LIKE '%Premium%' THEN 213 --HD Premium Upgrade BI
WHEN Media_Code = 'BI' AND (Campaign_Name LIKE '%HSIA%Sell%' OR Campaign_Name LIKE '%NON-HSIA%') THEN 214 -- HSIA XSell BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HSIA%Upgrade%' THEN 215 --HSIA Upgrade BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%HSN%' THEN 216 -- HSN BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%McAfee%' THEN 218 -- McAfee BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Movers%' AND Campaign_Name LIKE '%300%' THEN 219 -- Movers $300 BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Movers%' AND Campaign_Name LIKE '%wireless receiver%' THEN 220 -- Movers Wireless Recvr BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%myAT&T%' THEN 221 -- MyAT&T BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%On%Demand%' AND Campaign_Name LIKE '%Reccom%' THEN 222 -- OnDemand Recos BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Parent%Control%' THEN 223 -- Parental Controls BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%R4R%' THEN 224 --R$R BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Screen Pack%' THEN 225 -- Screen Pack BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' AND Campaign_Name LIKE '%U200%' THEN 227 -- IPTV Upgrade BI U200
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' AND Campaign_Name LIKE '%U300%' THEN 228 -- IPTV Upgrade BI U300
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' AND Campaign_Name LIKE '%U450%' THEN 229 -- IPTV Upgrade BI U450
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Uguide%' THEN 231 -- U-guide BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Welcome%' THEN 238 --Welcome BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Digital%Life%' THEN 547 --Digital Life BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%Hallmark%' THEN 556 --Hallkmark BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%NBA%' THEN 579 --NBA League Pass BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' AND Campaign_Name LIKE '%3 Months%' THEN 590 -- IPTV Upgrade 3 Months Free BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' AND Campaign_Name LIKE '%Reward Card%' THEN 591 -- IPTV Upgrade Reward Card BI
WHEN Media_Code = 'BI' AND Campaign_Name LIKE '%TV Upgrade%' THEN 586 --TV Upgrade BI


--First Page Communicators
/*still missing 241,245,352,354,357,558,566*/

--WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Gigapower%' THEN 247 --Gigapower FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HBO%' THEN 250 --HBO FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HD%' THEN 252 --HD FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%HSIA%' THEN 331 --HSIA FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Movers%' THEN 337 --Movers FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%Voice%' THEN 409 -- Voice FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE 'Epix%' THEN 549 --EPiX FPC
WHEN Media_Code = 'FPC' AND eCRW_Project_Name LIKE '%OnDemand%' THEN 554 --Free On Demand FPC


--FYI
/*Still missing 240,246,254,333,342,343,344,347,348,349,350,353,358,360*/

WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Epix%' THEN 243 --Epix FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%HBO%' THEN 249 --HBO Upgrade FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name NOT LIKE '% OE%' AND (eCRW_Project_Name LIKE '%Non-HSIA%' OR eCRW_Project_Name LIKE '%HSIA%Cross%Sell%') THEN 255 --HSIA Xsell FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name NOT LIKE '% OE%' AND eCRW_Project_Name LIKE '%HSIA%' AND eCRW_Project_Name NOT LIKE '%Non-HSIA%' AND eCRW_Project_Name NOT LIKE '%Cross%Sell%' THEN 330 --HSIA Upgrade FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%International%' THEN 332 --International FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Karaoke%' THEN 334 --Karaoke FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Live%TV%' THEN 335 --Live TV FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Movers%' THEN 338 --Movers NYCU FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%MyAt&T%' THEN 341 --MyAT&T FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Screen%Pack%' THEN 345 --Screen Pack FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Tumblebooks%' THEN 351 --Tumblebooks FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%U-Verse Games%' THEN 356 --U-verse Games FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Hot%spot%' THEN 359 --Wifi Hotspots FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Disney Family%' THEN 548 --Disney Family Movies FYI
WHEN Media_Code = 'FYI' AND eCRW_Project_Name NOT LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Home Wiring%' THEN 561 --Home Wiring Protection FYI


--Outer Envelope
When Media_Code = 'FYI' AND eCRW_Project_Name LIKE '% OE%' and eCRW_Project_Name LIKE '%HSIA%' THEN 563 --HSIA Messaging OE


--Onserts
/*still missing 546,555,568,570,576,577,585*/

WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Epix%' THEN 242 --Epix Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Football%' THEN 244 --Football Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%HD%' THEN 251 --HD Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%McAfee%' THEN 336 --McAfee Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Movers%' THEN 339 --Movers Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Screen%Pack%' THEN 346 --Screen Pack Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Free%Demand%' THEN 553 --Free On Demand Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%HBO%' THEN 559 --HBO Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND (eCRW_Project_Name LIKE '%HSIA%Sell%' OR eCRW_Project_Name LIKE '%NON-HSIA%') THEN 562 --HSIA Xsell Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%HSIA%Upgrade%' THEN 564 --HSIA Upgrade Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Karaoke%' THEN 569 --Karaoke Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%Live%TV%' THEN 570 --Live TV Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%MyAt&T%' THEN 575 --MyAT&T Onsert
WHEN Media_Code = 'FYI' AND eCRW_Project_Name LIKE '%Onsert%' AND eCRW_Project_Name LIKE '%TV%Upgrade%' THEN 587 --IPTV Upgrade Onsert


--Direct Mail
/*still missing 363,364,366,378,380,413*/

WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Benefit%' AND eCRW_Project_Name NOT LIKE '%Hispanic%'THEN 362 --Benefits Self Mailer DM 
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%EOY Letter%' THEN 365 --EOY Letter Letter Kit DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO_Upgrade%' AND (Campaign_Name LIKE '%GC%' OR Campaign_Name LIKE '%Greeting Card%') THEN 369 --HBO Greeting Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO_Upgrage%' AND (Campaign_Name LIKE '%SP%' OR Campaign_Name LIKE '%Poster%') THEN 370 -- HBO SP DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HBO_Upgrade%' AND (Campaign_Name LIKE '%PC%' OR Campaign_Name LIKE '%Postcard%' OR Campaign_Name LIKE '%Post Card%') THEN 371 --HBO Post Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%HSIA_Upgrade%' AND Campaign_Name NOT LIKE '%Non-HSIA%' AND Campaign_Name NOT LIKE '%Cross%Sell%' THEN 372 --HSIA Letter Kit DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Movers%' THEN 374 --Movers Post Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%MovieTime%' THEN 375 --MovieTime Self Mailer DM
WHEN Media_Code = 'DM' AND (eCRW_Project_Name LIKE '%HSIA_Upgrade%' OR eCRW_Project_Name LIKE '%HSIA_STAR%') AND (Campaign_Name LIKE '%Non-HSIA%' OR Campaign_Name LIKE '%Cross%Sell%' OR Campaign_Name LIKE '%x-sell%') THEN 376 --HSIA Upsell Letter Kit DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Programming%' THEN 377 --Programming Self Mailer DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Reaffirm_Stream%' THEN 379 --Reaffirm Stream Letter Kit DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%TVUpgrade%' AND (Campaign_Name LIKE '%SM%' OR Campaign_Name LIKE '%SelfMailer%' OR Campaign_Name LIKE '%Self Mailer%' OR [In_Home_Date] = '11-12-14') THEN 381 --IPTV Self Mailer DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%TVUpgrade%' AND (Campaign_Name LIKE '%PC%' OR Campaign_Name LIKE '%Postcard%' OR Campaign_Name LIKE '%Post Card%') THEN 382 --IPTV Post Card DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Welcome%' THEN 410 --2 Month Welcome CSM DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Big_Data%' THEN 411 --Big Data Letter Kid DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Benefit%' and eCRW_Project_Name LIKE '%Hispanic%' THEN 412 --Hispanic Benefits Self Mailer DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Seniors%' THEN 414 --Seniors Self Mailer DM
WHEN Media_Code = 'DM' AND eCRW_Project_Name LIKE '%Appreciation%' THEN 571 --Member Appreciation DM


--EMail
/*still missing 385,415,552,557,560,601*/

WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Benefit%' AND eCRW_Project_Name NOT LIKE '%HSIA%' THEN 383 --Benefits EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Engagement_Stream%' AND eCRW_Project_Name NOT LIKE '%Weekly%' THEN 384 --Engagement Stream EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Groundhog%' THEN 388 --Groundhof's Day EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' AND (Campaign_Name LIKE '%Follow%Up%' OR Campaign_Name LIKE '%FU%') THEN 390 --HBO Follow Up EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' AND Campaign_Name LIKE '%Initial%' THEN 391 --HBO Initial EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HBO%' THEN 389 -- HBO EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Benefit%' AND eCRW_Project_Name LIKE '%HSIA%' AND eCRW_Project_Name NOT LIKE '%HSIA%Only%' THEN 392 --HSIA Beneits EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HSIA%Only%' AND eCRW_Project_Name LIKE '%Welcome%' THEN 393 --HSIA Only Welcome EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HSIA_Upgrade%' AND Campaign_Name NOT LIKE '%Non-HSIA%' AND Campaign_Name NOT LIKE '%Cross%Sell%' THEN 394 --HSIA Upgrade/Cross Sell EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%MDU_Movers%' THEN 395 --MDU Movers EM 
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Movers%' THEN 397 -- Movers EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Movie%Time%' THEN 398 --Movie Time EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HSIA_Upgrade%' AND (Campaign_Name LIKE '%Non-HSIA%' OR Campaign_Name LIKE '%Cross%Sell%') THEN 399 --Non-HSIA EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Quiz%' THEN 400 --Quiz with Rewards EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Reaffirm_Stream%' THEN 401 --Reaffirm Stream EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Spotlight%' THEN 402 --Spotlight EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV_Upgrade%' THEN 403 --IPTV Upgrade EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Weekly%' AND eCRW_Project_Name LIKE '%Movies%' THEN 404 --Movies weekly EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Welcome%' THEN 405 --Membership Welcome EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%HSIA%Only%' AND eCRW_Project_Name LIKE '%Benefit%' THEN 415 --HSIA Only EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%UGUIDE%' THEN 416 --U-guide EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Amazon%' THEN 545 --Amazon Offer EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Appreciation%' THEN 572 --Member Appreciation EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Non%Marketing%' THEN 580 --Non Marketing EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%PPV%' THEN 582 --PPV EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Skin%' AND eCRW_Project_Name NOT LIKE '%Follow%' AND eCRW_Project_Name NOT LIKE '%Reminder%' THEN 583 --Skin It EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Skin%' AND (eCRW_Project_Name LIKE '%Follow%' OR eCRW_Project_Name LIKE '%Reminder%') THEN 584 --Skin It Follow Up EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV_Upgrade%' AND Campaign_Name  LIKE '%Initial%' THEN 588 --IPTV Upgrade Initial EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%TV_Upgrade%' AND Campaign_Name LIKE '%Follow%Up%' THEN 589 --IPTV Upgrade Follow Up EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%VOICE%' THEN 595 --Voice Cross Sell EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Epix_12%' THEN 599 --Free Epix Upgrade Announcement EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Epix_Reminder%' THEN 600 --Free Epix Upgrade Reminder EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Movie%Time%3%' THEN 602 --Movie Time 3 EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%Engagement%Weekly%' THEN 695 -- Engagement Stream Weekly EM
WHEN Media_Code = 'EM' AND eCRW_Project_Name LIKE '%NFL%' THEN 696 --NFL Sunday Ticket EM


--Device/App
WHEN Media_Code = 'Device/Tablet' AND eCRW_Project_Name LIKE '%UGuide%' THEN 592 --UGuide App


ELSE 0 END AS idProgram_Touch_Definitions,

'' AS idFlight_Plan_Records

INTO #ParentID_ID_Link

FROM bvt_staging.UCLM_ActiveCampaigns

	
SELECT a.[ParentID], a.idProgram_Touch_Definitions, c.idFlight_Plan_Records
INTO #ParentID_ID_Link2

FROM #ParentID_ID_Link a
JOIN bvt_staging.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
LEFT JOIN (SELECT Distinct 
       [idFlight_Plan_Records]
      ,idProgram_Touch_Definitions_TBL_FK 
      ,[InHome_Date]
		FROM UVAQ.bvt_prod.UCLM_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' --And Forecast <> 0
		) c
ON (a.idprogram_Touch_Definitions = c.idProgram_Touch_Definitions_TBL_FK  AND
(c.InHome_Date BETWEEN Dateadd(D, -5,b.In_Home_Date) AND  Dateadd(D, 5, b.In_Home_Date)))
ORDER BY a.idProgram_Touch_Definitions



--for QC purposes adds information about touch type and campaign instead of only having ID numbers and puts it into the different category tables.

--Clean = flight plan has exact in home date match.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Clean
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN bvt_staging.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.UCLM_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'--And Forecast <> 0
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date = d.InHome_Date
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--Flight plan has record within +/- 5 days of eCRW in home date but does not match exactly.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Other
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN bvt_staging.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.UCLM_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume'-- And Forecast <> 0
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where b.In_Home_Date <> d.InHome_Date and d.InHome_Date is not null
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions


--eCRW information does not have matching flight plan within +/- 5 days.
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_NoMatch
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], Coalesce(d.Touch_Name, e.Touch_Name) as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], Coalesce(d.Media, e.Media) as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN bvt_staging.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.UCLM_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' --And Forecast <> 0
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
JOIN (select a.idProgram_Touch_Definitions_TBL, a.Touch_Name, b.Media from UVAQ.bvt_prod.Program_Touch_Definitions_TBL a
		JOIN  UVAQ.bvt_prod.Media_LU_TBL b
		ON a.idMedia_LU_TBL_FK = b.idMedia_LU_TBL) e
on a.idProgram_Touch_Definitions = e.idProgram_Touch_Definitions_TBL
Where d.InHome_Date is null
AND b.AssignDate =Convert(date, getdate())
AND a.ParentID not in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
ORDER BY a.idProgram_Touch_Definitions



--There are multiple matches within +/- days. Should not occur going forward often. 
INSERT INTO bvt_staging.UCLM_pID_FlightPlan_Dups
SELECT Distinct a.ParentID, a.idProgram_Touch_Definitions, a.idFlight_Plan_Records, b.Media_Code, b.eCRW_Project_Name, b.Campaign_Name, b.In_Home_Date, 
 d.Campaign_Name as [FlightCampaignName], d.InHome_Date as [FlightInHomeDate], d.Touch_Name as [FlightTouchName], d.Program_Name as [FlightProgramName], d.Tactic as [FlightTactic], d.Media as [FlightMedia]
 , d.Campaign_Type as [FlightCampaignType], d.Audience as [FlightAudience], d.Creative_Name as [FlightCreativeName], d.Offer as [FlightOffer]
FROM #ParentID_ID_Link2 a
JOIN bvt_staging.UCLM_ActiveCampaigns b ON a.parentID = b.ParentID
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
		FROM UVAQ.bvt_prod.UCLM_Best_View_Forecast_VW_FOR_LINK
		where KPI_Type = 'Volume' --And Forecast <> 0
		) d
ON a.idFlight_Plan_Records = d.idFlight_Plan_Records
Where a.ParentID in (Select ParentID from #ParentID_ID_Link2 group by parentid having COUNT(ParentID) >1)
AND b.AssignDate =Convert(date, getdate())
ORDER BY a.idProgram_Touch_Definitions

END






GO


