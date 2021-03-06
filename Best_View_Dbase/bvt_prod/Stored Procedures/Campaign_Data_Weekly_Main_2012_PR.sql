USE [UVAQ]
GO
/****** Object:  StoredProcedure [bvt_prod].[Campaign_Data_Weekly_Main_2012_PR]    Script Date: 01/25/2017 13:11:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [bvt_prod].[Campaign_Data_Weekly_Main_2012_PR]
	
AS
--------Get Main Table Data-----------
IF OBJECT_ID('tempdb.dbo.#firsttemp', 'U') IS NOT NULL
  DROP TABLE #firsttemp; 

Select a.Project_ID, a.Parentid, idFlight_Plan_Records_FK, a.[Report_Year], a.[Report_Week], a.CalendarMonth_YYYYMM, a.[Start_Date], a.[End_Date_Traditional], a.[eCRW_Project_Name], a.[Campaign_Name]
		, a.CalendarWeek_YYYYWW
		, a.[media_code], a.Program, a.[Toll_Free_Numbers], a.[URL_List], a.ExcludefromScorecard, a.[CTD_Quantity], a.[ITP_Quantity], a.[ITP_Quantity_Unapp], a.[CTD_Budget], a.[ITP_Budget]
		, a.[ITP_Dir_Calls], a.[ITP_Dir_Calls_BH], a.[ITP_Dir_Clicks], a.[ITP_Dir_Sales_TS_CING_N], a.[ITP_Dir_Sales_TS_CING_VOICE_N], a.[ITP_Dir_Sales_TS_CING_FAMILY_N]
		, a.[ITP_Dir_Sales_TS_CING_DATA_N]
		, a.[ITP_Dir_Sales_TS_DISH_N]
		, a.[ITP_Dir_Sales_TS_LD_N]
		, a.[ITP_Dir_Sales_TS_DSL_REG_N]
		, a.[ITP_Dir_Sales_TS_DSL_DRY_N]
		, a.[ITP_Dir_Sales_TS_DSL_IP_N]
		, isnull(a.[ITP_Dir_Sales_TS_UVRS_HSIA_N],0) as[ITP_Dir_Sales_TS_UVRS_HSIA_N]
		, a.[ITP_Dir_Sales_TS_UVRS_TV_N], a.[ITP_Dir_Sales_TS_UVRS_BOLT_N]
		, a.[ITP_Dir_Sales_TS_LOCAL_ACCL_N], a.[ITP_Dir_Sales_TS_UVRS_VOIP_N], a.[ITP_Dir_Sales_TS_CTECH_N], a.[ITP_Dir_Sales_TS_DLIFE_N], a.[ITP_Dir_sales_TS_CING_WHP_N], a.[ITP_Dir_Sales_TS_Migrations]
		, a.[ITP_Dir_Sales_ON_CING_N], a.[ITP_Dir_Sales_ON_CING_VOICE_N], a.[ITP_Dir_Sales_ON_CING_FAMILY_N], a.[ITP_Dir_Sales_ON_CING_DATA_N], a.[ITP_Dir_Sales_ON_DISH_N]
		, a.[ITP_Dir_Sales_ON_LD_N], a.[ITP_Dir_Sales_ON_DSL_REG_N], a.[ITP_Dir_Sales_ON_DSL_DRY_N], a.[ITP_Dir_Sales_ON_DSL_IP_N]
		, isnull(a.[ITP_Dir_Sales_ON_UVRS_HSIA_N],0) as[ITP_Dir_Sales_ON_UVRS_HSIA_N]
		, a.[ITP_Dir_Sales_ON_UVRS_TV_N], a.[ITP_Dir_Sales_ON_UVRS_BOLT_N], a.[ITP_Dir_Sales_ON_LOCAL_ACCL_N], a.[ITP_Dir_Sales_ON_UVRS_VOIP_N], a.[ITP_Dir_Sales_ON_DLIFE_N]
		, a.[ITP_Dir_Sales_ON_CING_WHP_N], a.[ITP_Dir_Sales_ON_Migrations], a.[ITP_Dir_Sales_TS_TOTAL], a.[ITP_Dir_Sales_TS_Strat], a.[ITP_Dir_Sales_ON_TOTAL], a.[ITP_Dir_Sales_ON_Strat]
		, a.[LTV_ITP_DIRECTED], a.[LTV_ITP_TOTAL], a.[LTV_ITP_TS_TOTAL], a.[LTV_ITP_ON_TOTAL]
into #firsttemp
from javdb.ireport.[dbo].[vw_IR_Campaign_Data_Weekly_MAIN_CAL] a
inner join 
		---subquery to get linkage from flightplan records to parent ids
		(SELECT Source_System_id , idFlight_Plan_Records_FK
		from [bvt_prod].Flight_Plan_Records as fltpln
			inner join [bvt_prod].[External_ID_linkage_TBL_has_Flight_Plan_Records] as junction
			on fltpln.idFlight_Plan_Records=junction.idFlight_Plan_Records_FK
			inner join [bvt_prod].[External_ID_linkage_TBL] as extrnl
			on junction.idExternal_ID_linkage_TBL_FK=extrnl.idExternal_ID_linkage_TBL
		where idSource_System_LU_FK=1
			and idSource_Field_Name_LU_FK=1
		group by Source_System_ID, idFlight_Plan_Records_FK) as linkage

		---linking fields
		on CAST(a.parentid as Varchar(20))=  linkage.Source_System_id;

---Get Workbook Data--------------
IF OBJECT_ID('tempdb.dbo.#secondtemp', 'U') IS NOT NULL
DROP TABLE #secondtemp; 

Select parentID, Report_week, Report_Year, CalendarWeek_YYYYWW, [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N] 
into #secondtemp
	from javdb.ireport_2015.dbo.IR_Workbook_Data_2017_Cal
				Where Report_Year = 2017
			UNION  Select parentID, Report_week, Report_Year, CalendarWeek_YYYYWW, [ITP_Dir_Sales_TS_UVRS_HSIA_N], [ITP_Dir_Sales_ON_UVRS_HSIA_N], [ITP_Dir_Sales_TS_UVRS_HSIAG_N], [ITP_Dir_Sales_ON_UVRS_HSIAG_N] 
			 from javdb.ireport_2015.dbo.IR_Workbook_Data_2016_Cal
				Where Report_Year = 2016;

--- Clear the old production data table
DROP TABLE from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset;
--	INSERT INTO from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset

select Distinct aa.Project_ID, aa.Parentid, idFlight_Plan_Records_FK, aa.[Report_Year], aa.[Report_Week], CAST(LEFT(CalendarMonth_YYYYMM,4) AS INT)  as Calendar_Year,
		CAST(RIGHT(CalendarMonth_YYYYMM,2) AS INT) as Calendar_Month, aa.[Start_Date], aa.[End_Date_Traditional], aa.[eCRW_Project_Name], aa.[Campaign_Name]
		, aa.[media_code], aa.Program, aa.[Toll_Free_Numbers], aa.[URL_List], aa.ExcludefromScorecard, cast(aa.[CTD_Quantity] as float) as CTD_Quantity, aa.[ITP_Quantity], aa.[ITP_Quantity_Unapp], aa.[CTD_Budget], aa.[ITP_Budget]
		, aa.[ITP_Dir_Calls], aa.[ITP_Dir_Calls_BH], aa.[ITP_Dir_Clicks], aa.[ITP_Dir_Sales_TS_CING_N], aa.[ITP_Dir_Sales_TS_CING_VOICE_N], aa.[ITP_Dir_Sales_TS_CING_FAMILY_N]
		, aa.[ITP_Dir_Sales_TS_CING_DATA_N], aa.[ITP_Dir_Sales_TS_DISH_N], aa.[ITP_Dir_Sales_TS_LD_N], aa.[ITP_Dir_Sales_TS_DSL_REG_N], aa.[ITP_Dir_Sales_TS_DSL_DRY_N]
		, aa.[ITP_Dir_Sales_TS_DSL_IP_N], Coalesce(b.[ITP_Dir_Sales_TS_UVRS_HSIA_N], aa.[ITP_Dir_Sales_TS_UVRS_HSIA_N],0) as[ITP_Dir_Sales_TS_UVRS_HSIA_N]
		, Coalesce(b.[ITP_Dir_Sales_TS_UVRS_HSIAG_N],0) as[ITP_Dir_Sales_TS_UVRS_HSIAG_N]
		, aa.[ITP_Dir_Sales_TS_UVRS_TV_N], aa.[ITP_Dir_Sales_TS_UVRS_BOLT_N]
		, aa.[ITP_Dir_Sales_TS_LOCAL_ACCL_N], aa.[ITP_Dir_Sales_TS_UVRS_VOIP_N], aa.[ITP_Dir_Sales_TS_CTECH_N], aa.[ITP_Dir_Sales_TS_DLIFE_N], aa.[ITP_Dir_sales_TS_CING_WHP_N], aa.[ITP_Dir_Sales_TS_Migrations]
		, aa.[ITP_Dir_Sales_ON_CING_N], aa.[ITP_Dir_Sales_ON_CING_VOICE_N], aa.[ITP_Dir_Sales_ON_CING_FAMILY_N], aa.[ITP_Dir_Sales_ON_CING_DATA_N], aa.[ITP_Dir_Sales_ON_DISH_N]
		, aa.[ITP_Dir_Sales_ON_LD_N], aa.[ITP_Dir_Sales_ON_DSL_REG_N], aa.[ITP_Dir_Sales_ON_DSL_DRY_N], aa.[ITP_Dir_Sales_ON_DSL_IP_N]
		, Coalesce(b.[ITP_Dir_Sales_ON_UVRS_HSIA_N], aa.[ITP_Dir_Sales_ON_UVRS_HSIA_N],0) as[ITP_Dir_Sales_ON_UVRS_HSIA_N]
		, Coalesce(b.[ITP_Dir_Sales_ON_UVRS_HSIAG_N],0) as[ITP_Dir_Sales_ON_UVRS_HSIAG_N]
		, aa.[ITP_Dir_Sales_ON_UVRS_TV_N], aa.[ITP_Dir_Sales_ON_UVRS_BOLT_N], aa.[ITP_Dir_Sales_ON_LOCAL_ACCL_N], aa.[ITP_Dir_Sales_ON_UVRS_VOIP_N], aa.[ITP_Dir_Sales_ON_DLIFE_N]
		, aa.[ITP_Dir_Sales_ON_CING_WHP_N], aa.[ITP_Dir_Sales_ON_Migrations], aa.[ITP_Dir_Sales_TS_TOTAL], aa.[ITP_Dir_Sales_TS_Strat], aa.[ITP_Dir_Sales_ON_TOTAL], aa.[ITP_Dir_Sales_ON_Strat]
		, aa.[LTV_ITP_DIRECTED], aa.[LTV_ITP_TOTAL], aa.[LTV_ITP_TS_TOTAL], aa.[LTV_ITP_ON_TOTAL]
INTO from_javdb.IR_Campaign_Data_Weekly_MAIN_2012_Sbset		

from #firsttemp as aa	
left join #secondtemp as b
	on aa.parentID = b.parentID and aa.Report_Year = b.Report_Year and aa.Report_Week = b.Report_Week
	and aa.CalendarWeek_YYYYWW = b.CalendarWeek_YYYYWW

RETURN 0

