gs = GrouperSession.startRootSession()

//ex201.5.1
addStem("app", "cognos", "cognos");
addStem("app:cognos", "service", "service");
addStem("app:cognos:service" , "security", "security");
addGroup("app:cognos:service:security", "cg_adv_manager", "cg_adv_manager");

addStem("app:cognos:service", "ref", "ref");
addStem("app:cognos:service", "policy", "policy");

addGroup("app:cognos:service:policy", "cg_adv_report_reader", "cg_adv_report_reader");
addGroup("app:cognos:service:policy", "cg_adv_report_reader_allow", "cg_adv_report_reader_allow");
addGroup("app:cognos:service:policy", "cg_adv_report_reader_deny", "cg_adv_report_reader_deny");

addGroup("app:cognos:service:policy", "cg_adv_report_writer", "cg_adv_report_writer");
addGroup("app:cognos:service:policy", "cg_adv_report_writer_allow", "cg_adv_report_writer_allow");
addGroup("app:cognos:service:policy", "cg_adv_report_writer_deny", "cg_adv_report_writer_deny");

//ex201.5.2
addStem("ref", "dept", "dept");
addGroup("ref:dept", "advancement", "advancement");
addMember("app:cognos:service:policy:cg_adv_report_writer_allow", "ref:dept:advancement");

//ex201.5.3
group = addGroup("app:cognos:service:ref", "advancement_report_writer", "advancement_report_writer");
addMember("app:cognos:service:policy:cg_adv_report_writer_allow", "app:cognos:service:ref:advancement_report_writer");
grantPriv("app:cognos:service:security:cg_adv_manager", "app:cognos:service:policy:cg_adv_report_writer_allow", AccessPrivilege.READ);
grantPriv("app:cognos:service:security:cg_adv_manager", "app:cognos:service:policy:cg_adv_report_writer_allow", AccessPrivilege.UPDATE);

//ex201.5.4
attribute = AttributeDefNameFinder.findByName("etc:attribute:attestation:attestation", true);
attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(attribute);
attributeAssignSave.assignOwnerGroup(group);

attributeAssignOnAssignSave = new AttributeAssignSave(gs);
attributeAssignOnAssignSave.assignAttributeAssignType(AttributeAssignType.group_asgn);
attestationSendEmailAttributeDefName = AttributeDefNameFinder.findByName("etc:attribute:attestation:attestationSendEmail", false);
attributeAssignOnAssignSave.assignAttributeDefName(attestationSendEmailAttributeDefName);
attributeAssignOnAssignSave.addValue("true");
attributeAssignSave.addAttributeAssignOnThisAssignment(attributeAssignOnAssignSave);

attributeAssignOnAssignSave = new AttributeAssignSave(gs);
attributeAssignOnAssignSave.assignAttributeAssignType(AttributeAssignType.group_asgn);
attributeDefName = AttributeDefNameFinder.findByName("etc:attribute:attestation:attestationDirectAssignment", false);
attributeAssignOnAssignSave.assignAttributeDefName(attributeDefName);
attributeAssignOnAssignSave.addValue("true");
attributeAssignSave.addAttributeAssignOnThisAssignment(attributeAssignOnAssignSave);

attributeAssign = attributeAssignSave.save();
