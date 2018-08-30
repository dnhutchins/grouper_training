gs = GrouperSession.startRootSession();

addStem("ref", "dept", "dept");
addGroup("ref:dept", "its", "its");

addGroup("app:mfa:ref", "mfa_bypass", "mfa_bypass");
addGroup("app:mfa:ref", "athletics", "athletics");

addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:mfa_bypass");
addMember("app:mfa:mfa_enabled_allow", "app:mfa:ref:athletics");