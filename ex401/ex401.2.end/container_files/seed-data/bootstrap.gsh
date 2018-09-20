gs = GrouperSession.startRootSession();

addMember("app:mfa:mfa_enabled_allow", "ref:faculty");
addMember("app:mfa:mfa_enabled_allow", "ref:staff");
addMember("app:mfa:mfa_enabled_allow", "ref:student");

delGroup("app:mfa:ref:pilot");
delGroup("app:mfa:ref:mfa_opt_in_access");
delGroup("app:mfa:ref:mfa_opt_in_access_allow");
delGroup("app:mfa:ref:mfa_opt_in_access_deny");
delGroup("app:mfa:ref:mfa_opt_in");
delGroup("app:mfa:ref:bypass-not-opt-in");
delGroup("app:mfa:ref:BannerUsersMinusFaculty");
delGroup("app:mfa:ref:NonFacultyBannerINB");
delGroup("app:mfa:ref:athletics_dept");