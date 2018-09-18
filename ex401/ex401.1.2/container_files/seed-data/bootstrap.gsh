gs = GrouperSession.startRootSession();

addStem("test", "vpn", "vpn");

//Create a loader job to pull in the VPN users assigned in the directory.
group = new GroupSave(gs).assignName("test:vpn:vpn_legacy").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=vpn_users)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=groups");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "member");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), "\${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}");

//Create placeholder groups for the load job so we can use them below
addGroup("ref", "faculty", "faculty");
addGroup("ref", "staff", "staff");
addGroup("ref", "student", "student");

//Create the groups that do the grouper math to analyze the tables.
addGroup("test:vpn", "vpn_faculty", "vpn_faculty");
addComposite("test:vpn:vpn_faculty", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:faculty");

addGroup("test:vpn", "vpn_employees", "vpn_employees");
addComposite("test:vpn:vpn_employees", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:staff");

addGroup("test:vpn", "vpn_students", "vpn_students");
addComposite("test:vpn:vpn_students", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:student");

addGroup("test:vpn", "vpn_facstaffstudent", "vpn_facstaffstudent");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_faculty");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_employees");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_students");

addGroup("test:vpn", "other_cohorts", "other_cohorts");
addComposite("test:vpn:other_cohorts", CompositeType.COMPLEMENT, "test:vpn:vpn_legacy", "test:vpn:vpn_facstaffstudent");
