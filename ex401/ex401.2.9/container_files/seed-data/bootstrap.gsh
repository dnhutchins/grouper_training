gs = GrouperSession.startRootSession();

addStem("app:mfa", "basis", "basis");

group = GroupFinder.findByName(gs, "app:mfa:ref:mfa_bypass", true);
stem = StemFinder.findByName(gs, "app:mfa:basis", true);
group.move(stem);

addGroup("app:mfa:ref", "mfa_bypass_not_opt_in", "mfa_bypass_not_opt_in");
addComposite("app:mfa:ref:mfa_bypass_not_opt_in", CompositeType.COMPLEMENT, "app:mfa:basis:mfa_bypass", "app:mfa:ref:mfa_opt_in");

addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:mfa_bypass_not_opt_in");
