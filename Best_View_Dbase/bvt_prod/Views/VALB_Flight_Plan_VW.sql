﻿
drop view bvt_prod.VALB_Flight_Plan_VW
go

create view [bvt_prod].[VALB_Flight_Plan_VW]
as select * from bvt_prod.Flight_Plan_Records 
where idProgram_Touch_Definitions_TBL_FK in (SELECT * FROM bvt_prod.Program_ID_Selector(2))
