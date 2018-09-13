gs = GrouperSession.startRootSession();

addGroup("app:mfa:ref", "BannerUsersMinusFaculty", "BannerUsersMinusFaculty");
addComposite("app:mfa:ref:BannerUsersMinusFaculty", CompositeType.COMPLEMENT, "app:mfa:ref:NonFacultyBannerINB", "ref:faculty");
addMember("app:mfa:mfa_enabled_allow", "app:mfa:ref:BannerUsersMinusFaculty")