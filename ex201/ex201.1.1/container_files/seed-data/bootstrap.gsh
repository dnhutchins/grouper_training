gs = GrouperSession.startRootSession();
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("bundle", "bundle");
addRootStem("app", "app");
addRootStem("org", "org");
addRootStem("test", "test");

addGroup("etc","studentTermLoader", "studentTermLoader");
groupAddType("etc:studentTermLoader", "grouperLoader");
setGroupAttr("etc:studentTermLoader", "grouperLoaderDbName", "grouper");
setGroupAttr("etc:studentTermLoader", "grouperLoaderType", "SQL_GROUP_LIST");
setGroupAttr("etc:studentTermLoader", "grouperLoaderScheduleType", "CRON");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:studentTermLoader", "grouperLoaderQuery", "select distinct id as SUBJECT_IDENTIFIER, 'ldap' as SUBJECT_SOURCE_ID, CONCAT('ref:student:class', term) as GROUP_NAME from SIS_STUDENT_TERMS");
