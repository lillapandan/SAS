
proc sql;
	create table NEW_ADHD_DATASET as
	select distinct lopnr /* remove duplicates */
	from PATIENT_ADHD
	group by lopnr
	having count(*) ge 2 /* keep ADHD cases who received ADHD diagnosis at least twice */
;
quit;
