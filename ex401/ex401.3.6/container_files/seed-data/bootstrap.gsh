gs = GrouperSession.startRootSession();

addGroup("app:boardeffect:ref", "cmt_fin_helpers", "cmt_fin_helpers");
addMember("app:boardeffect:wr_cmt_fin_allow", "app:boardeffect:ref:cmt_fin_helpers");


addGroup("app:boardeffect:ref", "workroom_helpers", "workroom_helpers");
addMember("app:boardeffect:wr_cmt_fin_allow", "app:boardeffect:ref:workroom_helpers")

# Script parameters
group_name = "app:boardeffect:ref:workroom_helpers";
numDays = 32;
 
actAs = SubjectFinder.findRootSubject();
vpn_adhoc = getGroups(group_name)[0];
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
