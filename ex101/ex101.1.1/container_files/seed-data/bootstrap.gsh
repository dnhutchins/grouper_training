GrouperSession gs = GrouperSession.startRootSession();
addRootStem("basis", "basis");
addRootStem("ref", "ref");
addRootStem("app", "app");
addRootStem("org", "org");
addRootStem("test", "test");

addStem("ref", "iam", "iam");
addGroup("ref:iam", "active", "active");


addStem("ref", "security", "security")
locked_by_ciso = addGroup("ref:security", "locked_by_ciso", "locked_by_ciso")
// AttributeAssign attributeAssign = locked_by_ciso.getAttributeDelegate().hasAttribute(typeMarker) ? locked_by_ciso.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : locked_by_ciso.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "CISO");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription", "Subjects denied access by CISO");

closure = addGroup("ref:iam", "closure", "closure")
// AttributeAssign attributeAssign = closure.getAttributeDelegate().hasAttribute(typeMarker) ? closure.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : closure.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "IAM");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription", "Accounts in the process of being closed");

global_deny = addGroup("ref:iam", "global_deny", "global_deny");
// AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
// AttributeAssign attributeAssign = global_deny.getAttributeDelegate().hasAttribute(typeMarker) ? global_deny.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : global_deny.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner", "Identity and Access Management");
// attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription", "Global deny group");


//config.propertyName("member.search.defaultIndexOrder").value('1,0,2').store()



// later we will add all of IAM. For now add one person so we can get in
// Doesn't work. Need to wait for the config to refresh?
//addMember("etc:sysadmingroup","800000252");  //jarnold





// Employee by Dept Loader

def group = new GroupSave(gs).assignName("etc:loader:hr:employeeDeptLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:HR:employeeDeptLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:hr:employee:dept:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''SELECT person_id AS subject_id,
       'eduLDAP' AS subject_source_id,
       concat('basis:hr:employee:dept:',D.dept_id,':',role) AS group_name
 FROM hr_jobs J
  JOIN hr_positions P ON J.position_id = P.position_id
  JOIN hr_depts D ON P.dept_id = D.dept_id''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''SELECT DISTINCT concat('basis:hr:employee:dept:',D.dept_id,':',role) AS group_name,
       concat('basis:Human Resources:Employee:Department:',D.name,' (',D.dept_id,'):',D.name, ' ', role) AS group_display_name
 FROM hr_jobs J
  JOIN hr_positions P ON J.position_id = P.position_id
  JOIN hr_depts D ON P.dept_id = D.dept_id''')

//group.setAttribute(GrouperLoader.GROUPER_LOADER_PRIORITY, priority)

GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)

// This may take a long time
GrouperLoader.runJobOnceForGroup(gs, group)

addMember("etc:sysadmingroup", "basis:hr:employee:dept:10904:staff")



// Course Loader

def group = new GroupSave(gs).assignName("etc:loader:sis:courseLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Student Information Systems:courseLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:sis:course:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''SELECT E.person_id AS subject_id, 'eduLDAP' AS subject_source_id, concat('basis:sis:course:', lower(C.dept_abbr), ':', lower(C.dept_abbr), C.course_num, ':', role) AS group_name
 FROM sis_enrollment E
 JOIN sis_courses C ON E.course_id = C.course_id
 JOIN hr_depts D ON C.dept_id = D.dept_id''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''SELECT DISTINCT concat('basis:sis:course:',lower(C.dept_abbr), ':', lower(C.dept_abbr), C.course_num, ':', role) AS group_name,
 concat('basis:Student Information Systems:Courses:', D.name,' (', D.abbrev, '):', C.dept_abbr, C.course_num, ' ', replace(C.title, ':', ' -'), ':', C.dept_abbr, C.course_num, ' ', UPPER(substring(role,1,1)), lower(substring(role,2))) AS group_display_name
 FROM sis_enrollment E
 JOIN sis_courses C ON E.course_id = C.course_id
 JOIN hr_depts D ON C.dept_id = D.dept_id''')


GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)

// This may take a long time
GrouperLoader.runJobOnceForGroup(gs, group)



// Student Career Loader

def group = new GroupSave(gs).assignName("etc:loader:sis:studentCareerLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Student Information Systems:studentCareerLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:sis:career:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''select distinct person_id as subject_id, 'eduLDAP' as subject_source_id, concat('basis:sis:career:', lower(acad_career_id), ':', ifnull(grad_year_expected, 'no_year')) as group_name
 from sis_stu_programs''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''select distinct concat('basis:sis:career:', lower(P.acad_career_id), ':', ifnull(grad_year_expected, 'no_year')) as group_name,
 concat('basis:Student Information Systems:Careers:', C.description, ' (', P.acad_career_id, '):', P.acad_career_id, ' ', ifnull(grad_year_expected, 'No Year')) as group_display_name
 from sis_stu_programs P join sis_acad_careers C on P.acad_career_id = C.acad_career_id''')


GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)

// This may take a long time
GrouperLoader.runJobOnceForGroup(gs, group)



// Student Career By Year Loader

def group = new GroupSave(gs).assignName("etc:loader:sis:studentCareerByGradYearLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Student Information Systems:studentCareerByGradYearLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:sis:exp_grad_year:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''select distinct person_id as subject_id, 'eduLDAP' as subject_source_id, concat('basis:sis:exp_grad_year:', ifnull(grad_year_expected, 'no_year')) as group_name
 from sis_stu_programs''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''select distinct concat('basis:sis:exp_grad_year:', ifnull(grad_year_expected, 'no_year')) as group_name,
 concat('basis:Student Information Systems:Expected Grad Year:', case when grad_year_expected is null then 'No Grad Year' else concat('Class of ',  grad_year_expected) end ) as group_display_name
 from sis_stu_programs P join sis_acad_careers C on P.acad_career_id = C.acad_career_id''')


GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)

// This may take a long time
GrouperLoader.runJobOnceForGroup(gs, group)


// SIS Overall Program Status Loader

def group = new GroupSave(gs).assignName("etc:loader:sis:overallProgStatusLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Student Information Systems:overallProgStatusLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:sis:prog_status:all:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''select P.person_id AS subject_id, 'eduLDAP' AS subject_source_id,
 concat('basis:sis:prog_status:all:', lower(P.prog_status_id)) AS group_name
 from sis_stu_programs P''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''SELECT concat('basis:sis:prog_status:all:',lower(PS.prog_status_id)) AS group_name,
 concat('basis:Student Information Systems:Program Status:All by Program Status:', PS.description) AS group_display_name
 FROM sis_prog_status PS''')


GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)

// This may take a long time
GrouperLoader.runJobOnceForGroup(gs, group)



// Ad-hoc group for Transfer Students (just create the ad-hoc folder for now, they will create the group in the UI)

def adhocStem = new StemSave(gs).assignName("basis:adhoc").
    assignCreateParentStemsIfNotExist(true).
    assignDescription("Basis groups not loader jobs; could be a batch job using a web service call, an import from the UI, etc.").
    assignDisplayName("basis:Ad Hoc").
    save()

//import edu.internet2.middleware.grouper.app.grouperTypes.GdgTypeGroupSave
//import edu.internet2.middleware.grouper.app.grouperTypes.GrouperObjectTypesAttributeValue
//import edu.internet2.middleware.grouper.misc.SaveMode
//
// def xferGroup = new GroupSave(gs).
//     assignName("basis:adhoc:transfer_students").
//     assignCreateParentStemsIfNotExist(true).
//     assignDescription("Students recently transfered to campus, who need access ahead of SIS data being fully updated").
//     assignDisplayName("basis:Ad Hoc:Transfer student").
//     assignTypeOfGroup(TypeOfGroup.group).
//     save()
// 
// GrouperObjectTypesAttributeValue grouperObjectTypesAttributeValue = new GdgTypeGroupSave().
//         assignGroup(xferGroup).
//         assignType("manual").
//         assignDataOwner("Student Information Systems").
//         assignMemberDescription("Recently transfered students, who may not yet be in the SIS database").
//         assignSaveMode(SaveMode.INSERT_OR_UPDATE).
//         assignReplaceAllSettings(true).
//         save()



/* Add groups to global_deny */

GroupFinder.findByName(gs, "ref:iam:global_deny", true).addMember(GroupFinder.findByName(gs, "ref:security:locked_by_ciso", true).toSubject())
GroupFinder.findByName(gs, "ref:iam:global_deny", true).addMember(GroupFinder.findByName(gs, "ref:iam:closure", true).toSubject())




/* Provisioner */

import edu.internet2.middleware.grouper.grouperUi.beans.config.GrouperDbConfig

def config = new GrouperDbConfig().configFileName("grouper-loader.properties")

config.propertyName("otherJob.groupOfNames_full_sync.class").value('''edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningFullSyncJob''').store()
config.propertyName("otherJob.groupOfNames_full_sync.provisionerConfigId").value('''groupOfNames''').store()
config.propertyName("otherJob.groupOfNames_full_sync.quartzCron").value('''0 0 4 * * ?''').store()

config.propertyName("provisioner.groupOfNames.canFullSync").value('''true''').store()
config.propertyName("provisioner.groupOfNames.class").value('''edu.internet2.middleware.grouper.app.ldapProvisioning.LdapSync''').store()
config.propertyName("provisioner.groupOfNames.debugLog").value('''true''').store()
config.propertyName("provisioner.groupOfNames.deleteGroups").value('''true''').store()
config.propertyName("provisioner.groupOfNames.deleteGroupsIfGrouperDeleted").value('''true''').store()
config.propertyName("provisioner.groupOfNames.deleteGroupsIfNotExistInGrouper").value('''false''').store()
config.propertyName("provisioner.groupOfNames.deleteMemberships").value('''true''').store()
config.propertyName("provisioner.groupOfNames.deleteMembershipsIfNotExistInGrouper").value('''true''').store()
config.propertyName("provisioner.groupOfNames.groupDnType").value('''flat''').store()
config.propertyName("provisioner.groupOfNames.groupSearchAllFilter").value('''objectClass=groupOfNames''').store()
config.propertyName("provisioner.groupOfNames.groupSearchBaseDn").value('''ou=groups,dc=internet2,dc=edu''').store()
config.propertyName("provisioner.groupOfNames.groupSearchFilter").value('''(&(objectClass=groupOfNames)(cn=${targetGroup.retrieveAttributeValue('cn')}))''').store()
config.propertyName("provisioner.groupOfNames.hasTargetEntityLink").value('''true''').store()
config.propertyName("provisioner.groupOfNames.hasTargetGroupLink").value('''true''').store()
config.propertyName("provisioner.groupOfNames.insertGroups").value('''true''').store()
config.propertyName("provisioner.groupOfNames.insertMemberships").value('''true''').store()
config.propertyName("provisioner.groupOfNames.ldapExternalSystemConfigId").value('''demo''').store()
config.propertyName("provisioner.groupOfNames.numberOfEntityAttributes").value('''2''').store()
config.propertyName("provisioner.groupOfNames.numberOfGroupAttributes").value('''5''').store()
config.propertyName("provisioner.groupOfNames.operateOnGrouperEntities").value('''true''').store()
config.propertyName("provisioner.groupOfNames.operateOnGrouperGroups").value('''true''').store()
config.propertyName("provisioner.groupOfNames.operateOnGrouperMemberships").value('''true''').store()
config.propertyName("provisioner.groupOfNames.provisioningType").value('''groupAttributes''').store()
config.propertyName("provisioner.groupOfNames.selectEntities").value('''true''').store()
config.propertyName("provisioner.groupOfNames.selectGroups").value('''true''').store()
config.propertyName("provisioner.groupOfNames.selectMemberships").value('''true''').store()
config.propertyName("provisioner.groupOfNames.showAdvanced").value('''true''').store()
config.propertyName("provisioner.groupOfNames.subjectSourcesToProvision").value('''eduLDAP''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.0.fieldName").value('''name''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.0.isFieldElseAttribute").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.0.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.0.translateToMemberSyncField").value('''memberToId2''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.0.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.matchingId").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.name").value('''uid''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.searchAttribute").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.translateExpressionType").value('''grouperProvisioningEntityField''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.translateFromGrouperProvisioningEntityField").value('''attribute__subjectIdentifier0''').store()
config.propertyName("provisioner.groupOfNames.targetEntityAttribute.1.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.fieldName").value('''name''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.insert").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.isFieldElseAttribute").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.translateExpressionType").value('''grouperProvisioningGroupField''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.translateFromGrouperProvisioningGroupField").value('''name''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.translateToGroupSyncField").value('''groupToId2''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.update").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.0.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.insert").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.matchingId").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.name").value('''cn''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.searchAttribute").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.translateExpressionType").value('''grouperProvisioningGroupField''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.translateFromGrouperProvisioningGroupField").value('''name''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.1.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.insert").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.multiValued").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.name").value('''objectClass''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.translateExpression").value('''${grouperUtil.toSet('top', 'groupOfNames')}''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.translateExpressionType").value('''translationScript''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.2.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.insert").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.name").value('''description''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.select").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.translateExpressionType").value('''grouperProvisioningGroupField''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.translateFromGrouperProvisioningGroupField").value('''attribute__description''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.update").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.3.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.defaultValue").value('''cn=root,dc=internet2,dc=edu''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.membershipAttribute").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.multiValued").value('''true''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.name").value('''member''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.translateFromMemberSyncField").value('''memberToId2''').store()
config.propertyName("provisioner.groupOfNames.targetGroupAttribute.4.valueType").value('''string''').store()
config.propertyName("provisioner.groupOfNames.updateGroups").value('''true''').store()
config.propertyName("provisioner.groupOfNames.userSearchAllFilter").value('''(&(objectClass=person)(uid=*))''').store()
config.propertyName("provisioner.groupOfNames.userSearchBaseDn").value('''ou=people,dc=internet2,dc=edu''').store()
config.propertyName("provisioner.groupOfNames.userSearchFilter").value('''(&(objectClass=person)(uid=${targetEntity.retrieveAttributeValue('uid')}))''').store()

/* TODO


Improvement: subject diagnostics should have placeholder text, not actual text that needs to be cleared
bug: grouper.requireGroup.name.0 defined twice. Also refers to a group that isn't set up in the base
bug: stop logging grouperUiUserData for audit
    Recent activity	Activity Date
    Edited group grouperUiUserData .	2021/07/14 5:31 AM
    Added group grouperUiUserData .	2021/07/14 5:31 AM
    Added folder grouperUi .	2021/07/14 5:31 AM

*/

def g = GroupFinder.findByName(gs, "ref:security:locked_by_ciso", true)
def g2 = GroupFinder.findByName(gs, "basis:hr:job:10902:staff", true)

g.grantPriv(g2.toSubject(), Privilege.READ, false)
g.grantPriv(g2.toSubject(), Privilege.UPDATE, false)
