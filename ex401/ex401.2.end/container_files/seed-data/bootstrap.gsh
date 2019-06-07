gs = GrouperSession.startRootSession();
delStem("401.2.1")
addRootStem("401.2.end", "401.2.end")

// 401.2.1
addStem("app", "mfa", "mfa");
addStem("app:mfa", "security", "security");
addStem("app:mfa", "service", "service");
addStem("app:mfa:service", "policy", "policy");
addStem("app:mfa:service", "ref", "ref");
mfa_enabled = addGroup("app:mfa:service:policy", "mfa_enabled", "mfa_enabled");
addGroup("app:mfa:service:policy", "mfa_enabled_allow", "mfa_enabled_allow");
addGroup("app:mfa:service:policy", "mfa_enabled_deny", "mf_enabled_deny");
addComposite("app:mfa:service:policy:mfa_enabled", CompositeType.COMPLEMENT, "app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:policy:mfa_enabled_deny");
addGroup("app:mfa:service:ref", "mfa_pilot", "mfa_pilot");
addMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:mfa_pilot");

// 401.2.2
// Assign PSPNG `provision_to` attribute to `mfa_enabled` with a value of `pspng_entitlements`.
edu.internet2.middleware.grouper.pspng.FullSyncProvisionerFactory.getFullSyncer("pspng_entitlements");
pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(mfa_enabled);
attributeAssignSave.addValue("pspng_entitlements");
attributeAssignSave.save();
addMember("app:mfa:service:ref:mfa_pilot", "banderson");

// 401.2.3
// nothing to do. idp already configured

// 401.2.4
// stub out ref groups for load jobs
addStem("ref", "dept", "dept");
addGroup("ref:dept", "Information Technology", "Information Technology");
addGroup("app:mfa:service:ref", "mfa_bypass", "mfa_bypass");
addMember("app:mfa:service:policy:mfa_enabled_deny", "app:mfa:service:ref:mfa_bypass");
addMember("app:mfa:service:policy:mfa_enabled_allow", "ref:dept:Information Technology");

mfa_athletics = addGroup("app:mfa:service:ref", "mfa_athletics", "mfa_athletics");
mfa_athletics.addMember(findSubject("ahenderson36"));
mfa_athletics.addMember(findSubject("amorrison42"));
mfa_athletics.addMember(findSubject("bsmith65"));
mfa_athletics.addMember(findSubject("cthompson28"));
mfa_athletics.addMember(findSubject("janderson13"));
mfa_athletics.addMember(findSubject("jdavis4"));
mfa_athletics.addMember(findSubject("jlangenberg100"));
mfa_athletics.addMember(findSubject("jprice108"));
mfa_athletics.addMember(findSubject("jvales117"));
mfa_athletics.addMember(findSubject("ldavis5"));
mfa_athletics.addMember(findSubject("mgrady137"));
mfa_athletics.addMember(findSubject("mmartinez133"));
mfa_athletics.addMember(findSubject("nscott103"));
mfa_athletics.addMember(findSubject("pthompson61"));
mfa_athletics.addMember(findSubject("rdavis16"));
addMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:mfa_athletics");

// 401.2.5
addGroup("app:mfa:service:ref", "NonFacultyBannerINB", "NonFacultyBannerINB");
addMember("app:mfa:service:ref:NonFacultyBannerINB","jprice108");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mnielson143");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mvales154");
addMember("app:mfa:service:ref:NonFacultyBannerINB","wclark159");
addMember("app:mfa:service:ref:NonFacultyBannerINB","kthompson169");
addMember("app:mfa:service:ref:NonFacultyBannerINB","athompson183");
addMember("app:mfa:service:ref:NonFacultyBannerINB","sanderson191");
addMember("app:mfa:service:ref:NonFacultyBannerINB","jlangenberg194");
addMember("app:mfa:service:ref:NonFacultyBannerINB","jwhite222");
addMember("app:mfa:service:ref:NonFacultyBannerINB","rwilliams230");
addMember("app:mfa:service:ref:NonFacultyBannerINB","pwilliams242");
addMember("app:mfa:service:ref:NonFacultyBannerINB","lprice328");
addMember("app:mfa:service:ref:NonFacultyBannerINB","dgrady331");
addMember("app:mfa:service:ref:NonFacultyBannerINB","edoe348");
addMember("app:mfa:service:ref:NonFacultyBannerINB","svales366");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mhenderson377");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mlewis390");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mroberts391");
addMember("app:mfa:service:ref:NonFacultyBannerINB","llopez398");
addMember("app:mfa:service:ref:NonFacultyBannerINB","amorrison406");
addMember("app:mfa:service:ref:NonFacultyBannerINB","janderson459");
addMember("app:mfa:service:ref:NonFacultyBannerINB","wmartinez487");
addMember("app:mfa:service:ref:NonFacultyBannerINB","lvales502");
addMember("app:mfa:service:ref:NonFacultyBannerINB","cvales514");
addMember("app:mfa:service:ref:NonFacultyBannerINB","jprice523");
addMember("app:mfa:service:ref:NonFacultyBannerINB","rvales544");
addMember("app:mfa:service:ref:NonFacultyBannerINB","iprice563");
addMember("app:mfa:service:ref:NonFacultyBannerINB","bmartinez592");
addMember("app:mfa:service:ref:NonFacultyBannerINB","jnielson598");
addMember("app:mfa:service:ref:NonFacultyBannerINB","amartinez605");
addMember("app:mfa:service:ref:NonFacultyBannerINB","dprice607");
addMember("app:mfa:service:ref:NonFacultyBannerINB","mbutler632");
addMember("app:mfa:service:ref:NonFacultyBannerINB","lbutler643");
addMember("app:mfa:service:ref:NonFacultyBannerINB","dmartinez657");

addMember("app:mfa:service:policy:mfa_enabled_allow","app:mfa:service:ref:NonFacultyBannerINB");
//Set start date 2 days out
java.util.Calendar cal = Calendar.getInstance();
cal.setTime(new Date());
cal.add(Calendar.DAY_OF_YEAR, 2);
group = GroupFinder.findByName(gs, "app:mfa:service:policy:mfa_enabled_allow", true);
subject = GroupFinder.findByName(gs, "app:mfa:service:ref:NonFacultyBannerINB", true).toSubject();
group.addOrEditMember(subject, true, true, cal.getTime(), null, false);

// 401.2.6
addGroup("app:mfa:service:ref", "BannerUsersMinusFaculty", "BannerUsersMinusFaculty");
addComposite("app:mfa:service:ref:BannerUsersMinusFaculty", CompositeType.COMPLEMENT, "app:mfa:service:ref:NonFacultyBannerINB", "ref:faculty");
addMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:BannerUsersMinusFaculty")
delMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:NonFacultyBannerINB");

// 401.2.7
addGroup("app:mfa:service:ref", "mfa_opt_in", "mfa_opt_in");

addGroup("app:mfa:security", "mfa_opt_in", "mfa_opt_in");
addGroup("app:mfa:security", "mfa_opt_in_allow", "mfa_opt_in_allow");
addGroup("app:mfa:security", "mfa_opt_in_deny", "mfa_opt_in_deny");
addComposite("app:mfa:security:mfa_opt_in", CompositeType.COMPLEMENT, "app:mfa:security:mfa_opt_in_allow", "app:mfa:security:mfa_opt_in_deny");

grantPriv("app:mfa:service:ref:mfa_opt_in", "app:mfa:security:mfa_opt_in", AccessPrivilege.OPTIN);
grantPriv("app:mfa:service:ref:mfa_opt_in", "app:mfa:security:mfa_opt_in", AccessPrivilege.OPTOUT);

addGroup("app:mfa:service:ref", "mfa_required", "mfa_required");
addMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:mfa_required");

addMember("app:mfa:service:ref:mfa_required", "app:mfa:service:ref:BannerUsersMinusFaculty");
addMember("app:mfa:service:ref:mfa_required", "ref:dept:Information Technology");
addMember("app:mfa:service:ref:mfa_required", "app:mfa:service:ref:mfa_athletics");
addMember("app:mfa:service:ref:mfa_required", "app:mfa:service:ref:mfa_pilot");

delMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:BannerUsersMinusFaculty");
delMember("app:mfa:service:policy:mfa_enabled_allow", "ref:dept:Information Technology");
delMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:mfa_athletics");
delMember("app:mfa:service:policy:mfa_enabled_allow", "app:mfa:service:ref:mfa_pilot");

addMember("app:mfa:security:mfa_opt_in_deny", "app:mfa:service:ref:mfa_required");

addMember("app:mfa:security:mfa_opt_in_allow", "ref:faculty");
addMember("app:mfa:security:mfa_opt_in_allow", "ref:staff");
addMember("app:mfa:security:mfa_opt_in_allow", "ref:student");


// 401.2.8
addMember("app:mfa:service:policy:mfa_enabled_allow", "ref:faculty");
addMember("app:mfa:service:policy:mfa_enabled_allow", "ref:staff");
addMember("app:mfa:service:policy:mfa_enabled_allow", "ref:student");

delGroup("app:mfa:service:ref:mfa_pilot");
delGroup("app:mfa:security:mfa_opt_in");
delGroup("app:mfa:security:mfa_opt_in_allow");
delGroup("app:mfa:security:mfa_opt_in_deny");
delGroup("app:mfa:service:ref:mfa_opt_in");
delGroup("app:mfa:service:ref:mfa_required");
delGroup("app:mfa:service:ref:BannerUsersMinusFaculty");
delGroup("app:mfa:service:ref:NonFacultyBannerINB");
delGroup("app:mfa:service:ref:mfa_athletics");

