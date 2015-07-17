/* 1. Full sibling pairs, including monozygotic twins*/
proc sql;
	create table fsib as
	select 	a.lopnr, 
			b.lopnr as relative,
			"fsib" as gr
	from 	crime2.v_parent as a, 
			crime2.v_parent as b
	where	a.lopnr ^= b.lopnr &
			a.lopnrmor = b.lopnrmor &
			a.lopnrmor ^= . &
			b.lopnrmor ^= . &
			a.lopnrfar = b.lopnrfar &
			a.lopnrfar ^= . &
			b.lopnrfar ^= .
;
quit;

/* 2. Maternal half sibling pairs*/
proc sql;
	create table mhsib as
	select 	a.lopnr, 
			b.lopnr as relative,
			"mh" as gr
	from 	crime2.v_parent as a, 
			crime2.v_parent as b
	where	a.lopnrmor = b.lopnrmor &
			a.lopnrmor ^= . &
			b.lopnrmor ^= . &
			a.lopnrfar ^= b.lopnrfar &
			a.lopnrfar ^= . &
			b.lopnrfar ^= .
;
quit;

/* 3. Paternal half sibling pairs*/
proc sql;
	create table phsib as
	select 	a.lopnr,
			b.lopnr as relative,
			"ph" as gr
	from 	crime2.v_parent as a, 
			crime2.v_parent as b
	where	a.lopnrmor ^= b.lopnrmor &
			a.lopnrmor ^= . &
			b.lopnrmor ^= . &
			a.lopnrfar = b.lopnrfar &
			a.lopnrfar ^= . &
			b.lopnrfar ^= .
;
quit;

/* 4. Full cousin pairs: children of full siblings, including double first cousin pairs
and children of monozygotic twins */

proc sql;
	create table fcn as
	select	distinct
			a.lopnrbarn as lopnr,
			b.lopnrbarn as relative,
			"fcn" as gr
	from 	crime2.v_child as a,
		 	crime2.v_child as b,
		 	fsib as c
	where 	a.lopnr = c.lopnr &
			b.lopnr = c.relative
;
quit;


/*Generate one dataset containing all identified kinships*/
data kin4;
	set fsib mhsib phsib fcn;
run;

proc freq data=kin4 order = data; tables gr; run;
