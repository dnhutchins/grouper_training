gs = GrouperSession.startRootSession();

addGroup("app:boardeffect", "boardeffect_authorized", "boardeffect_authorized");
addGroup("app:boardeffect", "boardeffect_authorized_allow", "boardeffect_authorized_allow");
addGroup("app:boardeffect", "boardeffect_authorized_deny", "boardeffect_authorized_deny");

addComposite("app:boardeffect:boardeffect_authorized", CompositeType.COMPLEMENT, "app:boardeffect:boardeffect_authorized_allow", "app:boardeffect:boardeffect_authorized_deny");
