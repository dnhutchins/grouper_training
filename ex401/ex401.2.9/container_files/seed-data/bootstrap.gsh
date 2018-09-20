gs = GrouperSession.startRootSession();

addStem("app:mfa", "basis", "basis");
addGroup("app:mfa:basis", "bypass", "bypass");
addGroup("app:mfa:ref", "bypass-not-opt-in", "bypass-not-opt-in");
addComposite("app:mfa:ref:bypass-not-opt-in", CompositeType.COMPLEMENT, "app:mfa:basis:bypass", "app:mfa:ref:mfa_opt_in");

addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:bypass-not-opt-in");