gs = GrouperSession.startRootSession()

//ex201.4.1
addStem("app", "wiki", "wiki");
addStem("app:wiki", "service", "service");
addStem("app:wiki:service", "policy", "policy");

addGroup("app:wiki:service:policy", "wiki_authorized", "wiki_authorized");
addGroup("app:wiki:service:policy", "wiki_authorized_allow", "wiki_authorized_allow");
addGroup("app:wiki:service:policy", "wiki_authorized_deny",  "wiki_authorized_deny");
addComposite("app:wiki:service:policy:wiki_authorized", CompositeType.COMPLEMENT, "app:wiki:service:policy:wiki_authorized_allow", "app:wiki:service:policy:wiki_authorized_deny");

//ex201.4.2
addStem("app:wiki", "security", "security");
addGroup("app:wiki:security", "wiki_admin", "wiki_admin");
grantPriv("app:wiki:service", "app:wiki:security:wiki_admin", NamingPrivilege.STEM)

//ex201.4.3
addMember("app:wiki:service:policy:wiki_authorized_allow", "ref:student:students");
addGroup("ref:iam", "global_deny", "global_deny");
addMember("app:wiki:service:policy:wiki_authorized_deny", "ref:iam:global_deny");

//ex201.4.4

//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:wiki:service:policy:wiki_authorized");

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