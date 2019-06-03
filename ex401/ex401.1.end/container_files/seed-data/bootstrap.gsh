gs = GrouperSession.startRootSession();
delStem("401.1.1")
addRootStem("401.4.end", "401.4.end")

// 401.1.1
addStem("test", "vpn", "vpn");

//Create a loader job to pull in the VPN users assigned in the directory.
group = new GroupSave(gs).assignName("test:vpn:vpn_legacy").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=vpn_users)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=groups,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "member");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), "\${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}");
loaderRunOneJob(group);

//Create the groups that do the grouper math to analyze the tables.
addGroup("test:vpn", "vpn_faculty", "vpn_faculty");
addComposite("test:vpn:vpn_faculty", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:faculty");
addGroup("test:vpn", "vpn_staff", "vpn_staff");
addComposite("test:vpn:vpn_staff", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:staff");
addGroup("test:vpn", "vpn_students", "vpn_students");
addComposite("test:vpn:vpn_students", CompositeType.INTERSECTION, "test:vpn:vpn_legacy", "ref:student");
addGroup("test:vpn", "vpn_facstaffstudent", "vpn_facstaffstudent");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_faculty");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_staff");
addMember("test:vpn:vpn_facstaffstudent", "test:vpn:vpn_students");
addGroup("test:vpn", "other_cohorts", "other_cohorts");
addComposite("test:vpn:other_cohorts", CompositeType.COMPLEMENT, "test:vpn:vpn_legacy", "test:vpn:vpn_facstaffstudent");

// 401.1.2
addStem("app", "vpn", "vpn");
addStem("app:vpn", "service", "service");
addStem("app:vpn", "security", "security");
addStem("app:vpn:service", "ref", "ref")
addStem("app:vpn:service", "policy", "policy")

addGroup("app:vpn:service:ref", "vpn_adhoc", "vpn_adhoc");
vpn_authorized = addGroup("app:vpn:service:policy", "vpn_authorized", "vpn_authorized");
addGroup("app:vpn:service:policy", "vpn_authorized_allow", "vpn_authorized_allow");
addGroup("app:vpn:service:policy", "vpn_authorized_deny", "vpn_authorized_deny");

addMember("app:vpn:service:policy:vpn_authorized_allow", "ref:faculty");
addMember("app:vpn:service:policy:vpn_authorized_allow", "ref:staff");
addMember("app:vpn:service:policy:vpn_authorized_allow", "app:vpn:service:ref:vpn_adhoc");

addComposite("app:vpn:service:policy:vpn_authorized", CompositeType.COMPLEMENT, "app:vpn:service:policy:vpn_authorized_allow", "app:vpn:service:policy:vpn_authorized_deny");

// 401.1.3
// Auto create the PSPNG attributes
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_groupOfNames");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(vpn_authorized);
attributeAssignSave.addValue("pspng_groupOfNames");
attributeAssignSave.save();

// 401.1.4
group=addGroup("app:vpn:service:ref", "vpn_consultants", "vpn_consultants");
group.setDescription("Consultants, must be approved by VP and have expiration date set");
group.store();

group=addGroup("app:vpn:service:ref", "vpn_ajohnson409", "vpn_ajohnson409");
group.setDescription("Special project managed by ajohnson409");
group.store();

addGroup("app:vpn:security", "vpn_ajohnson409_mgr", "vpn_ajohnson409_mgr");
grantPriv("app:vpn:service:ref:vpn_ajohnson409", "app:vpn:security:vpn_ajohnson409_mgr", AccessPrivilege.UPDATE);
grantPriv("app:vpn:service:ref:vpn_ajohnson409", "app:vpn:security:vpn_ajohnson409_mgr", AccessPrivilege.READ);
addMember("app:vpn:security:vpn_ajohnson409_mgr", "ajohnson409")

GrouperSession.start(findSubject("ajohnson409"))
addMember("app:vpn:service:ref:vpn_ajohnson409", "bsmith458")




addGroup("test", "cisoQuestionableVpnUsersList", "CISO VPN Questionable VPN List");
addMember("test:cisoQuestionableVpnUsersList","ahenderson36");
addMember("test:cisoQuestionableVpnUsersList","cpeterson37");
addMember("test:cisoQuestionableVpnUsersList","jclark39");
addMember("test:cisoQuestionableVpnUsersList","kbrown62");
addMember("test:cisoQuestionableVpnUsersList","tpeterson63");
addMember("test:cisoQuestionableVpnUsersList","pjohnson64");
addMember("test:cisoQuestionableVpnUsersList","aroberts95");
addMember("test:cisoQuestionableVpnUsersList","sdavis107");
addMember("test:cisoQuestionableVpnUsersList","mhenderson109");
addMember("test:cisoQuestionableVpnUsersList","jvales117");
addMember("test:cisoQuestionableVpnUsersList","sgrady139");
addMember("test:cisoQuestionableVpnUsersList","mprice142");
addMember("test:cisoQuestionableVpnUsersList","mwilliams144");
addMember("test:cisoQuestionableVpnUsersList","lpeterson153");
addMember("test:cisoQuestionableVpnUsersList","mvales154");

addGroup("test", "whyvpnaccess", "Why Do They Have VPN Access");
addComposite("test:whyvpnaccess", CompositeType.INTERSECTION, "app:vpn:vpn_authorized", "test:cisoQuestionableVpnUsersList");

