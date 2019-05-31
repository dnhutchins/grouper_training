gs = GrouperSession.startRootSession()
delStem("201.3.1")
addRootStem("201.3.end", "201.3.end")

//ex201.3.1
addStem("app", "eduPersonAffiliation", "eduPersonAffiliation");
addStem("app:eduPersonAffiliation", "service", "service");
addStem("app:eduPersonAffiliation:service", "policy", "policy");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_student", "ePA_student");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_staff", "ePA_staff");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_alum", "ePA_alum");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_member", "ePA_member");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_affiliate", "ePA_affiliate");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_employee", "ePA_employee");
addGroup("app:eduPersonAffiliation:service:policy", "ePA_library-walk-in", "ePA_library-walk-in");

//ex201.3.2
addMember("app:eduPersonAffiliation:service:policy:ePA_student", "ref:student:students");

//ex201.3.3
addMember("app:eduPersonAffiliation:service:policy:ePA_member", "app:eduPersonAffiliation:service:policy:ePA_student");
addMember("app:eduPersonAffiliation:service:policy:ePA_member", "app:eduPersonAffiliation:service:policy:ePA_staff");
addMember("app:eduPersonAffiliation:service:policy:ePA_member", "app:eduPersonAffiliation:service:policy:ePA_alum");
addMember("app:eduPersonAffiliation:service:policy:ePA_member", "app:eduPersonAffiliation:service:policy:ePA_affiliate");
addMember("app:eduPersonAffiliation:service:policy:ePA_member", "app:eduPersonAffiliation:service:policy:ePA_employee");

//ex201.3.4

//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:eduPersonAffiliation:service:policy:ePA_member");

# Auto create the PSPNG attributes
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_affiliations");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_affiliations");
attributeAssignSave.save();

//ex201.3.5
// nothing to do here