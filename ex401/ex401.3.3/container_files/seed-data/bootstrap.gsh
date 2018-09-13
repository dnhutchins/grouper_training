gs = GrouperSession.startRootSession();

addStem("app", "boardeffect", "boardeffect");
addGroup("app:boardeffect", "cmt_fin_authorized", "cmt_fin_authorized");
addGroup("app:boardeffect", "cmt_fin_allow", "cmt_fin_allow");
addGroup("app:boardeffect", "cmt_fin_deny", "cmt_fin_deny");

addComposite("app:boardeffect:cmt_fin_authorized", CompositeType.COMPLEMENT, "app:boardeffect:cmt_fin_allow", "app:boardeffect:cmt_fin_deny");
