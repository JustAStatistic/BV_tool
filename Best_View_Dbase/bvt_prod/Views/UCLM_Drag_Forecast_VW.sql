DROP VIEW [bvt_prod].[UCLM_Drag_Forecast_VW]
GO

CREATE VIEW [bvt_prod].[UCLM_Drag_Forecast_VW]
	AS 
	--calculate daily calls based on method
	SELECT 
		--determine weekly average or percentage forecasting method and apply appropriate calculation
		[Date],
		MediaMonth as Media_Month,
		Media_Year,
		Media_Week,
		case when [idDrag_Method_LU_TBL_FK]=1 then [Metric]*[Day_Percent]/7 
			when [idDrag_Method_LU_TBL_FK]=2 then [Metric]*[FV_Calls]
			else 0
			end as Drag_Calls

		  FROM (SELECT [Date], MediaMonth, MediaMonth_year as media_year, iso_week as Media_week, [Day_Percent], FV_Calls 
					from dim.media_calendar_daily as calendar
				
				left join (select [Day_of_Week],[Day_Percent],[Daily_Start_Date],[END_DATE]  from [bvt_processed].[Response_Daily_Start_End]
							where [idProgram_Touch_Definitions_TBL_FK]=800 and [idkpi_type_FK]=1) as response_daily
				on datepart(weekday,calendar.date)=[Day_of_Week] and [date] between [Daily_Start_Date] and [END_DATE]
				
				left join (select [Forecast_DayDate], sum(forecast) as FV_Calls 
								from [bvt_processed].[UCLM_Best_View_Forecast] 
								where [Product_Code]='Call' and [load_dt]=(select max(load_dt) from [bvt_processed].[UCLM_Best_View_Forecast])
								and Touch_Name <> 'DRAG'
								group by Forecast_DayDate) as FV
				on [Date]=Forecast_DayDate
				where date>='2014-12-28') as Daily
				
				
				
		left join

				(select * from [bvt_prod].[Drag_Method_Start_End_VW] 
					where [idProgram_LU_TBL_FK]=3) as A
		
		on Daily.Date between [drag_start_date] and [END_DATE]