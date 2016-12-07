
Drop Proc [bvt_processed].[Movers_AltMed_Forecast_Campaign_Summary_PR]
GO

CREATE proc [bvt_processed].[Movers_AltMed_Forecast_Campaign_Summary_PR]
as
--declare @lst_load datetime
--select @lst_load = (select MAX(load_dt) from bvt_processed.Movers_Best_View_Forecast)

select KPIs.*, costs.Budget, MediaMonth_Year,MediaMonth,MediaMonth_YYYYMM

from
(select * from
	(select 
		idFlight_Plan_Records
		, Campaign_Name
		, InHome_Date
		, Touch_Name
		, Program_Name
		, Tactic
		, Media
		, Campaign_Type
		, Audience
		, Creative_Name
		, Goal
		, Offer
		, Product_Code
		, sum(Forecast) as Forecast
	from bvt_prod.Movers_Best_View_Forecast_VW

	group by idFlight_Plan_Records
		, Campaign_Name
		, InHome_Date
		, Touch_Name
		, Program_Name
		, Tactic
		, Media
		, Campaign_Type
		, Audience
		, Creative_Name
		, Goal
		, Offer
		, Product_Code) as Metrics
	PIVOT
	(Sum(Forecast) For Product_Code in 
		([Access Line]
		, DSL
		, [DSL Direct]
		, IPDSL
		, HSIA
		, UVTV
		, VoIP
		, DirecTV
		, [WRLS Voice]
		, [WRLS Family]
		, [WRLS Data]
		, [WRLS Home]
		, ConnecTech
		, [Digital Life]
		, [Bolt ons]
		, Upgrades
		, [Call]
		, [Online]
		, Volume)) as pivottable) as KPIs
	
	left join 
	
	(select 
		idFlight_Plan_Records
		, sum(budget) as Budget
	from bvt_prod.Movers_Financial_Budget_Forecast
	GROUP by idFlight_Plan_Records) as costs

	on KPIs.idFlight_Plan_Records=costs.idFlight_Plan_Records
	
	left join
	
	DIM.Media_Calendar_Daily
	on KPIs.InHome_Date=DIM.Media_Calendar_Daily.Date
Where Media in ('BI', 'MoveATT','USPS','SM','FPC')


GO

