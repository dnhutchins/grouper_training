gs = GrouperSession.startRootSession();

addStem("ref", "iam", "iam");
addGroup("ref:iam", "gobal_deny", "gobal_deny");

addGroup("app:vpn", "vpn_permit", "vpn_permit");
addGroup("app:vpn", "vpn_deny", "vpn_deny");
addMember("app:vpn:vpn_deny", "ref:iam:gobal_deny");

group=addGroup("app:vpn:ref", "vpn_ajohnson409", "vpn_ajohnson409");
group.setDescription("special project managed by ajohnson409");
group.store();
grantPriv("app:vpn:ref:vpn_ajohnson409", "ajohnson409", AccessPrivilege.ADMIN);

group=addGroup("app:vpn:ref", "vpn_consultants", "vpn_consultants");
group.setDescription("Consultants, must be approved by VP and have expiration date set");
group.store();

delGroup("app:vpn:vpn_authorized");
addGroup("app:vpn", "vpn_authorized", "vpn_authorized");
addComposite("app:vpn:vpn_authorized", CompositeType.COMPLEMENT, "app:vpn:vpn_permit", "app:vpn:vpn_deny");

addMember("app:vpn:vpn_permit", "ref:faculty");
addMember("app:vpn:vpn_permit", "ref:staff");
addMember("app:vpn:vpn_permit", "ref:student");
addMember("app:vpn:vpn_permit", "app:vpn:ref:vpn_adhoc");
addMember("app:vpn:vpn_permit", "app:vpn:ref:vpn_ajohnson409");
addMember("app:vpn:vpn_permit", "app:vpn:ref:vpn_consultants");


//Assign the PSPNG attribute for the standard groups
group = GroupFinder.findByName(gs, "app:vpn:ref:vpn_ajohnson409");

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


# Groovy Script - Auto set expiration date on membership:
numDays = 32;
actAs = SubjectFinder.findRootSubject();
vpn_adhoc = getGroups("app:vpn:ref:vpn_adhoc")[0];
attribAssign = vpn_adhoc.getAttributeDelegate().addAttribute(RuleUtils.ruleAttributeDefName()).getAttributeAssign();
attribValueDelegate = attribAssign.getAttributeValueDelegate();
attribValueDelegate.assignValue(RuleUtils.ruleActAsSubjectSourceIdName(), actAs.getSourceId());
attribValueDelegate.assignValue(RuleUtils.ruleRunDaemonName(), "F");
attribValueDelegate.assignValue(RuleUtils.ruleActAsSubjectIdName(), actAs.getId());
attribValueDelegate.assignValue(RuleUtils.ruleCheckTypeName(), RuleCheckType.membershipAdd.name());
attribValueDelegate.assignValue(RuleUtils.ruleIfConditionEnumName(), RuleIfConditionEnum.thisGroupHasImmediateEnabledNoEndDateMembership.name());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumName(), RuleThenEnum.assignMembershipDisabledDaysForOwnerGroupId.name());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumArg0Name(), numDays.toString());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumArg1Name(), "T");
