gs = GrouperSession.startRootSession();

addStem("app:mfa", "basis", "basis");

group = GroupFinder.findByName(gs, "app:mfa:ref:mfa_bypass", true);
stem = StemFinder.findByName(gs, "app:mfa:basis", true);
group.move(stem);

addGroup("app:mfa:ref", "bypass-not-opt-in", "bypass-not-opt-in");
addComposite("app:mfa:ref:bypass-not-opt-in", CompositeType.COMPLEMENT, "app:mfa:basis:mfa_bypass", "app:mfa:ref:mfa_opt_in");

addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:bypass-not-opt-in");

