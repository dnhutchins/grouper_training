gs = GrouperSession.startRootSession();
addRootStem("201.1.1", "201.1.1")
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("app", "app");
addRootStem("org", "org");
addRootStem("test", "test");

addStem("ref", "iam", "iam");
addGroup("ref:iam", "active", "active");

// loader job for class year groups :ref:student:class2019, etc.
addGroup("etc","studentTermLoader", "studentTermLoader");
groupAddType("etc:studentTermLoader", "grouperLoader");
setGroupAttr("etc:studentTermLoader", "grouperLoaderDbName", "grouper");
setGroupAttr("etc:studentTermLoader", "grouperLoaderType", "SQL_GROUP_LIST");
setGroupAttr("etc:studentTermLoader", "grouperLoaderScheduleType", "CRON");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuery", "select distinct id as SUBJECT_IDENTIFIER, 'ldap' as SUBJECT_SOURCE_ID, CONCAT('ref:student:class', term) as GROUP_NAME from SIS_STUDENT_TERMS");

// Stub out class groups. These will be filled out by the studentTermLoader
addStem("ref", "student", "student");
def classList = [:]
(2019..2024).each { term ->
    classList[term] = addGroup("ref:student", "class${term}", "class${term}")
}


// Set ref object type on class reference groups
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
classList.each { term, group ->
    AttributeAssign attributeAssign = group.getAttributeDelegate().hasAttribute(typeMarker) ? group.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : group.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign()
    attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true")
    attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref")
    attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar")
    attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription", "Class of ${term}");
}


// ex 201.1.2
addStem("basis", "student", "student");
student_no_class_year = addGroup("basis:student", "student_no_class_year",
"student_no_class_year");

AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = student_no_class_year.getAttributeDelegate().hasAttribute(typeMarker) ? student_no_class_year.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : student_no_class_year.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Students with no class year. Part-time students, employees taking classes, etc");

student_no_class_year.addMember(findSubject("wnielson101"));
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

// ex 201.1.3
exchange_students = addGroup("basis:student", "exchange_students", "exchange_students");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = exchange_students.getAttributeDelegate().hasAttribute(typeMarker) ? exchange_students.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : exchange_students.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Exchange students who are not in SIS");
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

// ex 201.1.5
expelled_32_days = addGroup("basis:student", "expelled_32_days", "expelled_32_days");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = expelled_32_days.getAttributeDelegate().hasAttribute(typeMarker) ? expelled_32_days.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : expelled_32_days.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Expelled students with a 32 day grace period");
addMember("basis:student:expelled_32_days","ewilliams400");
addMember("basis:student:expelled_32_days","dwalters404");
addMember("basis:student:expelled_32_days","ldoe407");
addMember("basis:student:expelled_32_days","mhenderson421");
addMember("basis:student:expelled_32_days","mgonazles423");

resigned_32_days = addGroup("basis:student", "resigned_32_days",
"resigned_32_days");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = resigned_32_days.getAttributeDelegate().hasAttribute(typeMarker) ? resigned_32_days.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : resigned_32_days.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Students who have resigned with a 32 day grace period");
addMember("basis:student:resigned_32_days","enielson500");
addMember("basis:student:resigned_32_days","sgrady501");
addMember("basis:student:resigned_32_days","sgasper513");
addMember("basis:student:resigned_32_days","swilliams516");
addMember("basis:student:resigned_32_days","jmorrison517");

transfered_32_days = addGroup("basis:student", "transfered_32_days",
"transfered_32_days");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = transfered_32_days.getAttributeDelegate().hasAttribute(typeMarker) ? transfered_32_days.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : transfered_32_days.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Students who have tranfered out with a 32 day grace period");
addMember("basis:student:transfered_32_days","ppeterson609");
addMember("basis:student:transfered_32_days","nthompson612");
addMember("basis:student:transfered_32_days","sanderson613");
addMember("basis:student:transfered_32_days","mwhite617");
addMember("basis:student:transfered_32_days","mwalters618");

// ex 201.1.6
loa_4_years = addGroup("basis:student", "loa_4_years", "loa_4_years");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = loa_4_years.getAttributeDelegate().hasAttribute(typeMarker) ? loa_4_years.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : loa_4_years.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "basis");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Registrar");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Students on leave of absence less than 4 years");
addMember("basis:student:loa_4_years","jprice704");
addMember("basis:student:loa_4_years","aprice705");
addMember("basis:student:loa_4_years","aclark706");

// setup for 201.2
// should be a loader job?
addStem("ref", "employee", "employee")
fac_staff = addGroup("ref:employee", "fac_staff", "fac_staff")

// Set ref object type on fac_staff reference group
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = fac_staff.getAttributeDelegate().hasAttribute(typeMarker) ? fac_staff.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : fac_staff.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"HR and Provost Office");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"All faculty and staff");

addStem("ref", "security", "security")
locked_by_ciso = addGroup("ref:security", "locked_by_ciso", "locked_by_ciso")
AttributeAssign attributeAssign = locked_by_ciso.getAttributeDelegate().hasAttribute(typeMarker) ? locked_by_ciso.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : locked_by_ciso.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"CISO");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Subjects denied access by CISO");

closure = addGroup("ref:iam", "closure", "closure")
AttributeAssign attributeAssign = closure.getAttributeDelegate().hasAttribute(typeMarker) ? closure.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : closure.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"IAM");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Accounts in the process of being closed");

addStem("org", "irb", "irb")
addStem("org:irb", "ref", "ref")
irb_members = addGroup("org:irb:ref", "irb_members", "irb_members")
AttributeAssign attributeAssign = irb_members.getAttributeDelegate().hasAttribute(typeMarker) ? irb_members.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : irb_members.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"Institutional Review Board");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Members of the IRB");

// setup for 201.4
global_deny = addGroup("ref:iam", "global_deny", "global_deny");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = global_deny.getAttributeDelegate().hasAttribute(typeMarker) ? global_deny.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : global_deny.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"Identity and Access Management");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Global deny group");

// setup for 201.5
// should be a loader job?
addStem("ref", "dept", "dept")
addGroup("ref:dept", "finance", "finance")
addMember("ref:dept:finance", "asmith989")