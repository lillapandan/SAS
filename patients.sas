

/*Patients with diagnosis of autism or adhd*/

		
data patients;
	set crime2.v_patient_diag;
		if 	(icd_nr=9  and (substr(diagnos,1,3)='314' or substr(diagnos,1,4)='299A')) or
			(icd_nr=10 and (substr(diagnos,1,3)='F90' or substr(diagnos,1,4) in ('F840','F841','F845','F849')));

		if substr(diagnos,1,3) in ('314','F90')then ADHD = 1;
		else ADHD = 0;

		if substr(diagnos,1,4) in('299A','F840','F841','F845','F849') then Autism=1;
		else Autism = 0;

        keep lopnr ADHD Autism;

run;


proc sql;
	create table adhd as
	select lopnr
	from patients
	group by lopnr
	having sum(ADHD) ge 2 /*keep individuals with at least two diagnosis*/
;
	create table autism as
	select lopnr
	from patients
	group by lopnr
	having sum (Autism) ge 2
;
quit;

proc format;
	value diagnosis 1 = "ADHD"
					2 = "Autism"
					3 = "ADHD & Autism";
run;

data diagnosis;
	merge adhd(in=a) autism(in=b);

	by lopnr;

	adhd = a;
	autism = b;
	
	if adhd = 1 & autism = 1 then  dual = 1;
	else dual = 0;

	if adhd = 1 & autism = 0 then only_adhd = 1;
	else only_adhd = 0;

	if autism = 1 & adhd = 0 then only_autism = 1;
	else only_autism = 0;

	if only_adhd = 1 then diagnosis = 1;
	else if only_autism = 1 then diagnosis = 2;
	else diagnosis = 3;

	format diagnosis diagnosis.;

run;

proc freq data = diagnosis; tables diagnosis; run;

