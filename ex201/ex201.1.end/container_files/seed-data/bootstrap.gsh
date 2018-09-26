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

Calendar cal2 = Calendar.getInstance();
cal2.add(Calendar.DATE, 60);
group = GroupFinder.findByName(gs, "basis:student", true);
subject = GroupFinder.findByName(gs, "basis:student:transfer_student", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal.getTime(), false);

addMember("ref:student:students","basis:student:transfer_student");

// ex 201.1.4




