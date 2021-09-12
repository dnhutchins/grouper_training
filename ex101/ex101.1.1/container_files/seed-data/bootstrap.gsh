import edu.internet2.middleware.grouper.app.grouperTypes.*
import edu.internet2.middleware.grouper.app.loader.db.Hib3GrouperLoaderLog
import edu.internet2.middleware.grouper.cfg.dbConfig.GrouperDbConfig

GrouperSession gs = GrouperSession.startRootSession();

static void assignObjectTypeForGroup(Group g, String type, String owner=null, String description=null) {
    new GdgTypeGroupSave().
            assignGroup(g).
            assignType(type).
            assignDataOwner(owner).
            assignMemberDescription(description).
            assignSaveMode(SaveMode.INSERT_OR_UPDATE).
            assignReplaceAllSettings(true).
            save()
}

static void assignObjectTypeForStem(Stem s, String type, String owner=null, String description=null) {
    new GdgTypeStemSave().
            assignStem(s).
            assignType(type).
            assignDataOwner(owner).
            assignMemberDescription(description).
            assignSaveMode(SaveMode.INSERT_OR_UPDATE).
            assignReplaceAllSettings(true).
            save()
}

// GDG structure
["basis", "ref", "app", "org", "test"].each {
    new StemSave(gs).assignName(it).save()
}

// Special groups for lessons

Group group = new GroupSave(gs).assignName("ref:iam:active").assignCreateParentStemsIfNotExist(true).save()

Group lockedByCiso = new GroupSave(gs).assignName("ref:security:locked_by_ciso").assignCreateParentStemsIfNotExist(true).save()
assignObjectTypeForGroup(lockedByCiso, "ref", "CISO", "Subjects denied access by CISO")

Group closure = new GroupSave(gs).assignName("ref:iam:closure").assignCreateParentStemsIfNotExist(true).save()
assignObjectTypeForGroup(closure, "ref", "IAM", "Accounts in the process of being closed")

Group globalDeny = new GroupSave(gs).assignName("ref:iam:global_deny").assignCreateParentStemsIfNotExist(true).save()
assignObjectTypeForGroup(globalDeny, "ref", "Identity and Access Management", "Global deny group")

/***** Employee by Dept Loader *****/

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
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:hr:employee:dept", true)
assignObjectTypeForStem(stem, "basis", "HRIS", "Employees grouped by department and role")


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
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:sis:course", true)
assignObjectTypeForStem(stem, "basis", "SIS", "Students and instructor groups for each course")


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
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:sis:career", true)
assignObjectTypeForStem(stem, "basis", "SIS", "Students grouped by academic program and expected graduation year")


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
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:sis:exp_grad_year", true)
assignObjectTypeForStem(stem, "basis", "SIS", "Students grouped by expected graduation year")


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
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:sis:prog_status:all", true)
assignObjectTypeForStem(stem, "basis", "SIS", "Students grouped by program status, regardless of year")


// SIS Program Status By Year Loader

def group = new GroupSave(gs).assignName("etc:loader:sis:yearAndProgStatusLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Student Information Systems:yearAndProgStatusLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "basis:sis:prog_status:year:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''select P.person_id AS subject_id, 'eduLDAP' AS subject_source_id,
 concat('basis:sis:prog_status:year:', lower(P.prog_status_id), ':', ifnull(grad_year_expected, 'no_year')) AS group_name
 from sis_stu_programs P''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''select distinct
 concat('basis:sis:prog_status:year:', lower(P.prog_status_id), ':', ifnull(grad_year_expected, 'no_year')) AS group_name,
 concat('basis:Student Information Systems:Program Status:by Program Status and Year:', PS.description, ' (', PS.prog_status_id, '):', PS.description, ' ', ifnull(grad_year_expected, 'No Year')) AS group_display_name
 from sis_stu_programs P join sis_prog_status PS on P.prog_status_id = PS.prog_status_id''')


GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "basis:sis:prog_status:year", true)
assignObjectTypeForStem(stem, "basis", "SIS", "Students grouped by program status and expected grad year")


// Ref All Employee By Role Loader

def group = new GroupSave(gs).assignName("etc:loader:ref:refEmployeeRoleLoader").assignCreateParentStemsIfNotExist(true).assignDisplayName("etc:loader:Reference:refEmployeeRoleLoader").save()

GroupType loaderType = GroupTypeFinder.find("grouperLoader", false)
group.addType(loaderType, false)

group.setAttribute(GrouperLoader.GROUPER_LOADER_DB_NAME, "grouper")
group.setAttribute(GrouperLoader.GROUPER_LOADER_TYPE, "SQL_GROUP_LIST")
group.setAttribute(GrouperLoader.GROUPER_LOADER_SCHEDULE_TYPE, "CRON")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUARTZ_CRON, "0 0 6 * * ?")
//group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUPS_LIKE, "ref:role:emp:%")
group.setAttribute(GrouperLoader.GROUPER_LOADER_QUERY, '''SELECT name AS subject_identifier,
       'g:gsa' AS subject_source_id,
       concat('ref:role:emp:',extension) AS group_name
  FROM grouper_groups
 WHERE name LIKE 'basis:hr:employee:dept:%' ''')
group.setAttribute(GrouperLoader.GROUPER_LOADER_GROUP_QUERY, '''SELECT DISTINCT concat('ref:role:emp:',extension) AS group_name,
 concat('ref:role:Employee by Role:','All ',UPPER(substring(extension,1,1)),lower(substring(extension,2))) AS group_display_name
FROM grouper_groups
WHERE name LIKE 'basis:hr:employee:dept:%' ''')

GrouperLoaderType.validateAndScheduleSqlLoad(group, null, false)
GrouperLoader.runJobOnceForGroup(gs, group)
Stem stem = StemFinder.findByName(gs, "ref:role:emp", true)
assignObjectTypeForStem(stem, "ref", "HR, IAM", "All employees by role")


/***** Run the types daemon to make sure the tags are up to date *****/

println "Running OTHER_JOB_grouperObjectTypeDaemon"
OtherJobBase.OtherJobInput otherJobInput = new OtherJobBase.OtherJobInput()
//Which one of these to run? otherJobInput.setJobName("OTHER_JOB_grouperObjectTypeDaemon")
otherJobInput.setJobName("OTHER_JOB_objectTypesFullSyncDaemon")
otherJobInput.setHib3GrouperLoaderLog(new Hib3GrouperLoaderLog())
otherJobInput.setGrouperSession(gs)
//new GrouperObjectTypesDaemonLogic().run(otherJobInput)


// Ad-hoc group for Transfer Students (just create the ad-hoc folder for now, they will create the group in the UI)

def adhocStem = new StemSave(gs).assignName("basis:adhoc").
        assignCreateParentStemsIfNotExist(true).
        assignDescription("Basis groups not loader jobs; could be a batch job using a web service call, an import from the UI, etc.").
        assignDisplayName("basis:Ad Hoc").
        save()


/***** Provisioners *****/

GrouperDbConfig config = new GrouperDbConfig().configFileName("grouper-loader.properties")

GrouperDbConfig textConfig = new GrouperDbConfig().configFileName("grouper.text.en.us.properties")
/* eduPersonAffiliation provisioner -- exercise 201.3 */

config.propertyName("provisioner.eduPersonAffiliation.canFullSync").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.class").value('''edu.internet2.middleware.grouper.app.ldapProvisioning.LdapSync''').store()
config.propertyName("provisioner.eduPersonAffiliation.debugLog").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.deleteMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.deleteMembershipsIfGrouperDeleted").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.deleteMembershipsIfNotExistInGrouper").value('''false''').store()
config.propertyName("provisioner.eduPersonAffiliation.hasTargetEntityLink").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.insertMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.ldapExternalSystemConfigId").value('''demo''').store()
config.propertyName("provisioner.eduPersonAffiliation.logAllObjectsVerbose").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.numberOfEntityAttributes").value('''3''').store()
config.propertyName("provisioner.eduPersonAffiliation.operateOnGrouperEntities").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.operateOnGrouperMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.provisioningType").value('''entityAttributes''').store()
config.propertyName("provisioner.eduPersonAffiliation.selectEntities").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.selectMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.showAdvanced").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.showProvisioningDiagnostics").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.subjectSourcesToProvision").value('''eduLDAP''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.fieldName").value('''name''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.isFieldElseAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.select").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.translateExpression").value('''${'uid=' + grouperProvisioningEntity.subjectId + ',ou=people,dc=internet2,dc=edu'}''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.translateExpressionType").value('''translationScript''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.translateToMemberSyncField").value('''memberToId2''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.0.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.matchingId").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.name").value('''uid''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.searchAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.select").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.translateExpressionType").value('''grouperProvisioningEntityField''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.translateFromGrouperProvisioningEntityField").value('''subjectId''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.1.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.membershipAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.multiValued").value('''true''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.name").value('''eduPersonAffiliation''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.translateFromGroupSyncField").value('''groupExtension''').store()
config.propertyName("provisioner.eduPersonAffiliation.targetEntityAttribute.2.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonAffiliation.userSearchAllFilter").value('''(objectClass=eduPerson)''').store()
config.propertyName("provisioner.eduPersonAffiliation.userSearchBaseDn").value('''ou=people,dc=internet2,dc=edu''').store()

config.propertyName("otherJob.ePA_full_sync.class").value('''edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningFullSyncJob''').store()
config.propertyName("otherJob.ePA_full_sync.provisionerConfigId").value('''eduPersonAffiliation''').store()
config.propertyName("otherJob.ePA_full_sync.quartzCron").value('''0 0 4 * * ?''').store()


/* eduPersonEntitlement provisioner -- exercise 201.4 */

config.propertyName("provisioner.eduPersonEntitlement.class").value('''edu.internet2.middleware.grouper.app.ldapProvisioning.LdapSync''').store()
config.propertyName("provisioner.eduPersonEntitlement.configureMetadata").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.deleteMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.deleteMembershipsIfNotExistInGrouper").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.insertMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.ldapExternalSystemConfigId").value('''demo''').store()
config.propertyName("provisioner.eduPersonEntitlement.metadata.0.formElementType").value('''text''').store()
config.propertyName("provisioner.eduPersonEntitlement.metadata.0.name").value('''md_entitlementValue''').store()
config.propertyName("provisioner.eduPersonEntitlement.metadata.0.showForGroup").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.metadata.0.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonEntitlement.numberOfEntityAttributes").value('''3''').store()
config.propertyName("provisioner.eduPersonEntitlement.numberOfGroupAttributes").value('''1''').store()
config.propertyName("provisioner.eduPersonEntitlement.numberOfMetadata").value('''1''').store()
config.propertyName("provisioner.eduPersonEntitlement.operateOnGrouperEntities").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.operateOnGrouperGroups").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.operateOnGrouperMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.provisioningType").value('''entityAttributes''').store()
config.propertyName("provisioner.eduPersonEntitlement.selectEntities").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.selectMemberships").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.showAdvanced").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.subjectSourcesToProvision").value('''eduLDAP''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.fieldName").value('''name''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.isFieldElseAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.select").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.translateExpression").value('''${'uid=' + grouperProvisioningEntity.subjectId + ',ou=people,dc=internet2,dc=edu'}''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.translateExpressionType").value('''translationScript''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.0.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.matchingId").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.name").value('''uid''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.searchAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.select").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.translateExpressionType").value('''grouperProvisioningEntityField''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.translateFromGrouperProvisioningEntityField").value('''subjectId''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.1.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.membershipAttribute").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.multiValued").value('''true''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.name").value('''eduPersonEntitlement''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.translateFromGroupSyncField").value('''groupFromId2''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetEntityAttribute.2.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.isFieldElseAttribute").value('''false''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.name").value('''entitlement''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.translateExpression").value('''${grouperUtil.defaultIfBlank(grouperProvisioningGroup.retrieveAttributeValueString('md_entitlementValue') , grouperProvisioningGroup.extension )}''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.translateExpressionType").value('''translationScript''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.translateGrouperToGroupSyncField").value('''groupFromId2''').store()
config.propertyName("provisioner.eduPersonEntitlement.targetGroupAttribute.0.valueType").value('''string''').store()
config.propertyName("provisioner.eduPersonEntitlement.userSearchAllFilter").value('''(uid=*)''').store()
config.propertyName("provisioner.eduPersonEntitlement.userSearchBaseDn").value('''ou=people,dc=internet2,dc=edu''').store()

textConfig.propertyName("md_entitlementValue_eduPersonEntitlement_label").value('''Entitlement String''').store()

/* for this exercise, they will create a full sync provisioner in the UI */


/* groupOfNames provisioner -- exercise 40x */

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

config.propertyName("otherJob.groupOfNames_full_sync.class").value('''edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningFullSyncJob''').store()
config.propertyName("otherJob.groupOfNames_full_sync.provisionerConfigId").value('''groupOfNames''').store()
config.propertyName("otherJob.groupOfNames_full_sync.quartzCron").value('''0 0 4 * * ?''').store()

/* TODO


Improvement: subject diagnostics should have placeholder text, not actual text that needs to be cleared
bug: grouper.requireGroup.name.0 defined twice. Also refers to a group that isn't set up in the base
bug: stop logging grouperUiUserData for audit
    Recent activity	Activity Date
    Edited group grouperUiUserData .	2021/07/14 5:31 AM
    Added group grouperUiUserData .	2021/07/14 5:31 AM
    Added folder grouperUi .	2021/07/14 5:31 AM

*/

/***** Add IAM staff to the wheel group *****/

Group iamStaff = GroupFinder.findByName(gs, "basis:hr:employee:dept:10904:staff", true)
Group sysadminGroup = GroupFinder.findByName(gs, "etc:sysadmingroup", true)
sysadminGroup.addMember(iamStaff.toSubject(), false)

/***** Add groups to global_deny *****/

GroupFinder.findByName(gs, "ref:iam:global_deny", true).addMember(
        GroupFinder.findByName(gs, "ref:security:locked_by_ciso", true).toSubject())
GroupFinder.findByName(gs, "ref:iam:global_deny", true).addMember(
        GroupFinder.findByName(gs, "ref:iam:closure", true).toSubject())

/***** Add READ|UPDATE for ISO staff on the Global Deny group *****/

Group g = GroupFinder.findByName(gs, "ref:security:locked_by_ciso", true)
Group g2 = GroupFinder.findByName(gs, "basis:hr:employee:dept:10902:staff", true)

g.grantPriv(g2.toSubject(), Privilege.READ, false)
g.grantPriv(g2.toSubject(), Privilege.UPDATE, false)


/***** Create an All faculty/Staff group to be used as a member filter *****/

def group = new GroupSave(gs).assignName("ref:role:all_facstaff").assignDisplayExtension("All Faculty/Staff").save()
["ref:role:emp:staff", "ref:role:emp:faculty"].each {
    Subject s = SubjectFinder.findByIdentifierAndSource(it, "g:gsa", true)
    group.addMember(s, false)
}


/***** Schedule jobs is an upgrade task for 2.5.55 ****/

GrouperLoader.scheduleJobs()

/* TODO
 * - Groups not picking up object types from parent folder, even after running object type daemon
 * - Check the groupOfNames provisioner for grouper authoritative -- it is deleting vpn_users
 */
