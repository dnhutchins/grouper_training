gs = GrouperSession.startRootSession();

addStem("app:boardeffect", "ref", "ref");
addGroup("app:boardeffect:ref", "cmt_fin", "cmt_fin");

addMember("app:boardeffect:wr_cmt_fin_allow", "app:boardeffect:ref:cmt_fin");
addMember("app:boardeffect:wr_cmt_fin_deny", "ref:iam:global_deny");

addMember("app:boardeffect:etc:boardeffect_admins", "amartinez410");
