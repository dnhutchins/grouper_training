gs = GrouperSession.startRootSession();

addStem("app", "vpn", "vpn");
addStem("app:vpn", "ref", "ref");

addGroup("app:vpn:ref", "vpn_adhoc", "vpn_adhoc");
addGroup("app:vpn", "vpn_authorized", "vpn_authorized");

addMember("app:vpn:vpn_authorized", "ref:faculty");
addMember("app:vpn:vpn_authorized", "ref:staff");
addMember("app:vpn:vpn_authorized", "ref:student");
addMember("app:vpn:vpn_authorized", "app:vpn:ref:vpn_adhoc");
