gs = GrouperSession.startRootSession();

addGroup("app:boardeffect", "boardeffect_authorized", "boardeffect_authorized");
addGroup("app:boardeffect", "boardeffect_authorized_allow", "boardeffect_authorized_allow");
addGroup("app:boardeffect", "boardeffect_authorized_deny", "boardeffect_authorized_deny");
addComposite("app:boardeffect:boardeffect_authorized", CompositeType.COMPLEMENT, "app:boardeffect:boardeffect_authorized_allow", "app:boardeffect:boardeffect_authorized_deny");

addMember("app:boardeffect:boardeffect_authorized_allow", "app:boardeffect:wr_cmt_fin_authorized");

//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:boardeffect:boardeffect_authorized");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
//pspngAttributeDef = AttributeDefFinder.findByName("etc:pspng:provision_to_def", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_entitlements");
attributeAssignSave.save();
