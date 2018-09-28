gs = GrouperSession.startRootSession();

// ex201.1.1
addStem("ref", "student", "student")
addGroup("ref:student", "students", "students");

addGroup("ref:student", "class2019", "class2019");
addGroup("ref:student", "class2020", "class2020");
addGroup("ref:student", "class2021", "class2021");
addGroup("ref:student", "class2022", "class2022");
addGroup("ref:student", "class2023", "class2023");

addMember("ref:student:students","ref:student:class2019");
addMember("ref:student:students","ref:student:class2020");
addMember("ref:student:students","ref:student:class2021");
addMember("ref:student:students","ref:student:class2022");
addMember("ref:student:students","ref:student:class2023");

//Set expiration out Dec 31, 2018 days
java.util.Calendar cal = Calendar.getInstance();
cal.set(2018, 12, 31)

addGroup("ref:student", "class2018", "class2018");
addMember("ref:student:students","ref:student:class2018");
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "ref:student:class2018", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal.getTime(), false);

 
// ex 201.1.2
addStem("basis", "student", "student");
addGroup("basis:student", "student_no_class_year", "student_no_class_year");
addMember("basis:student:student_no_class_year","wnielson101");
addMember("basis:student:student_no_class_year","ahenderson105");
addMember("basis:student:student_no_class_year","mnielson106");
addMember("basis:student:student_no_class_year","mclark114");
addMember("basis:student:student_no_class_year","gpeterson116");
addMember("basis:student:student_no_class_year","jvales117");
addMember("basis:student:student_no_class_year","lroberts121");
addMember("basis:student:student_no_class_year","jbutler123");
addMember("basis:student:student_no_class_year","nwilliams126");
addMember("basis:student:student_no_class_year","emartinez127");
addMember("basis:student:student_no_class_year","edavis128");
addMember("basis:student:student_no_class_year","jnielson130");
addMember("basis:student:student_no_class_year","abrown132");
addMember("basis:student:student_no_class_year","sanderson134");
addMember("basis:student:student_no_class_year","blee135");
addMember("basis:student:student_no_class_year","jgrady138");
addMember("basis:student:student_no_class_year","clopez141");
addMember("basis:student:student_no_class_year","jnielson152");
addMember("basis:student:student_no_class_year","jmartinez155");
addMember("basis:student:student_no_class_year","jlangenberg157");
addMember("basis:student:student_no_class_year","danderson161");
addMember("basis:student:student_no_class_year","ivales162");
addMember("basis:student:student_no_class_year","nmartinez163");
addMember("basis:student:student_no_class_year","mdavis164");
addMember("basis:student:student_no_class_year","dlopez166");


addMember("ref:student:students","basis:student:student_no_class_year");

// ex 201.1.3
addGroup("basis:student", "exchange_students", "exchange_students");
addMember("basis:student:exchange_students","jnielson201");
addMember("basis:student:exchange_students","aprice205");
addMember("basis:student:exchange_students","cmorrison212");
addMember("basis:student:exchange_students","nroberts214");
addMember("basis:student:exchange_students","ehenderson217");
addMember("basis:student:exchange_students","lthompson225");
addMember("basis:student:exchange_students","mvales228");
addMember("basis:student:exchange_students","ddavis232");
addMember("basis:student:exchange_students","agasper233");
addMember("basis:student:exchange_students","jpeterson243");

addMember("ref:student:students","basis:student:exchange_students");

// ex 201.1.4
addGroup("basis:student", "transfer_student", "transfer_student");
addMember("basis:student:transfer_student","emartinez300");
addMember("basis:student:transfer_student","glee303");
addMember("basis:student:transfer_student","bdoe304");
addMember("basis:student:transfer_student","dlangenberg305");
addMember("basis:student:transfer_student","dthompson306");
addMember("basis:student:transfer_student","mdavis307");
addMember("basis:student:transfer_student","lmartinez312");
addMember("basis:student:transfer_student","awhite318");
addMember("basis:student:transfer_student","mclark321");
addMember("basis:student:transfer_student","jsmith322");
addMember("basis:student:transfer_student","ascott332");
addMember("basis:student:transfer_student","aroberts334");
addMember("basis:student:transfer_student","dgasper335");
addMember("basis:student:transfer_student","jsmith339");
addMember("basis:student:transfer_student","csmith340");
addMember("basis:student:transfer_student","klee342");
addMember("basis:student:transfer_student","elopez344");
addMember("basis:student:transfer_student","gdavis354");
addMember("basis:student:transfer_student","hpeterson355");
addMember("basis:student:transfer_student","glopez356");
addMember("basis:student:transfer_student","jclark361");
addMember("basis:student:transfer_student","svales364");
addMember("basis:student:transfer_student","aclark373");
addMember("basis:student:transfer_student","pmartinez374");
addMember("basis:student:transfer_student","mgrady376");


java.util.Calendar cal2 = Calendar.getInstance();
cal2.add(Calendar.DATE, 60);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:transfer_student", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal2.getTime(), false);

// ex 201.1.5
addGroup("basis:student", "expelled_32_days", "expelled_32_days");
addMember("basis:student:expelled_32_days","ewilliams400");
addMember("basis:student:expelled_32_days","dwalters404");
addMember("basis:student:expelled_32_days","ldoe407");
addMember("basis:student:expelled_32_days","mhenderson421");
addMember("basis:student:expelled_32_days","mgonazles423");


java.util.Calendar cal3 = Calendar.getInstance();
cal3.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:expelled_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal3.getTime(), false);

addGroup("basis:student", "resigned_32_days", "resigned_32_days");
addMember("basis:student:resigned_32_days","enielson500");
addMember("basis:student:resigned_32_days","sgrady501");
addMember("basis:student:resigned_32_days","sgasper513");
addMember("basis:student:resigned_32_days","swilliams516");
addMember("basis:student:resigned_32_days","jmorrison517");


java.util.Calendar cal4 = Calendar.getInstance();
cal4.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:resigned_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal4.getTime(), false);

addGroup("basis:student", "transfered_32_days", "transfered_32_days");
addMember("basis:student:transfered_32_days","ppeterson609");
addMember("basis:student:transfered_32_days","nthompson612");
addMember("basis:student:transfered_32_days","sanderson613");
addMember("basis:student:transfered_32_days","mwhite617");
addMember("basis:student:transfered_32_days","mwalters618");


java.util.Calendar cal5 = Calendar.getInstance();
cal5.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:transfered_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal5.getTime(), false);

// ex 201.1.6
addGroup("basis:student", "loa_4_years", "loa_4_years");
addMember("basis:student:loa_4_years","jprice704");
addMember("basis:student:loa_4_years","aprice705");
addMember("basis:student:loa_4_years","aclark706");


java.util.Calendar cal6 = Calendar.getInstance();
cal6.add(Calendar.YEAR, 4);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:loa_4_years", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal6.getTime(), false);

// ex 201.1.7
addGroup("ref:student", "on_track_grad", "on_track_grad");
addMember("ref:student:on_track_grad","ref:student:class2019");

java.util.Calendar cal7 = Calendar.getInstance();
cal7.set(2019, 7, 1)

group = GroupFinder.findByName(gs, "ref:student:on_track_grad", true);
subject = GroupFinder.findByName(gs, "ref:student:class2019", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal7.getTime(), false);