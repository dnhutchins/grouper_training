gs = GrouperSession.startRootSession();


// ex201.1.1
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




//Is this needed?
//addMember("","");
//Set expiration out Dec 31, 2018 days
java.util.Calendar cal = Calendar.getInstance();
cal.setTime(new Date(2018,12,31);

addGroup("ref:student", "class2018", "class2018");
addMember("ref:student:students","ref:student:class2018");
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "ref:student:class2018", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal.getTime(), false);

 
// ex 201.1.2

addStem("basis, "student", "student");
addGroup("basis:student", "student_no_class_year", "student_no_class_year");
addMember("ref:student:students","basis:student:student_no_class_year");


// ex 201.1.3

addGroup("basis:student", "exchange_students", "exchange_students");
addMember("ref:student:students","basis:student:exchange_students");

// ex 201.1.4

addGroup("basis:student", "transfer_student", "transfer_student");
addMember("basis:student:transfer_student","ewilliams400");
addMember("basis:student:transfer_student","dwalters404");
addMember("basis:student:transfer_student","ldoe407");
addMember("basis:student:transfer_student","mhenderson421");
addMember("basis:student:transfer_student","mgonazles423");
addMember("basis:student:transfer_student","bhenderson425");
addMember("basis:student:transfer_student","avales427");
addMember("basis:student:transfer_student","eroberts428");
addMember("basis:student:transfer_student","rclark429");
addMember("basis:student:transfer_student","gnielson434");
addMember("basis:student:transfer_student","oprice440");
addMember("basis:student:transfer_student","jlee443");
addMember("basis:student:transfer_student","npeterson448");
addMember("basis:student:transfer_student","dwalters449");
addMember("basis:student:transfer_student","dlee456");
addMember("basis:student:transfer_student","bsmith458");
addMember("basis:student:transfer_student","jdavis461");
addMember("basis:student:transfer_student","lhenderson464");
addMember("basis:student:transfer_student","alee467");
addMember("basis:student:transfer_student","agrady468");
addMember("basis:student:transfer_student","cwhite470");
addMember("basis:student:transfer_student","mgasper473");
addMember("basis:student:transfer_student","bjohnson481");
addMember("basis:student:transfer_student","sanderson484");
addMember("basis:student:transfer_student","wmartinez487");

java.util.Calendar cal2 = Calendar.getInstance();
cal2.add(Calendar.DATE, 60);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:transfer_student", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal2.getTime(), false);

addMember("ref:student:students","basis:student:transfer_student");

// ex 201.1.5

addGroup("basis:student", "expelled_32_days", "expelled_32_days");
addMember("basis:student:expelled_32_days","emartinez300");
addMember("basis:student:expelled_32_days","glee303");
addMember("basis:student:expelled_32_days","bdoe304");
addMember("basis:student:expelled_32_days","dlangenberg305");
addMember("basis:student:expelled_32_days","dthompson306");

java.util.Calendar cal3 = Calendar.getInstance();
cal3.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:expelled_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal3.getTime(), false);

addGroup("basis:student", "resigned_32_days", "resigned_32_days");
addMember("basis:student:resigned_32_days","jnielson201");
addMember("basis:student:resigned_32_days","aprice205");
addMember("basis:student:resigned_32_days","cmorrison212");
addMember("basis:student:resigned_32_days","nroberts214");
addMember("basis:student:resigned_32_days","ehenderson217");

java.util.Calendar cal4 = Calendar.getInstance();
cal4.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:resigned_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal4.getTime(), false);

addGroup("basis:student", "transfered_32_days", "transfered_32_days");
addMember("basis:student:transfered_32_days","wnielson101");
addMember("basis:student:transfered_32_days","ahenderson105");
addMember("basis:student:transfered_32_days","mnielson106");
addMember("basis:student:transfered_32_days","mclark114");
addMember("basis:student:transfered_32_days","gpeterson116");

java.util.Calendar cal5 = Calendar.getInstance();
cal5.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:transfered_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal5.getTime(), false);

addMember("ref:student:students","basis:student:expelled_32_days");
addMember("ref:student:students","basis:student:resigned_32_days");
addMember("ref:student:students","basis:student:transfered_32_days");

// ex 201.1.6

addGroup("basis:student", "loa_4_years", "loa_4_years");
addMember("basis:student:loa_4_years","jnielson152");
addMember("basis:student:loa_4_years","jmartinez155");
addMember("basis:student:loa_4_years","jlangenberg157");

java.util.Calendar cal6 = Calendar.getInstance();
cal6.add(Calendar.YEAR, 4);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:loa_4_years", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal6.getTime(), false);

addMember("ref:student:students","basis:student:loa_4_years");

// ex 201.1.7

addGroup("ref:student", "on_track_grad", "on_track_grad");
addMember("ref:student:on_track_grad","ref:student:class2019");

java.util.Calendar cal7 = Calendar.getInstance();
cal7.setTime(new Date(2019,7,1);

group = GroupFinder.findByName(gs, "ref:student:on_track_grad", true);
subject = GroupFinder.findByName(gs, "ref:student:class2019", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal7.getTime(), false);
