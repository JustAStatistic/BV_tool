DROP VIEW [bvt_Prod].[UCLM_Drag_Sales_Forecast_VW]

GO




CREATE VIEW [bvt_Prod].[UCLM_Drag_Sales_Forecast_VW]

AS

SELECT Calendar.[Date],
	 MediaMonth AS Media_Month,
	 MediaMonth_year AS media_year, 
	 iso_week AS Media_week, 
	 Drag_calls*Conversion_Rate AS Drag_Sales,
	 p.Product_Code
FROM dim.media_calendar_daily AS calendar

JOIN [bvt_prod].[UCLM_Drag_Forecast_VW] AS DragCalls
	ON calendar.Date = dragcalls.Date

JOIN [bvt_prod].[Drag_Conversion_Start_End_VW] DragRates
	ON Calendar.Date between DragRates.conv_rate_start_Date and dragRates.End_Date
	and DragRates.idProgram_Touch_Definitions_TBL_FK = 800

JOIN bvt_prod.Product_LU_TBL p
	ON p.idProduct_LU_TBL = DragRates.idProduct_LU_TBL_FK


