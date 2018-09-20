gs = GrouperSession.startRootSession();


addStem("ref", "dept", "dept");
addGroup("ref:dept", "Information Technology", "Information Technology");
addMember("app:mfa:mfa_enabled_allow", "ref:dept:Information Technology");

addGroup("app:mfa:ref", "mfa_bypass", "mfa_bypass");

addMember("app:mfa:mfa_enabled_deny", "app:mfa:ref:mfa_bypass");


addGroup("app:mfa:ref", "athletics_dept", "athletics_dept");
addMember("app:mfa:ref:athletics_dept","jdavis4");
addMember("app:mfa:ref:athletics_dept","ldavis5");
addMember("app:mfa:ref:athletics_dept","janderson13");
addMember("app:mfa:ref:athletics_dept","rdavis16");
addMember("app:mfa:ref:athletics_dept","cthompson28");
addMember("app:mfa:ref:athletics_dept","ahenderson36");
addMember("app:mfa:ref:athletics_dept","amorrison42");
addMember("app:mfa:ref:athletics_dept","pthompson61");
addMember("app:mfa:ref:athletics_dept","bsmith65");
addMember("app:mfa:ref:athletics_dept","jlangenberg100");
addMember("app:mfa:ref:athletics_dept","nscott103");
addMember("app:mfa:ref:athletics_dept","jprice108");
addMember("app:mfa:ref:athletics_dept","jvales117");
addMember("app:mfa:ref:athletics_dept","mmartinez133");
addMember("app:mfa:ref:athletics_dept","mgrady137");


addMember("app:mfa:mfa_enabled_allow", "app:mfa:ref:athletics_dept");
