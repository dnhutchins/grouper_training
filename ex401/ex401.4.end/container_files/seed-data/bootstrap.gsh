gs = GrouperSession.startRootSession();

group = new GroupSave(gs).assignName("ref:legacy:community_members").assignCreateParentStemsIfNotExist(true).save();
group.getAttributeDelegate().assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign();
attributeAssign = group.getAttributeDelegate().retrieveAssignment(null, LoaderLdapUtils.grouperLoaderLdapAttributeDefName(), false, true);
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=community_members)");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=groups,dc=internet2,dc=edu");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "member");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectId");
attributeAssign.getAttributeValueDelegate().assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), "\${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}");



# SET THESE
parent_stem_path = "app";
app_extension = "lms";
app_name = "";
 
 
if (!app_name?.trim())
{
    app_name = app_extension;
}
 
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
etc_stem = addStem(stem.name, "etc", "etc");
admin_group_name = "${app_extension}_admins";
admin_group = addGroup(etc_stem.name, admin_group_name, admin_group_name);
admin_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
mgr_group_name = "${app_extension}_mgr";
mgr_group = addGroup(etc_stem.name, mgr_group_name, mgr_group_name);
mgr_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
mgr_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);
mgr_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.READ);
view_group_name = "${app_extension}_viewers";
view_group = addGroup(etc_stem.name, view_group_name, view_group_name);
view_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
view_group.grantPriv(admin_group.toMember().getSubject(), AccessPrivilege.ADMIN);
view_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);
view_group.grantPriv(mgr_group.toMember().getSubject(), AccessPrivilege.READ);
admin_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
mgr_group.grantPriv(view_group.toMember().getSubject(), AccessPrivilege.READ);
# Child objects should also grant perms to these groups.
makeStemInheritable(this, stem.name, admin_group.name, 'admin');
makeStemInheritable(this, stem.name, mgr_group.name, 'update');
makeStemInheritable(this, stem.name, mgr_group.name, 'read');
makeStemInheritable(this, stem.name, view_group.name, 'read');
admin_group.revokePriv(mgr_group.toMember().getSubject(), AccessPrivilege.UPDATE);



#addStem("app", "lms", "lms");
group = addGroup("app:lms", "lms_authorized", "lms_authorized");
addGroup("app:lms", "lms_authorized_allow", "lms_authorized_allow");
addGroup("app:lms", "lms_authorized_deny", "lms_authorized_deny");
addComposite("app:lms:lms_authorized", CompositeType.COMPLEMENT, "app:lms:lms_authorized_allow", "app:lms:lms_authorized_deny");

addMember("app:lms:lms_authorized_allow", "ref:legacy:community_members");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_groupOfNames");
attributeAssignSave.save();


addStem("app:lms", "ref", "ref");


group = addGroup("app:lms:ref", "visiting_scholars", "visiting_scholars");
addMember("app:lms:ref:visiting_scholars","glee303");
addMember("app:lms:ref:visiting_scholars","jlee308");
addMember("app:lms:ref:visiting_scholars","cbutler313");
addMember("app:lms:ref:visiting_scholars","cwalters316");
addMember("app:lms:ref:visiting_scholars","bbutler317");
addMember("app:lms:ref:visiting_scholars","mwilliams323");
addMember("app:lms:ref:visiting_scholars","jgrady326");
addMember("app:lms:ref:visiting_scholars","ewalters329");
addMember("app:lms:ref:visiting_scholars","aroberts334");
addMember("app:lms:ref:visiting_scholars","mgrady336");
addMember("app:lms:ref:visiting_scholars","gdavis354");
addMember("app:lms:ref:visiting_scholars","hpeterson355");
addMember("app:lms:ref:visiting_scholars","clee357");
addMember("app:lms:ref:visiting_scholars","mwalters363");
addMember("app:lms:ref:visiting_scholars","svales364");
addMember("app:lms:ref:visiting_scholars","sthompson365");
addMember("app:lms:ref:visiting_scholars","iwhite370");
addMember("app:lms:ref:visiting_scholars","sdavis372");
addMember("app:lms:ref:visiting_scholars","aclark373");
addMember("app:lms:ref:visiting_scholars","pmartinez374");
addMember("app:lms:ref:visiting_scholars","anielson378");
addMember("app:lms:ref:visiting_scholars","adavis379");
addMember("app:lms:ref:visiting_scholars","gbutler381");
addMember("app:lms:ref:visiting_scholars","clopez383");
addMember("app:lms:ref:visiting_scholars","apeterson387");


addMember("app:lms:lms_authorized_allow", "app:lms:ref:visiting_scholars");

pspngAttribute = AttributeDefNameFinder.findByName("etc:pspng:provision_to", true);
AttributeAssignSave attributeAssignSave = new AttributeAssignSave(gs).assignPrintChangesToSystemOut(true);
attributeAssignSave.assignAttributeDefName(pspngAttribute);
attributeAssignSave.assignOwnerGroup(group);
attributeAssignSave.addValue("pspng_groupOfNames");
attributeAssignSave.save();
