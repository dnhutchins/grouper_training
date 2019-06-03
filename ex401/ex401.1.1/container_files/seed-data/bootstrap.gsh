gs = GrouperSession.startRootSession();
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("bundle", "bundle");
addRootStem("app", "app");
addRootStem("org", "org");
addRootStem("test", "test");

//delStem("401.1.end")
addRootStem("401.4.1", "401.4.1")

addStem("ref", "iam", "iam");
addGroup("ref:iam", "global_deny", "global_deny");

group = addGroup("etc","rolesLoader", "Roles Loader");
groupAddType("etc:rolesLoader", "grouperLoader");
setGroupAttr("etc:rolesLoader", "grouperLoaderDbName", "grouper");
setGroupAttr("etc:rolesLoader", "grouperLoaderType", "SQL_GROUP_LIST");
setGroupAttr("etc:rolesLoader", "grouperLoaderScheduleType", "CRON");
setGroupAttr("etc:rolesLoader", "grouperLoaderQuartzCron", "0 * * * * ?");
setGroupAttr("etc:rolesLoader", "grouperLoaderQuery", "select distinct id as SUBJECT_IDENTIFIER, 'ldap' as SUBJECT_SOURCE_ID, CONCAT('ref:', role) as GROUP_NAME from HR_PEOPLE_ROLES");
loaderRunOneJob(group);

group = new GroupSave(gs).assignName("etc:deptLoader").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_GROUPS_FROM_ATTRIBUTES");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(businessCategory=*)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=People,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "uid");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupAttributeName(), "businessCategory");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), '${subjectAttributes["subjectId"]}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupNameExpressionName(), 'ref:dept:${groupAttribute}');
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapGroupDisplayNameExpressionName(), '${groupAttribute}');
loaderRunOneJob(group);
