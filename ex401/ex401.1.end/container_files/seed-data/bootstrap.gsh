gs = GrouperSession.startRootSession();

addGroup("test", "cisoQuestionableVpnUsersList", "CISO VPN Questionable VPN List");
addMember("test:cisoQuestionableVpnUsersList","ahenderson36");
addMember("test:cisoQuestionableVpnUsersList","cpeterson37");
addMember("test:cisoQuestionableVpnUsersList","jclark39");
addMember("test:cisoQuestionableVpnUsersList","kbrown62");
addMember("test:cisoQuestionableVpnUsersList","tpeterson63");
addMember("test:cisoQuestionableVpnUsersList","pjohnson64");
addMember("test:cisoQuestionableVpnUsersList","aroberts95");
addMember("test:cisoQuestionableVpnUsersList","sdavis107");
addMember("test:cisoQuestionableVpnUsersList","mhenderson109");
addMember("test:cisoQuestionableVpnUsersList","jvales117");
addMember("test:cisoQuestionableVpnUsersList","sgrady139");
addMember("test:cisoQuestionableVpnUsersList","mprice142");
addMember("test:cisoQuestionableVpnUsersList","mwilliams144");
addMember("test:cisoQuestionableVpnUsersList","lpeterson153");
addMember("test:cisoQuestionableVpnUsersList","mvales154");

addGroup("test", "whyvpnaccess", "Why Do They Have VPN Access");
addComposite("test:whyvpnaccess", CompositeType.INTERSECTION, "app:vpn:vpn_authorized", "test:cisoQuestionableVpnUsersList");

