gs = GrouperSession.startRootSession();

addStem("app:mfa", "basis", "basis");
addGroup("app:mfa:basis", "bypass", "bypass");
addComposite("app:mfa:ref:mfa_opt_in_access", CompositeType.COMPLEMENT, "app:mfa:basis:bypass", "app:mfa:ref:opt-in");
addGroup("app:mfa:ref", "bypass-not-opt-in", "bypass-not-opt-in");
addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:bypass-not-opt-in");