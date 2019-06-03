gs = GrouperSession.startRootSession();

addStem("app", "vpn", "vpn");
addStem("app:vpn", "service", "service");
addStem("app:vpn", "security", "security");

addStem("app:vpn:service", "ref", "ref")
addStem("app:vpn:service", "policy", "policy")

addGroup("app:vpn:service:ref", "vpn_adhoc", "vpn_adhoc");
addGroup("app:vpn:service:policy", "vpn_authorized", "vpn_authorized");
addGroup("app:vpn:service:policy", "vpn_authorized_allow", "vpn_authorized_allow");
addGroup("app:vpn:service:policy", "vpn_authorized_deny", "vpn_authorized_deny");

addMember("app:vpn:service:policy:vpn_authorized_allow", "ref:faculty");
addMember("app:vpn:service:policy:vpn_authorized_allow", "ref:staff");
addMember("app:vpn:service:policy:vpn_authorized_allow", "app:vpn:service:ref:vpn_adhoc");

addComposite("app:vpn:service:policy:vpn_authorized", CompositeType.COMPLEMENT, "app:vpn:service:policy:vpn_authorized_allow", "app:vpn:service:policy:vpn_authorized_deny");
