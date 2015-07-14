
/* Merge dataset1,2,3*/

proc sql;
	create table dataset as
	select a.*, b.var1, b.var2, c.var1, c.var2 
	from dataset1 as a
		left join dataset2 as b on a.varA = b.varB
		left join dataset3 as c on a.varA = c.varC
	order by a.var1;
quit;

	
