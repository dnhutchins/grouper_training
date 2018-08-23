gs = GrouperSession.startRootSession();
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("bundle", "bundle");
addRootStem("app", "app");
addRootStem("org", "org");
testStem = addRootStem("test", "test");

addGroup("etc","rolesLoader", "Roles Loader");
groupAddType("etc:rolesLoader", "grouperLoader");
setGroupAttr("etc:rolesLoader", "grouperLoaderDbName", "grouper");
setGroupAttr("etc:rolesLoader", "grouperLoaderType", "SQL_GROUP_LIST");
setGroupAttr("etc:rolesLoader", "grouperLoaderScheduleType", "CRON");
setGroupAttr("etc:rolesLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:rolesLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:rolesLoader", "grouperLoaderQuery", "select distinct id as SUBJECT_IDENTIFIER, 'ldap' as SUBJECT_SOURCE_ID, CONCAT('ref:', role) as GROUP_NAME from HR_PEOPLE_ROLES");
