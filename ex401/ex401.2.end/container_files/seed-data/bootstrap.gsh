gs = GrouperSession.startRootSession();

addMember("app:mfa:mfa_enabled_allow", "ref:faculty");
addMember("app:mfa:mfa_enabled_allow", "ref:staff");
addMember("app:mfa:mfa_enabled_allow", "ref:student");
