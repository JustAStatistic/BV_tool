﻿
create proc bvt_processed.Sales_Curve_Start_End_PR
AS
truncate table bvt_processed.Sales_Curve_Start_End
insert into bvt_processed.Sales_Curve_Start_End
select * from bvt_prod.Sales_Curve_Start_End_VW
