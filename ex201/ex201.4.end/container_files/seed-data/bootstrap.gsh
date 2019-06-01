gs = GrouperSession.startRootSession()
delStem("201.4.1")
addRootStem("201.4.end", "201.4.end")

//ex201.4.1
addStem("app", "wiki", "wiki");
addStem("app:wiki", "service", "service");
addStem("app:wiki:service", "policy", "policy");

addGroup("app:wiki:service:policy", "wiki_user", "wiki_user");
addGroup("app:wiki:service:policy", "wiki_user_allow", "wiki_user_allow");
addGroup("app:wiki:service:policy", "wiki_user_deny",  "wiki_user_deny");
addComposite("app:wiki:service:policy:wiki_user", CompositeType.COMPLEMENT, "app:wiki:service:policy:wiki_user_allow", "app:wiki:service:policy:wiki_user_deny");

//ex201.4.2
addStem("app:wiki", "security", "security");
addGroup("app:wiki:security", "wikiAdmins", "wikiAdmins");
grantPriv("app:wiki:service", "app:wiki:security:wikiAdmins", NamingPrivilege.STEM)

//ex201.4.3
addMember("app:wiki:service:policy:wiki_user_allow", "ref:student:students");
addMember("app:wiki:service:policy:wiki_user_deny", "ref:iam:global_deny");

//ex201.4.4
//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:wiki:service:policy:wiki_user");

# Auto create the PSPNG attributes
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_entitlements");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_entitlements");
attributeAssignSave.save();


//ex201.4.5
//(nothing)

//ex201.4.6
//(nothing)