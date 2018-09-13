gs = GrouperSession.startRootSession();

addGroup("basis", "bypass", "bypass");
addComposite("app:mfa:ref:mfa_opt_in_access", CompositeType.COMPLEMENT, "basis:bypass", "ref:opt-in");
addGroup("ref", "bypass-not-opt-in", "bypass-not-opt-in");
addMember("app:mfa:mfa_enabled_deny", "ref:bypass-not-opt-in");