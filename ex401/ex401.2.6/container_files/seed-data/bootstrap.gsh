gs = GrouperSession.startRootSession();

addGroup("app:mfa:ref", "NonFacultyBannerINB", "NonFacultyBannerINB");
addMember("app:mfa:ref:NonFacultyBannerINB","jprice108");
addMember("app:mfa:ref:NonFacultyBannerINB","mnielson143");
addMember("app:mfa:ref:NonFacultyBannerINB","mvales154");
addMember("app:mfa:ref:NonFacultyBannerINB","wclark159");
addMember("app:mfa:ref:NonFacultyBannerINB","kthompson169");
addMember("app:mfa:ref:NonFacultyBannerINB","athompson183");
addMember("app:mfa:ref:NonFacultyBannerINB","sanderson191");
addMember("app:mfa:ref:NonFacultyBannerINB","jlangenberg194");
addMember("app:mfa:ref:NonFacultyBannerINB","jwhite222");
addMember("app:mfa:ref:NonFacultyBannerINB","rwilliams230");
addMember("app:mfa:ref:NonFacultyBannerINB","pwilliams242");
addMember("app:mfa:ref:NonFacultyBannerINB","lprice328");
addMember("app:mfa:ref:NonFacultyBannerINB","dgrady331");
addMember("app:mfa:ref:NonFacultyBannerINB","edoe348");
addMember("app:mfa:ref:NonFacultyBannerINB","svales366");
addMember("app:mfa:ref:NonFacultyBannerINB","mhenderson377");
addMember("app:mfa:ref:NonFacultyBannerINB","mlewis390");
addMember("app:mfa:ref:NonFacultyBannerINB","mroberts391");
addMember("app:mfa:ref:NonFacultyBannerINB","llopez398");
addMember("app:mfa:ref:NonFacultyBannerINB","amorrison406");
addMember("app:mfa:ref:NonFacultyBannerINB","janderson459");
addMember("app:mfa:ref:NonFacultyBannerINB","wmartinez487");
addMember("app:mfa:ref:NonFacultyBannerINB","lvales502");
addMember("app:mfa:ref:NonFacultyBannerINB","cvales514");
addMember("app:mfa:ref:NonFacultyBannerINB","jprice523");
addMember("app:mfa:ref:NonFacultyBannerINB","rvales544");
addMember("app:mfa:ref:NonFacultyBannerINB","iprice563");
addMember("app:mfa:ref:NonFacultyBannerINB","bmartinez592");
addMember("app:mfa:ref:NonFacultyBannerINB","jnielson598");
addMember("app:mfa:ref:NonFacultyBannerINB","amartinez605");
addMember("app:mfa:ref:NonFacultyBannerINB","dprice607");
addMember("app:mfa:ref:NonFacultyBannerINB","mbutler632");
addMember("app:mfa:ref:NonFacultyBannerINB","lbutler643");
addMember("app:mfa:ref:NonFacultyBannerINB","dmartinez657");


//Set expiration out 30 days
java.util.Calendar cal = Calendar.getInstance();
cal.setTime(new Date());
cal.add(Calendar.DAY_OF_YEAR, 30);

group = GroupFinder.findByName(gs, "app:mfa:mfa_enabled_allow", true);
subject = GroupFinder.findByName(gs, "app:mfa:ref:NonFacultyBannerINB", true).toSubject();
group.addOrEditMember(subject, true, true, cal.getTime(), null, false);
