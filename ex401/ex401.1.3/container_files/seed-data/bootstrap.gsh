gs = GrouperSession.startRootSession();

addStem("app", "vpn", "vpn");
addStem("app:vpn", "ref", "ref");

addGroup("app:vpn:ref", "vpn_adhoc", "vpn_adhoc");
addGroup("app:vpn", "vpn_authorized", "vpn_authorized");
addGroup("app:vpn", "vpn_allow", "vpn_allow");
addGroup("app:vpn", "vpn_deny", "vpn_deny");

addMember("app:vpn:vpn_allow", "ref:faculty");
addMember("app:vpn:vpn_allow", "ref:staff");
addMember("app:vpn:vpn_allow", "app:vpn:ref:vpn_adhoc");

addComposite("app:vpn:vpn_authorized", CompositeType.COMPLEMENT, "app:vpn:vpn_allow", "app:vpn:vpn_deny");
