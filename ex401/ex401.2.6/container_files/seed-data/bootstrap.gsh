gs = GrouperSession.startRootSession();

addGroup("app:mfa:ref", "NonFacultyBannerINB", "NonFacultyBannerINB");
addMember("app:mfa:mfa_enabled_allow", "app:mfa:ref:NonFacultyBannerINB");