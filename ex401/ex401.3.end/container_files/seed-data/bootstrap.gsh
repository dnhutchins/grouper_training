gs = GrouperSession.startRootSession();
delStem("401.3.1")
addRootStem("401.3.end", "401.3.end")

// 401.3.1
parent_stem_path = "app";
app_extension = "board_effect";
app_name = "board_effect";

stem = addStem(parent_stem_path, app_extension, app_name);
security = addStem(stem.name, "security", "security");
service = addStem(stem.name, "service", "service");
policy = addStem(service.name, "policy", "policy");
ref = addStem(service.name, "ref", "ref");

admin_group_name = "${app_extension}Admins";
admin_group = addGroup(security.name, admin_group_name, admin_group_name);
mgr_group_name = "${app_extension}Updaters";
mgr_group = addGroup(security.name, mgr_group_name, mgr_group_name);
view_group_name = "${app_extension}Readers";
view_group = addGroup(security.name, view_group_name, view_group_name);

addGroup("app:board_effect:service:policy", "board_effect_access", "board_effect_access");
addGroup("app:board_effect:service:policy", "board_effect_access_allow", "board_effect_access_allow");
addGroup("app:board_effect:service:policy", "board_effect_access_deny", "board_effect_access_deny");
addComposite("app:board_effect:service:policy:board_effect_access", CompositeType.COMPLEMENT, "app:board_effect:service:policy:board_effect_access_allow", "app:board_effect:service:policy:board_effect_access_deny");

// 401.3.2
addGroup("app:board_effect:service:policy", "workroom_finance", "workroom_finance");
addGroup("app:board_effect:service:policy", "workroom_finance_allow", "workroom_finance_allow");
addGroup("app:board_effect:service:policy", "workroom_finance_deny", "workroom_finance_deny");
addComposite("app:board_effect:service:policy:workroom_finance", CompositeType.COMPLEMENT, "app:board_effect:service:policy:workroom_finance_allow", "app:board_effect:service:policy:workroom_finance_deny");
addMember("app:board_effect:service:policy:board_effect_access_allow", "app:board_effect:service:policy:workroom_finance");

// 401.3.3 nothing to do
// 401.3.4 nothing to do

// 401.3.5
addGroup("app:board_effect:service:ref", "finance_committee", "finance_committee");
grantPriv("app:board_effect:service:ref:finance_committee", "app:board_effect:security:board_effectAdmins",  AccessPrivilege.ADMIN);
addMember("app:board_effect:service:policy:workroom_finance_allow", "app:board_effect:service:ref:finance_committee");
addMember("app:board_effect:security:board_effectAdmins", "amartinez410");

GrouperSession.start(findSubject("amartinez410"))
addMember("app:board_effect:service:ref:finance_committee", "ksmith3")
gs = GrouperSession.startRootSession();

// 401.3.6
addGroup("app:board_effect:service:ref", "finance_committee_helpers", "finance_committee_helpers");
addMember("app:board_effect:service:policy:workroom_finance_allow", "app:board_effect:service:ref:finance_committee_helpers");
addGroup("app:board_effect:service:ref", "workroom_helpers", "workroom_helpers");
addMember("app:board_effect:service:policy:workroom_finance_allow", "app:board_effect:service:ref:workroom_helpers");

group_name = "app:board_effect:service:ref:workroom_helpers";
workroom_helpers = GroupFinder.findByName(gs, group_name);
numDays = 3;
actAs = SubjectFinder.findRootSubject();
attribAssign = workroom_helpers.getAttributeDelegate().addAttribute(RuleUtils.ruleAttributeDefName()).getAttributeAssign();
attribValueDelegate = attribAssign.getAttributeValueDelegate();
attribValueDelegate.assignValue(RuleUtils.ruleActAsSubjectSourceIdName(), actAs.getSourceId());
attribValueDelegate.assignValue(RuleUtils.ruleRunDaemonName(), "F");
attribValueDelegate.assignValue(RuleUtils.ruleActAsSubjectIdName(), actAs.getId());
attribValueDelegate.assignValue(RuleUtils.ruleCheckTypeName(), RuleCheckType.membershipAdd.name());
attribValueDelegate.assignValue(RuleUtils.ruleIfConditionEnumName(), RuleIfConditionEnum.thisGroupHasImmediateEnabledNoEndDateMembership.name());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumName(), RuleThenEnum.assignMembershipDisabledDaysForOwnerGroupId.name());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumArg0Name(), numDays.toString());
attribValueDelegate.assignValue(RuleUtils.ruleThenEnumArg1Name(), "T");

// 401.3.7
addStem("ref", "role", "role");
addGroup("ref:role", "president_assistant", "president_assistant");
addMember("ref:role:president_assistant", "amartinez410");
addMember("app:board_effect:security:board_effectUpdaters", "ref:role:president_assistant");
delMember("app:board_effect:security:board_effectAdmins", "amartinez410");

// 401.3.8
addStem("ref", "board", "board");
group = GroupFinder.findByName(gs, "app:board_effect:service:ref:finance_committee", true);
stem = StemFinder.findByName(gs, "ref:board", true);
group.move(stem);

addStem("ref:board", "security", "security");
group2 = addGroup("ref:board:security", "boardUpdaters", "boardUpdaters");
grantPriv("ref:board:finance_committee", group2.toSubject().id, AccessPrivilege.UPDATE);
grantPriv("ref:board:finance_committee", group2.toSubject().id, AccessPrivilege.READ);
addMember("ref:board:security:boardUpdaters", "ref:role:president_assistant");

boardeffectAdmins = GroupFinder.findByName(gs, "app:board_effect:security:board_effectAdmins", true);
boardeffectUpdaters = GroupFinder.findByName(gs, "app:board_effect:security:board_effectUpdaters", true);

revokePriv("ref:board:finance_committee", boardeffectAdmins.toSubject().id, AccessPrivilege.ADMIN);
revokePriv("ref:board:finance_committee", boardeffectUpdaters.toSubject().id, AccessPrivilege.UPDATE);
revokePriv("ref:board:finance_committee", boardeffectUpdaters.toSubject().id, AccessPrivilege.READ);

