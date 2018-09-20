gs = GrouperSession.startRootSession();

addGroup("app:boardeffect", "wr_cmt_fin_authorized", "wr_cmt_fin_authorized");
addGroup("app:boardeffect", "wr_cmt_fin_allow", "wr_cmt_fin_allow");
addGroup("app:boardeffect", "wr_cmt_fin_deny", "wr_cmt_fin_deny");

addComposite("app:boardeffect:wr_cmt_fin_authorized", CompositeType.COMPLEMENT, "app:boardeffect:wr_cmt_fin_allow", "app:boardeffect:wr_cmt_fin_deny");
