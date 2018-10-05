gs = GrouperSession.startRootSession()

//ex201.3.1
addStem("app", "eduPersonAffiliation", "eduPersonAffiliation");
addGroup("app:eduPersonAffiliation", "ePA_student", "ePA_student");
addGroup("app:eduPersonAffiliation", "ePA_staff", "ePA_staff");
addGroup("app:eduPersonAffiliation", "ePA_alum", "ePA_alum");
addGroup("app:eduPersonAffiliation", "ePA_member", "ePA_member");
addGroup("app:eduPersonAffiliation", "ePA_affiliate", "ePA_affiliate");
addGroup("app:eduPersonAffiliation", "ePA_employee", "ePA_employee");
addGroup("app:eduPersonAffiliation", "ePA_library-walk-in", "ePA_library-walk-in");

//ex201.3.2
addMember("app:eduPersonAffiliation:ePA_student", "ref:student:students");

//ex201.3.3
addMember("app:eduPersonAffiliation:ePA_member", "app:eduPersonAffiliation:ePA_student");
addMember("app:eduPersonAffiliation:ePA_member", "app:eduPersonAffiliation:ePA_staff");
addMember("app:eduPersonAffiliation:ePA_member", "app:eduPersonAffiliation:ePA_alum");
addMember("app:eduPersonAffiliation:ePA_member", "app:eduPersonAffiliation:ePA_affiliate");
addMember("app:eduPersonAffiliation:ePA_member", "app:eduPersonAffiliation:ePA_employee");

//ex201.3.4

//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:eduPersonAffiliation:ePA_student");

# Auto create the PSPNG attributes
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_affiliations");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_affiliations");
attributeAssignSave.save();

//ex201.3.5
