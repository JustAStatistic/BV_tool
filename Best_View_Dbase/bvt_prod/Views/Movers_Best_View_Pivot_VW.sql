﻿DROP VIEW [bvt_prod].[Movers_Best_View_Pivot_VW]
GO

CREATE VIEW [bvt_prod].[Movers_Best_View_Pivot_VW]
	AS 
	Select
	[idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Touch_Name], [Program_Name], [Tactic], [Media], 
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer],
sum(isnull([Call_CV], 0)) as [Call_CV], 
sum(isnull([Online_CV], 0)) as [Online_CV], 
sum(isnull([Online_sales_Access Line_CV], 0)) as [Online_sales_Access Line_CV], 
sum(isnull([Online_sales_DSL_CV], 0)) as [Online_sales_DSL_CV], 
sum(isnull([Online_sales_DSL Direct_CV], 0)) as [Online_sales_DSL Direct_CV], 
sum(isnull([Online_sales_HSIA_CV], 0)) as [Online_sales_HSIA_CV], 
sum(isnull([Online_sales_IPDSL_CV], 0)) as [Online_sales_IPDSL_CV], 
sum(isnull([Online_sales_Satellite_CV], 0)) as [Online_sales_Satellite_CV], 
sum(isnull([Online_sales_UVTV_CV], 0)) as [Online_sales_UVTV_CV], 
sum(isnull([Online_sales_VoIP_CV], 0)) as [Online_sales_VoIP_CV], 
sum(isnull([Online_sales_WRLS Data_CV], 0)) as [Online_sales_WRLS Data_CV], 
sum(isnull([Online_sales_WRLS Family_CV], 0)) as [Online_sales_WRLS Family_CV], 
sum(isnull([Online_sales_WRLS Voice_CV], 0)) as [Online_sales_WRLS Voice_CV], 
sum(isnull([Telesales_Access Line_CV], 0)) as [Telesales_Access Line_CV], 
sum(isnull([Telesales_DSL_CV], 0)) as [Telesales_DSL_CV], 
sum(isnull([Telesales_DSL Direct_CV], 0)) as [Telesales_DSL Direct_CV], 
sum(isnull([Telesales_HSIA_CV], 0)) as [Telesales_HSIA_CV], 
sum(isnull([Telesales_IPDSL_CV], 0)) as [Telesales_IPDSL_CV], 
sum(isnull([Telesales_Satellite_CV], 0)) as [Telesales_Satellite_CV], 
sum(isnull([Telesales_UVTV_CV], 0)) as [Telesales_UVTV_CV], 
sum(isnull([Telesales_VoIP_CV], 0)) as [Telesales_VoIP_CV], 
sum(isnull([Telesales_WRLS Data_CV], 0)) as [Telesales_WRLS Data_CV], 
sum(isnull([Telesales_WRLS Family_CV], 0)) as [Telesales_WRLS Family_CV], 
sum(isnull([Telesales_WRLS Voice_CV], 0)) as [Telesales_WRLS Voice_CV], 
sum(isnull([Volume_CV],0)) as [Volume_CV],
sum(isnull([Call_FV], 0)) as [Call_FV], 
sum(isnull([Online_FV], 0)) as [Online_FV], 
sum(isnull([Online_sales_Access Line_FV], 0)) as [Online_sales_Access Line_FV], 
sum(isnull([Online_sales_DSL_FV], 0)) as [Online_sales_DSL_FV], 
sum(isnull([Online_sales_DSL Direct_FV], 0)) as [Online_sales_DSL Direct_FV], 
sum(isnull([Online_sales_HSIA_FV], 0)) as [Online_sales_HSIA_FV], 
sum(isnull([Online_sales_IPDSL_FV], 0)) as [Online_sales_IPDSL_FV], 
sum(isnull([Online_sales_Satellite_FV], 0)) as [Online_sales_Satellite_FV], 
sum(isnull([Online_sales_UVTV_FV], 0)) as [Online_sales_UVTV_FV], 
sum(isnull([Online_sales_VoIP_FV], 0)) as [Online_sales_VoIP_FV], 
sum(isnull([Online_sales_WRLS Data_FV], 0)) as [Online_sales_WRLS Data_FV], 
sum(isnull([Online_sales_WRLS Family_FV], 0)) as [Online_sales_WRLS Family_FV], 
sum(isnull([Online_sales_WRLS Voice_FV], 0)) as [Online_sales_WRLS Voice_FV], 
sum(isnull([Telesales_Access Line_FV], 0)) as [Telesales_Access Line_FV], 
sum(isnull([Telesales_DSL_FV], 0)) as [Telesales_DSL_FV], 
sum(isnull([Telesales_DSL Direct_FV], 0)) as [Telesales_DSL Direct_FV], 
sum(isnull([Telesales_HSIA_FV], 0)) as [Telesales_HSIA_FV], 
sum(isnull([Telesales_IPDSL_FV], 0)) as [Telesales_IPDSL_FV], 
sum(isnull([Telesales_Satellite_FV], 0)) as [Telesales_Satellite_FV], 
sum(isnull([Telesales_UVTV_FV], 0)) as [Telesales_UVTV_FV], 
sum(isnull([Telesales_VoIP_FV], 0)) as [Telesales_VoIP_FV], 
sum(isnull([Telesales_WRLS Data_FV], 0)) as [Telesales_WRLS Data_FV], 
sum(isnull([Telesales_WRLS Family_FV], 0)) as [Telesales_WRLS Family_FV], 
sum(isnull([Telesales_WRLS Voice_FV], 0)) as [Telesales_WRLS Voice_FV], 
sum(isnull([Volume_FV],0)) as [Volume_FV],
sum(isnull([Call_AV], 0)) as [Call_AV], 
sum(isnull([Online_AV], 0)) as [Online_AV], 
sum(isnull([Online_sales_Access Line_AV], 0)) as [Online_sales_Access Line_AV], 
sum(isnull([Online_sales_DSL_AV], 0)) as [Online_sales_DSL_AV], 
sum(isnull([Online_sales_DSL Direct_AV], 0)) as [Online_sales_DSL Direct_AV], 
sum(isnull([Online_sales_HSIA_AV], 0)) as [Online_sales_HSIA_AV], 
sum(isnull([Online_sales_IPDSL_AV], 0)) as [Online_sales_IPDSL_AV], 
sum(isnull([Online_sales_Satellite_AV], 0)) as [Online_sales_Satellite_AV], 
sum(isnull([Online_sales_UVTV_AV], 0)) as [Online_sales_UVTV_AV], 
sum(isnull([Online_sales_VoIP_AV], 0)) as [Online_sales_VoIP_AV], 
sum(isnull([Online_sales_WRLS Data_AV], 0)) as [Online_sales_WRLS Data_AV], 
sum(isnull([Online_sales_WRLS Family_AV], 0)) as [Online_sales_WRLS Family_AV], 
sum(isnull([Online_sales_WRLS Voice_AV], 0)) as [Online_sales_WRLS Voice_AV], 
sum(isnull([Telesales_Access Line_AV], 0)) as [Telesales_Access Line_AV], 
sum(isnull([Telesales_DSL_AV], 0)) as [Telesales_DSL_AV], 
sum(isnull([Telesales_DSL Direct_AV], 0)) as [Telesales_DSL Direct_AV], 
sum(isnull([Telesales_HSIA_AV], 0)) as [Telesales_HSIA_AV], 
sum(isnull([Telesales_IPDSL_AV], 0)) as [Telesales_IPDSL_AV], 
sum(isnull([Telesales_Satellite_AV], 0)) as [Telesales_Satellite_AV], 
sum(isnull([Telesales_UVTV_AV], 0)) as [Telesales_UVTV_AV], 
sum(isnull([Telesales_VoIP_AV], 0)) as [Telesales_VoIP_AV], 
sum(isnull([Telesales_WRLS Data_AV], 0)) as [Telesales_WRLS Data_AV], 
sum(isnull([Telesales_WRLS Family_AV], 0)) as [Telesales_WRLS Family_AV], 
sum(isnull([Telesales_WRLS Voice_AV], 0)) as [Telesales_WRLS Voice_AV], 
sum(isnull([Volume_AV],0)) as [Volume_AV],
sum(isnull([Call_BV], 0)) as [Call_BV], 
sum(isnull([Online_BV], 0)) as [Online_BV], 
sum(isnull([Online_sales_Access Line_BV], 0)) as [Online_sales_Access Line_BV], 
sum(isnull([Online_sales_DSL_BV], 0)) as [Online_sales_DSL_BV], 
sum(isnull([Online_sales_DSL Direct_BV], 0)) as [Online_sales_DSL Direct_BV], 
sum(isnull([Online_sales_HSIA_BV], 0)) as [Online_sales_HSIA_BV], 
sum(isnull([Online_sales_IPDSL_BV], 0)) as [Online_sales_IPDSL_BV], 
sum(isnull([Online_sales_Satellite_BV], 0)) as [Online_sales_Satellite_BV], 
sum(isnull([Online_sales_UVTV_BV], 0)) as [Online_sales_UVTV_BV], 
sum(isnull([Online_sales_VoIP_BV], 0)) as [Online_sales_VoIP_BV], 
sum(isnull([Online_sales_WRLS Data_BV], 0)) as [Online_sales_WRLS Data_BV], 
sum(isnull([Online_sales_WRLS Family_BV], 0)) as [Online_sales_WRLS Family_BV], 
sum(isnull([Online_sales_WRLS Voice_BV], 0)) as [Online_sales_WRLS Voice_BV], 
sum(isnull([Telesales_Access Line_BV], 0)) as [Telesales_Access Line_BV], 
sum(isnull([Telesales_DSL_BV], 0)) as [Telesales_DSL_BV], 
sum(isnull([Telesales_DSL Direct_BV], 0)) as [Telesales_DSL Direct_BV], 
sum(isnull([Telesales_HSIA_BV], 0)) as [Telesales_HSIA_BV], 
sum(isnull([Telesales_IPDSL_BV], 0)) as [Telesales_IPDSL_BV], 
sum(isnull([Telesales_Satellite_BV], 0)) as [Telesales_Satellite_BV], 
sum(isnull([Telesales_UVTV_BV], 0)) as [Telesales_UVTV_BV], 
sum(isnull([Telesales_VoIP_BV], 0)) as [Telesales_VoIP_BV], 
sum(isnull([Telesales_WRLS Data_BV], 0)) as [Telesales_WRLS Data_BV], 
sum(isnull([Telesales_WRLS Family_BV], 0)) as [Telesales_WRLS Family_BV], 
sum(isnull([Telesales_WRLS Voice_BV], 0)) as [Telesales_WRLS Voice_BV], 
sum(isnull([Volume_BV], 0)) as [Volume_BV],
sum(isnull([Online_sales_Access Line_CV], 0))+ sum(isnull([Online_sales_DSL_CV], 0))+ sum(isnull([Online_sales_DSL Direct_CV], 0))+ sum(isnull([Online_sales_HSIA_CV], 0))+ sum(isnull([Online_sales_IPDSL_CV], 0))+ sum(isnull([Online_sales_Satellite_CV], 0))+ sum(isnull([Online_sales_UVTV_CV], 0))+ sum(isnull([Online_sales_VoIP_CV], 0))+ sum(isnull([Online_sales_WRLS Data_CV], 0))+ sum(isnull([Online_sales_WRLS Family_CV], 0))+ sum(isnull([Online_sales_WRLS Voice_CV], 0)) as Online_Strat_CV,
sum(isnull([Online_sales_Access Line_BV], 0))+ sum(isnull([Online_sales_DSL_BV], 0))+ sum(isnull([Online_sales_DSL Direct_BV], 0))+ sum(isnull([Online_sales_HSIA_BV], 0))+ sum(isnull([Online_sales_IPDSL_BV], 0))+ sum(isnull([Online_sales_Satellite_BV], 0))+ sum(isnull([Online_sales_UVTV_BV], 0))+ sum(isnull([Online_sales_VoIP_BV], 0))+ sum(isnull([Online_sales_WRLS Data_BV], 0))+ sum(isnull([Online_sales_WRLS Family_BV], 0))+ sum(isnull([Online_sales_WRLS Voice_BV], 0)) as Online_Strat_BV,
sum(isnull([Online_sales_Access Line_FV], 0))+ sum(isnull([Online_sales_DSL_FV], 0))+ sum(isnull([Online_sales_DSL Direct_FV], 0))+ sum(isnull([Online_sales_HSIA_FV], 0))+ sum(isnull([Online_sales_IPDSL_FV], 0))+ sum(isnull([Online_sales_Satellite_FV], 0))+ sum(isnull([Online_sales_UVTV_FV], 0))+ sum(isnull([Online_sales_VoIP_FV], 0))+ sum(isnull([Online_sales_WRLS Data_FV], 0))+ sum(isnull([Online_sales_WRLS Family_FV], 0))+ sum(isnull([Online_sales_WRLS Voice_FV], 0)) as Online_Strat_FV,
sum(isnull([Online_sales_Access Line_AV], 0))+ sum(isnull([Online_sales_DSL_AV], 0))+ sum(isnull([Online_sales_DSL Direct_AV], 0))+ sum(isnull([Online_sales_HSIA_AV], 0))+ sum(isnull([Online_sales_IPDSL_AV], 0))+ sum(isnull([Online_sales_Satellite_AV], 0))+ sum(isnull([Online_sales_UVTV_AV], 0))+ sum(isnull([Online_sales_VoIP_AV], 0))+ sum(isnull([Online_sales_WRLS Data_AV], 0))+ sum(isnull([Online_sales_WRLS Family_AV], 0))+ sum(isnull([Online_sales_WRLS Voice_AV], 0)) as Online_Strat_AV,
sum(isnull([Telesales_Access Line_CV], 0))+ sum(isnull([Telesales_DSL_CV], 0))+ sum(isnull([Telesales_DSL Direct_CV], 0))+ sum(isnull([Telesales_HSIA_CV], 0))+ sum(isnull([Telesales_IPDSL_CV], 0))+ sum(isnull([Telesales_Satellite_CV], 0))+ sum(isnull([Telesales_UVTV_CV], 0))+ sum(isnull([Telesales_VoIP_CV], 0))+ sum(isnull([Telesales_WRLS Data_CV], 0))+ sum(isnull([Telesales_WRLS Family_CV], 0))+ sum(isnull([Telesales_WRLS Voice_CV], 0)) as Telesales_Strat_CV,
sum(isnull([Telesales_Access Line_BV], 0))+ sum(isnull([Telesales_DSL_BV], 0))+ sum(isnull([Telesales_DSL Direct_BV], 0))+ sum(isnull([Telesales_HSIA_BV], 0))+ sum(isnull([Telesales_IPDSL_BV], 0))+ sum(isnull([Telesales_Satellite_BV], 0))+ sum(isnull([Telesales_UVTV_BV], 0))+ sum(isnull([Telesales_VoIP_BV], 0))+ sum(isnull([Telesales_WRLS Data_BV], 0))+ sum(isnull([Telesales_WRLS Family_BV], 0))+ sum(isnull([Telesales_WRLS Voice_BV], 0)) as Telesales_Strat_BV,
sum(isnull([Telesales_Access Line_FV], 0))+ sum(isnull([Telesales_DSL_FV], 0))+ sum(isnull([Telesales_DSL Direct_FV], 0))+ sum(isnull([Telesales_HSIA_FV], 0))+ sum(isnull([Telesales_IPDSL_FV], 0))+ sum(isnull([Telesales_Satellite_FV], 0))+ sum(isnull([Telesales_UVTV_FV], 0))+ sum(isnull([Telesales_VoIP_FV], 0))+ sum(isnull([Telesales_WRLS Data_FV], 0))+ sum(isnull([Telesales_WRLS Family_FV], 0))+ sum(isnull([Telesales_WRLS Voice_FV], 0)) as Telesales_Strat_FV,
sum(isnull([Telesales_Access Line_AV], 0))+ sum(isnull([Telesales_DSL_AV], 0))+ sum(isnull([Telesales_DSL Direct_AV], 0))+ sum(isnull([Telesales_HSIA_AV], 0))+ sum(isnull([Telesales_IPDSL_AV], 0))+ sum(isnull([Telesales_Satellite_AV], 0))+ sum(isnull([Telesales_UVTV_AV], 0))+ sum(isnull([Telesales_VoIP_AV], 0))+ sum(isnull([Telesales_WRLS Data_AV], 0))+ sum(isnull([Telesales_WRLS Family_AV], 0))+ sum(isnull([Telesales_WRLS Voice_AV], 0)) as Telesales_Strat_AV
	FROM
		(SELECT  
	[idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Touch_Name], [Program_Name], [Tactic], [Media], 
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer], [Forecast], [Commitment], [Actual], [Best_View]
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_CV'
		Else [KPI_Type]+'_'+[Product_Code]+'_CV' end as CV_metric 
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_FV'
		Else [KPI_Type]+'_'+[Product_Code]+'_FV' end as FV_metric
	,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_AV'
		Else [KPI_Type]+'_'+[Product_Code]+'_AV' end as AV_metric 
		,Case when kpi_type in ('Response','Volume','Budget') then Product_Code+'_BV'
		Else [KPI_Type]+'_'+[Product_Code]+'_BV' end as BV_metric 

	FROM [bvt_prod].[Mover_Best_View_VW]) as transform

	pivot 
	(SUM(Commitment) for CV_METRIC IN ([Call_CV], 
[Online_CV], 
[Online_sales_Access Line_CV], 
[Online_sales_DSL_CV], 
[Online_sales_DSL Direct_CV], 
[Online_sales_HSIA_CV], 
[Online_sales_IPDSL_CV], 
[Online_sales_Satellite_CV], 
[Online_sales_UVTV_CV], 
[Online_sales_VoIP_CV], 
[Online_sales_WRLS Data_CV], 
[Online_sales_WRLS Family_CV], 
[Online_sales_WRLS Voice_CV], 
[Telesales_Access Line_CV], 
[Telesales_DSL_CV], 
[Telesales_DSL Direct_CV], 
[Telesales_HSIA_CV], 
[Telesales_IPDSL_CV], 
[Telesales_Satellite_CV], 
[Telesales_UVTV_CV], 
[Telesales_VoIP_CV], 
[Telesales_WRLS Data_CV], 
[Telesales_WRLS Family_CV], 
[Telesales_WRLS Voice_CV], 
[Volume_CV]
)) as P1

	pivot(sum(forecast) for FV_Metric in ([Call_FV], 
[Online_FV], 
[Online_sales_Access Line_FV], 
[Online_sales_DSL_FV], 
[Online_sales_DSL Direct_FV], 
[Online_sales_HSIA_FV], 
[Online_sales_IPDSL_FV], 
[Online_sales_Satellite_FV], 
[Online_sales_UVTV_FV], 
[Online_sales_VoIP_FV], 
[Online_sales_WRLS Data_FV], 
[Online_sales_WRLS Family_FV], 
[Online_sales_WRLS Voice_FV], 
[Telesales_Access Line_FV], 
[Telesales_DSL_FV], 
[Telesales_DSL Direct_FV], 
[Telesales_HSIA_FV], 
[Telesales_IPDSL_FV], 
[Telesales_Satellite_FV], 
[Telesales_UVTV_FV], 
[Telesales_VoIP_FV], 
[Telesales_WRLS Data_FV], 
[Telesales_WRLS Family_FV], 
[Telesales_WRLS Voice_FV], 
[Volume_FV])) as P2

	pivot(sum(actual) for AV_Metric in ([Call_AV], 
[Online_AV], 
[Online_sales_Access Line_AV], 
[Online_sales_DSL_AV], 
[Online_sales_DSL Direct_AV], 
[Online_sales_HSIA_AV], 
[Online_sales_IPDSL_AV], 
[Online_sales_Satellite_AV], 
[Online_sales_UVTV_AV], 
[Online_sales_VoIP_AV], 
[Online_sales_WRLS Data_AV], 
[Online_sales_WRLS Family_AV], 
[Online_sales_WRLS Voice_AV], 
[Telesales_Access Line_AV], 
[Telesales_DSL_AV], 
[Telesales_DSL Direct_AV], 
[Telesales_HSIA_AV], 
[Telesales_IPDSL_AV], 
[Telesales_Satellite_AV], 
[Telesales_UVTV_AV], 
[Telesales_VoIP_AV], 
[Telesales_WRLS Data_AV], 
[Telesales_WRLS Family_AV], 
[Telesales_WRLS Voice_AV], 
[Volume_AV])) as P3

	pivot(sum(best_view) for BV_Metric in ([Call_BV], 
[Online_BV], 
[Online_sales_Access Line_BV], 
[Online_sales_DSL_BV], 
[Online_sales_DSL Direct_BV], 
[Online_sales_HSIA_BV], 
[Online_sales_IPDSL_BV], 
[Online_sales_Satellite_BV], 
[Online_sales_UVTV_BV], 
[Online_sales_VoIP_BV], 
[Online_sales_WRLS Data_BV], 
[Online_sales_WRLS Family_BV], 
[Online_sales_WRLS Voice_BV], 
[Telesales_Access Line_BV], 
[Telesales_DSL_BV], 
[Telesales_DSL Direct_BV], 
[Telesales_HSIA_BV], 
[Telesales_IPDSL_BV], 
[Telesales_Satellite_BV], 
[Telesales_UVTV_BV], 
[Telesales_VoIP_BV], 
[Telesales_WRLS Data_BV], 
[Telesales_WRLS Family_BV], 
[Telesales_WRLS Voice_BV], 
[Volume_BV])) as P4

group by [idFlight_Plan_Records_FK], [Campaign_Name], [InHome_Date], [Media_Year], [Media_Week], [Media_Month], [Touch_Name], [Program_Name], [Tactic], [Media], 
	[Campaign_Type], [Audience], [Creative_Name], [Goal], [Offer]