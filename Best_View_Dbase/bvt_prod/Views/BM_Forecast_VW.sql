﻿DROP VIEW [bvt_prod].[BM_Forecast_VW]
GO


CREATE VIEW [bvt_prod].[BM_Forecast_VW]
as
select FPR.idFlight_Plan_Records
	, FPR.Campaign_Name
	, FPR.InHome_Date
	
---Media_Calendar_Info
	, Media_Calendar_Daily.ISO_Week_Year as Media_Year
	, Media_Calendar_Daily.ISO_Week as Media_Week
	, Media_Calendar_Daily.MediaMonth as Media_Month
	, Media_Calendar_Daily.ISO_Week_YYYYWW as Media_YYYYWW
	, YEAR(metrics.Forecast_DayDate) as Calendar_Year
	, MONTH(metrics.Forecast_DayDate) as Calendar_Month

	
---Touch Lookup Tables
	, idProgram_Touch_Definitions_TBL_FK
	, Touch_Name
	, Program_Name
	, Tactic
	, Media
	, Campaign_Type
	, Audience
	, Creative_Name
	, Goal
	, Offer
	, Channel
	, owner_type_matrix_id_FK

----Metrics
	, KPI_Type
	, Product_Code
	, Forecast_DayDate
	, Forecast


from bvt_prod.BM_Flight_Plan_VW as FPR

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
from bvt_prod.BM_FlightplanSalesForecast
 left join bvt_prod.Product_LU_TBL
		on BM_FlightplanSalesForecast.idProduct_LU_TBL_FK=Product_LU_TBL.idProduct_LU_TBL)

union 

(select idFlight_Plan_Records
	, 'Response' as KPI_Type
	, KPI_Type as Product_Code
	, Forecast_DayDate
	, KPI_Forecast as Forecast
from bvt_prod.BM_FlightplanKPIForecast
 left join bvt_prod.KPI_Types
		on BM_FlightplanKPIForecast.idkpi_types_FK=KPI_Types.idKPI_Types)
		
union

(select idFlight_Plan_Records
	, 'Volume' as KPI_Type
	, 'Volume' as Product_Code
	, dropdate as Forecast_DayDate
	, Volume as Forecast
from bvt_prod.BM_Flightplan_Volume_Forecast_VW)) as metricsa) as metrics
	on fpr.idFlight_Plan_Records=metrics.idFlight_Plan_Records
-----------------------------------------------------------------	
--Media Calendar Information-------------------------------------
left join Dim.Media_Calendar_Daily
		on metrics.Forecast_DayDate=Media_Calendar_Daily.Date
-----------------------------------------------------------------

left join
-----Bring in touch definition labels 
bvt_prod.Touch_Definition_VW as touchdef
		on FPR.idProgram_Touch_Definitions_TBL_FK=idProgram_Touch_Definitions_TBL

	


