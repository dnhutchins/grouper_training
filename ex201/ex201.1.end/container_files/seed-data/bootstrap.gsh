gs = GrouperSession.startRootSession();
delStem("201.1.1")
addRootStem("201.1.end", "201.1.end")

// ex201.1.1
// addStem("ref", "student", "student")
addGroup("ref:student", "students", "students");

// added by loader job. these are not needed.
// addGroup("ref:student", "class2019", "class2019");
// addGroup("ref:student", "class2020", "class2020");
// addGroup("ref:student", "class2021", "class2021");
// addGroup("ref:student", "class2022", "class2022");
// addGroup("ref:student", "class2023", "class2023");

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
addMember("ref:student:students","basis:student:student_no_class_year");

// ex 201.1.3
addMember("ref:student:students","basis:student:exchange_students");

// ex 201.1.4
addGroup("basis:student", "transfer_student", "transfer_student");
addMember("basis:student:transfer_student","agrady901");
addMember("basis:student:transfer_student","alee467");
addMember("basis:student:transfer_student","ascott776");

java.util.Calendar cal2 = Calendar.getInstance();
cal2.add(Calendar.DATE, 60);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:transfer_student", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal2.getTime(), false);

// ex 201.1.5
java.util.Calendar cal3 = Calendar.getInstance();
cal3.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:expelled_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal3.getTime(), false);

java.util.Calendar cal4 = Calendar.getInstance();
cal4.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:resigned_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal4.getTime(), false);

java.util.Calendar cal5 = Calendar.getInstance();
cal5.add(Calendar.DATE, 32);
group = GroupFinder.findByName(gs, "ref:student:students", true);
subject = GroupFinder.findByName(gs, "basis:student:transfered_32_days", true).toSubject();
group.addOrEditMember(subject, true, true, null, cal5.getTime(), false);

// ex 201.1.6
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
