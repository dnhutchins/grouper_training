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


addStem("ref", "board", "board");

group = GroupFinder.findByName(gs, "app:boardeffect:ref:cmt_fin", true);
stem = StemFinder.findByName(gs, "ref:board", true);
group.move(stem);

addStem("ref:board", "etc", "etc");
group2 = addGroup("ref:board:etc", "board_managers", "board_managers");

addMember("ref:board:etc:board_managers", "ref:roles:president_assistant");

grantPriv("ref:board:cmt_fin", group2.toSubject().id, AccessPrivilege.UPDATE);
grantPriv("ref:board:cmt_fin", group2.toSubject().id, AccessPrivilege.READ);

boardeffect_admins = GroupFinder.findByName(gs, "app:boardeffect:etc:boardeffect_admins", true);
boardeffect_mgr = GroupFinder.findByName(gs, "app:boardeffect:etc:boardeffect_mgr", true);
boardeffect_viewers = GroupFinder.findByName(gs, "app:boardeffect:etc:boardeffect_viewers", true);

revokePriv("ref:board:cmt_fin", boardeffect_admins.toSubject().id, AccessPrivilege.ADMIN);
revokePriv("ref:board:cmt_fin", boardeffect_mgr.toSubject().id, AccessPrivilege.UPDATE);
revokePriv("ref:board:cmt_fin", boardeffect_mgr.toSubject().id, AccessPrivilege.READ);

revokePriv("ref:board:cmt_fin", boardeffect_viewers.toSubject().id, AccessPrivilege.READ);

