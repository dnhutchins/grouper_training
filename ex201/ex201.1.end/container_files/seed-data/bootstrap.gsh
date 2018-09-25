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




addMember("","");
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


// ex201.1.3





//addComposite("test:whyvpnaccess", CompositeType.INTERSECTION, "app:vpn:vpn_authorized", "test:cisoQuestionableVpnUsersList");

