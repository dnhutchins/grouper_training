gs = GrouperSession.startRootSession()
delStem("201.5.1")
addRootStem("201.5.end", "201.5.end")

//ex201.5.1
addStem("app", "cognos", "cognos");
addStem("app:cognos" , "security", "security");
addStem("app:cognos", "service", "service");
addStem("app:cognos:service", "ref", "ref");
addStem("app:cognos:service", "policy", "policy");

addGroup("app:cognos:service:policy", "cg_fin_report_reader", "cg_fin_report_reader");
addGroup("app:cognos:service:policy", "cg_fin_report_reader_allow", "cg_fin_report_reader_allow");
addGroup("app:cognos:service:policy", "cg_fin_report_reader_deny", "cg_fin_report_reader_deny");
addComposite("app:cognos:service:policy:cg_fin_report_reader", CompositeType.COMPLEMENT, "app:cognos:service:policy:cg_fin_report_reader_allow", "app:cognos:service:policy:cg_fin_report_reader_deny")

addGroup("app:cognos:service:policy", "cg_fin_report_writer", "cg_fin_report_writer");
addGroup("app:cognos:service:policy", "cg_fin_report_writer_allow", "cg_fin_report_writer_allow");
addGroup("app:cognos:service:policy", "cg_fin_report_writer_deny", "cg_fin_report_writer_deny");
addComposite("app:cognos:service:policy:cg_fin_report_writer", CompositeType.COMPLEMENT, "app:cognos:service:policy:cg_fin_report_writer_allow", "app:cognos:service:policy:cg_fin_report_writer_deny")

//ex201.5.2 part 1
addMember("app:cognos:service:policy:cg_fin_report_reader_allow", "ref:dept:finance");

//ex201.5.2 part 2
finance_report_writer = addGroup("app:cognos:service:ref", "finance_report_writer", "finance_report_writer")
addMember("app:cognos:service:policy:cg_fin_report_writer_allow", "app:cognos:service:ref:finance_report_writer");
addStem("ref", "role", "role")
addGroup("ref:role", "Finance Manager", "Finance Manager")
grantPriv("app:cognos:service:ref:finance_report_writer", "ref:role:Finance Manager", AccessPrivilege.READ)
grantPriv("app:cognos:service:ref:finance_report_writer", "ref:role:Finance Manager", AccessPrivilege.UPDATE)
addMember("ref:role:Finance Manager", "asmith989")


//ex201.5.4
// add attestation to finance_report_writer
attribute = AttributeDefNameFinder.findByName("etc:attribute:attestation:attestation", true);
attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(attribute);
attributeAssignSave.assignOwnerGroup(finance_report_writer);

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

// 201.5.4 step 6
GrouperSession.start(findSubject("asmith989"))
addMember("app:cognos:service:ref:finance_report_writer", "bthompson392")
