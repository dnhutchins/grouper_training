gs = GrouperSession.startRootSession();


addStem("ref", "roles", "roles");
addGroup("ref:roles", "president_assistant", "president_assistant");

addMember("app:boardeffect:etc:boardeffect_mgr", "ref:roles:president_assistant")

addMember("ref:roles:president_assistant", "amartinez410");
delMember("app:boardeffect:etc:boardeffect_admins", "amartinez410");