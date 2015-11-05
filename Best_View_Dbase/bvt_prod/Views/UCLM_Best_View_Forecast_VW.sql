USE [UVAQ]
GO

/****** Object:  View [bvt_prod].[UCLM_Best_View_Forecast_VW]    Script Date: 10/14/2015 14:48:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [bvt_prod].[UCLM_Best_View_Forecast_VW]
as
select FPR.idFlight_Plan_Records
	, FPR.Campaign_Name
	, FPR.InHome_Date
	
---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year as Media_Year
	, Media_Calendar_Daily.ISO_Week as Media_Week
	, Media_Calendar_Daily.MediaMonth as Media_Month
	
---Touch Lookup Tables
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer

----Metrics
	, KPI_Type
	, Product_Code
	, Forecast_DayDate
	, Forecast

from bvt_processed.UCLM_Flight_Plan as FPR

left join
-------------Bring in the Metrics----------------------------------------------------------------------
(select * from 


((select idFlight_Plan_Records
	, case when idkpi_types_FK=1 then 'Telesales'
		when idkpi_types_FK=2 then 'Online_sales'
		else 'CHECK' end as KPI_Type 
	, Product_Code
	, Forecast_DayDate
	, Sales_Forecast as Forecast
from bvt_prod.UCLM_FlightplanSalesForecast
 left join bvt_prod.Product_LU_TBL
		on UCLM_FlightplanSalesForecast.idProduct_LU_TBL_FK=Product_LU_TBL.idProduct_LU_TBL
  where idkpi_types_FK<>3)

union all

(select idFlight_Plan_Records
	, 'Response' as KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast
from bvt_prod.UCLM_FlightplanKPIForecast
 left join bvt_prod.KPI_Types
		on UCLM_FlightplanKPIForecast.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union all

(select idFlight_Plan_Records
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, inhome_date as Forecast_DayDate
	, Volume as Forecast
from bvt_prod.UCLM_Flightplan_Volume_Forecast_VW)

union all

(select idFlight_Plan_Records
	, 'Response' as KPI_Type
	, 'Call' as Product_Code
	, Date as Forecast_DayDate
	, Drag_Calls as Forecast
from bvt_prod.UCLM_Drag_Forecast_VW 
JOIN (Select idFlight_Plan_Records, Case when DATEPART(d,InHome_Date) = 1 and DATEPART(M,InHome_Date) = 1 then DATEPART(YYYY, Inhome_Date)
	Else DATEPART(YYYY, Inhome_date)+1 END as MediaYear
	from bvt_processed.UCLM_Flight_Plan a
	where idProgram_Touch_Definitions_TBL_FK = 800) medyear
on UCLM_Drag_Forecast_VW.Media_Year = medyear.MediaYear)

union all

(select idFlight_Plan_Records
	, 'Telesales' as KPI_Type
	, Product_Code
	, Date as Forecast_DayDate
	, Drag_Sales as Forecast
from bvt_prod.UCLM_Drag_Sales_Forecast_VW 
JOIN (Select idFlight_Plan_Records, Case when DATEPART(d,InHome_Date) = 1 and DATEPART(M,InHome_Date) = 1 then DATEPART(YYYY, Inhome_Date)
	Else DATEPART(YYYY, Inhome_date)+1 END as MediaYear
	from bvt_processed.UCLM_Flight_Plan a
	where idProgram_Touch_Definitions_TBL_FK = 800) medyear
on UCLM_Drag_Sales_Forecast_VW.Media_Year = medyear.MediaYear)

) as metricsa) as metrics
	on fpr.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_DayDate=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
(select idProgram_Touch_Definitions_TBL, Touch_Name, Program_Name, Tactic, Media, Audience, Creative_Name, Goal, Offer, Campaign_Type
		 from bvt_prod.Program_Touch_Definitions_TBL
			left join bvt_prod.Audience_LU_TBL on idAudience_LU_TBL_FK=idAudience_LU_TBL
			left join bvt_prod.Campaign_Type_LU_TBL on idCampaign_Type_LU_TBL_FK=idCampaign_Type_LU_TBL
			left join bvt_prod.Creative_LU_TBL on idCreative_LU_TBL_fk=idCreative_LU_TBL
			left join bvt_prod.Goal_LU_TBL on idGoal_LU_TBL_fk=idGoal_LU_TBL
			left join bvt_prod.Media_LU_TBL on idMedia_LU_TBL_fk=idMedia_LU_TBL
			left join bvt_prod.Offer_LU_TBL on idOffer_LU_TBL_fk=idOffer_LU_TBL
			left join bvt_prod.Program_LU_TBL on idProgram_LU_TBL_fk=idProgram_LU_TBL
			left join bvt_prod.Tactic_LU_TBL on idTactic_LU_TBL_fk=idTactic_LU_TBL) as touchdef
		on FPR.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

where Tactic <> 'Cost'	



GO


