﻿
create view [bvt_prod].[XSell_Flight_Plan_VW]
as select * from bvt_prod.Flight_Plan_Records 
where idProgram_Touch_Definitions_TBL_FK in (SELECT * FROM bvt_prod.Program_Selector('X-Sell'))
