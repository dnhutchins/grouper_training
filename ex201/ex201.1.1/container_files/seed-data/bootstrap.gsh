gs = GrouperSession.startRootSession();
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("bundle", "bundle");
addRootStem("app", "app");
addRootStem("org", "org");
addRootStem("test", "test");

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
addGroup("ref:student", "class2019", "class2019");
addGroup("ref:student", "class2020", "class2020");
addGroup("ref:student", "class2021", "class2021");
addGroup("ref:student", "class2022", "class2022");
addGroup("ref:student", "class2023", "class2023");

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

// ex 201.1.5
addGroup("basis:student", "expelled_32_days", "expelled_32_days");
addMember("basis:student:expelled_32_days","ewilliams400");
addMember("basis:student:expelled_32_days","dwalters404");
addMember("basis:student:expelled_32_days","ldoe407");
addMember("basis:student:expelled_32_days","mhenderson421");
addMember("basis:student:expelled_32_days","mgonazles423");

addGroup("basis:student", "resigned_32_days", "resigned_32_days");
addMember("basis:student:resigned_32_days","enielson500");
addMember("basis:student:resigned_32_days","sgrady501");
addMember("basis:student:resigned_32_days","sgasper513");
addMember("basis:student:resigned_32_days","swilliams516");
addMember("basis:student:resigned_32_days","jmorrison517");

addGroup("basis:student", "transfered_32_days", "transfered_32_days");
addMember("basis:student:transfered_32_days","ppeterson609");
addMember("basis:student:transfered_32_days","nthompson612");
addMember("basis:student:transfered_32_days","sanderson613");
addMember("basis:student:transfered_32_days","mwhite617");
addMember("basis:student:transfered_32_days","mwalters618");

// ex 201.1.6
addGroup("basis:student", "loa_4_years", "loa_4_years");
addMember("basis:student:loa_4_years","jprice704");
addMember("basis:student:loa_4_years","aprice705");
addMember("basis:student:loa_4_years","aclark706");
