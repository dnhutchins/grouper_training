gs = GrouperSession.startRootSession();

# SET THESE
parent_stem_path = "app";
app_extension = "boardeffect";
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
