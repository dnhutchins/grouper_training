gs = GrouperSession.startRootSession();
delStem("401.4.1")
addRootStem("401.4.end", "401.4.end")

// import "community members" into a legacy reference group
community = new GroupSave(gs).assignName("ref:legacy:community_members").assignCreateParentStemsIfNotExist(true).save();
community.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = community.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=community_members)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=groups,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "member");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), "\${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}");
loaderRunOneJob(community);

parent_stem_path = "app";
app_extension = "lms";
app_name = "lms";
 
def makeStemInheritable(obj, stemName, groupName, priv="admin") {
    baseStem = obj.getStems(stemName)[0];
    aGroup = obj.getGroups(groupName)[0];
    RuleApi.inheritGroupPrivileges(
        SubjectFinder.findRootSubject(),
        baseStem,
        Stem.Scope.SUB,
        aGroup.toSubject(),
        Privilege.getInstances(priv)
    );
    RuleApi.runRulesForOwner(baseStem);
    if(priv == 'admin')
    {
        RuleApi.inheritFolderPrivileges(
            SubjectFinder.findRootSubject(),
            baseStem,
            Stem.Scope.SUB,
            aGroup.toSubject(),
            Privilege.getInstances("stem, create"));
    }
    RuleApi.runRulesForOwner(baseStem);
}
 
stem = addStem(parent_stem_path, app_extension, app_name);
service = addStem(stem.name, "service", "service");
policy = addStem(service.name, "policy", "policy");
ref = addStem(service.name, "ref", "ref");
security = addStem(stem.name, "security", "security");
admin_group_name = "${app_extension}Admin";
admin_group = addGroup(security.name, admin_group_name, admin_group_name);
admin_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
mgr_group_name = "${app_extension}Updaters";
mgr_group = addGroup(security.name, mgr_group_name, mgr_group_name);
mgr_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
mgr_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);
mgr_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.READ);
view_group_name = "${app_extension}Readers";
view_group = addGroup(security.name, view_group_name, view_group_name);
view_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
view_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
view_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);
view_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.READ);
admin_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
mgr_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
// Child objects should also grant perms to these groups.
makeStemInheritable(this, stem.name, admin_group.name, 'admin');
makeStemInheritable(this, stem.name, mgr_group.name, 'update');
makeStemInheritable(this, stem.name, mgr_group.name, 'read');
makeStemInheritable(this, stem.name, view_group.name, 'read');

// admin_group.revokePriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);

group = addGroup(policy.name, "lms_access", "lms_access");
addGroup(policy.name, "lms_access_allow", "lms_access_allow");
addGroup(policy.name, "lms_access_deny", "lms_access_deny");
addComposite("app:lms:service:policy:lms_access", CompositeType.COMPLEMENT, "app:lms:service:policy:lms_access_allow", "app:lms:service:policy:lms_access_deny");

addMember("app:lms:service:policy:lms_access_allow", "ref:legacy:community_members");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_groupOfNames");
attributeAssignSave.save();

group = addGroup(ref.name, "visiting_scholars", "visiting_scholars");
addMember("app:lms:service:ref:visiting_scholars","adoe852");
addMember("app:lms:service:ref:visiting_scholars","agonazles804");
addMember("app:lms:service:ref:visiting_scholars","alopez751");
addMember("app:lms:service:ref:visiting_scholars","alopez802");
addMember("app:lms:service:ref:visiting_scholars","anielson378");
addMember("app:lms:service:ref:visiting_scholars","anielson51");
addMember("app:lms:service:ref:visiting_scholars","athompson526");
addMember("app:lms:service:ref:visiting_scholars","athompson713");
addMember("app:lms:service:ref:visiting_scholars","athompson866");
addMember("app:lms:service:ref:visiting_scholars","awalters247");
addMember("app:lms:service:ref:visiting_scholars","awhite131");
addMember("app:lms:service:ref:visiting_scholars","awhite631");
addMember("app:lms:service:ref:visiting_scholars","bdavis150");
addMember("app:lms:service:ref:visiting_scholars","bdavis999");
addMember("app:lms:service:ref:visiting_scholars","bgasper2");
addMember("app:lms:service:ref:visiting_scholars","bgonazles239");
addMember("app:lms:service:ref:visiting_scholars","bgrady115");
addMember("app:lms:service:ref:visiting_scholars","blee298");
addMember("app:lms:service:ref:visiting_scholars","cjohnson933");
addMember("app:lms:service:ref:visiting_scholars","clangenberg923");
addMember("app:lms:service:ref:visiting_scholars","clee357");
addMember("app:lms:service:ref:visiting_scholars","cthompson231");
addMember("app:lms:service:ref:visiting_scholars","cthompson287");
addMember("app:lms:service:ref:visiting_scholars","cwalters316");
addMember("app:lms:service:ref:visiting_scholars","cwalters536");
addMember("app:lms:service:ref:visiting_scholars","cwilliams606");
addMember("app:lms:service:ref:visiting_scholars","danderson959");
addMember("app:lms:service:ref:visiting_scholars","dbrown402");
addMember("app:lms:service:ref:visiting_scholars","ddavis762");
addMember("app:lms:service:ref:visiting_scholars","ddoe822");
addMember("app:lms:service:ref:visiting_scholars","dwhite663");
addMember("app:lms:service:ref:visiting_scholars","dwilliams299");
addMember("app:lms:service:ref:visiting_scholars","eanderson919");
addMember("app:lms:service:ref:visiting_scholars","escott173");
addMember("app:lms:service:ref:visiting_scholars","gbutler381");
addMember("app:lms:service:ref:visiting_scholars","ggrady118");
addMember("app:lms:service:ref:visiting_scholars","ggrady649");
addMember("app:lms:service:ref:visiting_scholars","glangenberg234");
addMember("app:lms:service:ref:visiting_scholars","gwalters810");
addMember("app:lms:service:ref:visiting_scholars","gwhite647");
addMember("app:lms:service:ref:visiting_scholars","hpeterson10");
addMember("app:lms:service:ref:visiting_scholars","jgrady499");
addMember("app:lms:service:ref:visiting_scholars","jlee308");
addMember("app:lms:service:ref:visiting_scholars","jnielson505");
addMember("app:lms:service:ref:visiting_scholars","jsmith466");
addMember("app:lms:service:ref:visiting_scholars","jvales111");
addMember("app:lms:service:ref:visiting_scholars","jvales645");
addMember("app:lms:service:ref:visiting_scholars","jwalters24");
addMember("app:lms:service:ref:visiting_scholars","kdavis686");
addMember("app:lms:service:ref:visiting_scholars","kjohnson872");

addMember("app:lms:service:policy:lms_access_allow", "app:lms:service:ref:visiting_scholars");
addMember("app:lms:service:policy:lms_access_deny", "ref:iam:global_deny");