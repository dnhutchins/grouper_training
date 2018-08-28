gs = GrouperSession.startRootSession();

//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:mfa:mfa_enabled");

# Auto create the PSPNG attributes
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_groupOfNames");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
//pspngAttributeDef = AttributeDefFinder.findByName("etc:pspng:provision_to_def", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_entitlements");
attributeAssignSave.save();