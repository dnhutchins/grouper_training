gs = GrouperSession.startRootSession();

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

