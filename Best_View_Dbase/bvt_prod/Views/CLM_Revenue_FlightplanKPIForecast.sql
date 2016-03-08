﻿CREATE VIEW [bvt_prod].[CLM_Revenue_FlightplanKPIForecast]
as 
select 
	CLM_Revenue_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records
	, idkpi_types_FK
	, Forecast_DayDate
	, KPI_Daily*Volume as KPI_Forecast
from bvt_prod.CLM_Revenue_Flightplan_KPIRate_Daily_VW 
	inner join bvt_prod.CLM_Revenue_Flightplan_Volume_Forecast_VW
		on CLM_Revenue_Flightplan_KPIRate_Daily_VW.idFlight_Plan_Records=CLM_Revenue_Flightplan_Volume_Forecast_VW.idFlight_Plan_Records