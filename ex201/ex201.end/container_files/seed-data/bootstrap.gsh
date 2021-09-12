import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperNewServiceTemplateLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperTemplatePolicyGroupLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.ServiceAction
import edu.internet2.middleware.grouper.grouperUi.beans.ui.StemTemplateContainer
import edu.internet2.middleware.grouper.app.grouperTypes.*
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningAttributeNames
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningSettings
import edu.internet2.middleware.grouper.cfg.dbConfig.GrouperDbConfig

/***** START Defaults that may need to be changed for each class *****/

Range<Integer> ACTIVE_CLASS_YEARS = 2022..2025
int RECENT_GRADUATE_YEAR = 2021
java.util.Calendar cal = Calendar.getInstance()
cal.set(2021, Calendar.DECEMBER, 31, 17, 0, 0)
java.util.Date RECENT_GRAD_END_DATE = cal.time

/***** END Defaults that may need to be changed for each class *****/


GrouperSession gs = GrouperSession.startRootSession()

/* Creating a class for methods helps with gsh from the command line, which can't do functions called from other functions */
class HelperMethods {
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

    static void addSubjectWithCount(Group g, Subject s) {
        int countBefore = g.members.findAll {it.subjectType.name == "person"}.size()
        g.addMember(s, false)
        int countAfter = g.members.findAll {it.subjectType.name == "person"}.size()
        println "\tAdd ${s.name} to ${g.name}: ${countBefore} -> ${countAfter} (${countAfter - countBefore})"
    }

    static void newApplicationTemplate(Stem parentStem, String templateKey, String templateFriendlyName, String templateDescription, List<String> myServiceActionIds = []) {
        def stemTemplateContainer = new StemTemplateContainer()
        stemTemplateContainer.templateKey = templateKey
        stemTemplateContainer.templateFriendlyName = templateFriendlyName
        stemTemplateContainer.templateDescription = templateDescription

        GrouperNewServiceTemplateLogic templateLogic = new GrouperNewServiceTemplateLogic()
        templateLogic.stemId = parentStem.uuid
        templateLogic.stemTemplateContainer = stemTemplateContainer

        List<ServiceAction> selectedServiceActions = []
        if (myServiceActionIds == null || myServiceActionIds.isEmpty()) {
            selectedServiceActions = templateLogic.getServiceActions()
        } else {
            Map<String, ServiceAction> allPolicyServiceActionMap = templateLogic.getServiceActions().collectEntries { [it.id, it] }
            selectedServiceActions = myServiceActionIds.collect { allPolicyServiceActionMap[it] }
        }
        templateLogic.validate(selectedServiceActions)

        selectedServiceActions.each {serviceAction ->
            serviceAction.getServiceActionType().createTemplateItem(serviceAction)
        }
        String errorKey = templateLogic.postCreateSelectedActions(selectedServiceActions)
        if (errorKey != null) {
            println "Creating policy group returned error: ${errorKey}"
        }
    }

    static void newPolicyTemplate(Stem parentStem, String templateKey, String templateFriendlyName, String templateDescription, List<String> myServiceActionIds = []) {
        // note that this doesn't work < 2.5.56 due to dependence on the UI
        def policyStemTemplateContainer = new StemTemplateContainer()
        policyStemTemplateContainer.templateKey = templateKey
        policyStemTemplateContainer.templateFriendlyName = templateFriendlyName
        policyStemTemplateContainer.templateDescription = templateDescription

        GrouperTemplatePolicyGroupLogic policyTemplateLogic = new GrouperTemplatePolicyGroupLogic()
        policyTemplateLogic.stemId = parentStem.uuid
        policyTemplateLogic.stemTemplateContainer = policyStemTemplateContainer

        // simulate checking certain boxes in the ui
        List<ServiceAction> selectedServiceActions = []
        if (myServiceActionIds == null || myServiceActionIds.isEmpty()) {
            selectedServiceActions = policyTemplateLogic.getServiceActions()
        } else {
            Map<String, ServiceAction> allPolicyServiceActionMap = policyTemplateLogic.getServiceActions().collectEntries { [it.id, it] }
            selectedServiceActions = myServiceActionIds.collect { allPolicyServiceActionMap[it] }
        }

        policyTemplateLogic.validate(selectedServiceActions)
        selectedServiceActions.each { serviceAction ->
            serviceAction.getServiceActionType().createTemplateItem(serviceAction)
        }
        String policyErrorKey = policyTemplateLogic.postCreateSelectedActions(selectedServiceActions)
        if (policyErrorKey != null) {
            println "Creating policy group returned error: ${policyErrorKey}"
        }
    }

    static void provisionObject(AttributeAssignable object, String provisioningTargetId) {
        AttributeDefName provisioningMarkerAttributeDefName = GrouperProvisioningAttributeNames.retrieveAttributeDefNameBase()
        AttributeDefName provisioningDirectAttributeDefName = GrouperProvisioningAttributeNames.retrieveAttributeDefNameDirectAssignment()
        AttributeDefName provisioningTargetAttributeDefName = GrouperProvisioningAttributeNames.retrieveAttributeDefNameTarget()
        AttributeDefName provisioningStemScopeAttributeDefName = GrouperProvisioningAttributeNames.retrieveAttributeDefNameStemScope()
        AttributeDefName provisioningDoProvisionAttributeDefName = GrouperProvisioningAttributeNames.retrieveAttributeDefNameDoProvision()
        // GRP-3592 no method for provisioningMetadataJson
        AttributeDefName provisioningMdJsonAttributeDefName = AttributeDefNameFinder.findByName(
                GrouperProvisioningSettings.provisioningConfigStemName() + ":" + GrouperProvisioningAttributeNames.PROVISIONING_METADATA_JSON, true)


        AttributeAssign aa = object.getAttributeDelegate().addAttribute(provisioningMarkerAttributeDefName).getAttributeAssign()
        aa.getAttributeValueDelegate().assignValue(provisioningDirectAttributeDefName.getName(), "true")
        aa.getAttributeValueDelegate().assignValue(provisioningTargetAttributeDefName.getName(), provisioningTargetId)
        aa.getAttributeValueDelegate().assignValue(provisioningDoProvisionAttributeDefName.getName(), "false")
        aa.getAttributeValueDelegate().assignValue(provisioningStemScopeAttributeDefName.getName(), "sub")
        aa.getAttributeValueDelegate().assignValue(provisioningMdJsonAttributeDefName.getName(), '''{"md_grouper_allowPolicyGroupOverride":true}''')

    }
}


new StemSave(gs).assignName("201_end").
        assignDisplayExtension("201.end").
        assignCreateParentStemsIfNotExist(true).
        save()


/***** 201.1.1 Basis and Reference Groups (I) *****/

Group studentGroup = new GroupSave(gs).assignName("ref:student:students").
        assignDisplayExtension("students").
        assignCreateParentStemsIfNotExist(true).
        assignDescription($/This group contains contains all students for the purpose of access control. Members automatically get access to a broad selection of student services. You can view where this group is in use by selecting "This group's memberships in other groups" under the "More" tab/$).
        save()

HelperMethods.assignObjectTypeForGroup(studentGroup, "ref", "Registrar", "All student subjects for the purpose of access control")

println "Adding student terms"
(ACTIVE_CLASS_YEARS).each { term ->
    def classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:year:ac:${term}", true).toSubject()
    HelperMethods.addSubjectWithCount(studentGroup, classSubject)
}

//Add recent graduates and set expiration to a future date
def classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:year:cm:${RECENT_GRADUATE_YEAR}", true).toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)

studentGroup.addOrEditMember(classSubject, true, true, null, RECENT_GRAD_END_DATE, false);


/***** 201.1.2 Basis and Reference Groups (II) *****/

/* Add Students with no class year */
classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:year:ac:no_year", true).toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)

/* Add Exchange students */
classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:all:es", true).toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)


/* Create adhoc transfer student group and add members */

Stem xferStudentStem = new StemSave(gs).assignName("basis:adhoc:student").save()
Group xferStudentGroup = new GroupSave(gs).assignName("${xferStudentStem.name}:transfer_student").save()
HelperMethods.assignObjectTypeForGroup(xferStudentGroup, "basis")
HelperMethods.assignObjectTypeForGroup(xferStudentGroup, "manual")

['whawkins', 'hyoung', 'jmejia'].each {
    Subject s = SubjectFinder.findByIdentifier(it, true)
    xferStudentGroup.addMember(s, false)
}

/* Add transfer students to All Students */
classSubject = xferStudentGroup.toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)

/* Add transfer students to All Students */
classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:all:la", true).toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)



/***** 201.2 Access Policy Groups *****/

/* New application Template */

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
    "gitlab",
    "GitLab",
    "Access policy for the ITS GitLab version control system",
    null)


/* New policy Template */

Stem policyStem = StemFinder.findByName(gs, "app:gitlab:service:policy", true)
ArrayList<String> myServiceActionIds = [
        'policyGroupCreate',
        'policyGroupType',
        'policyGroupAllowGroupCreate',
        'allowIntermediatgeGroupType',
        //'policyGroupAllowManualGroupCreate',
        //'policyGroupAddManualToAllow',
        //'allowManualGroupType',
        'policyGroupDenyGroupCreate',
        'denyIntermediatgeGroupType',
        'policyGroupLockoutGroup_0',
        //'policyGroupDenyManualGroupCreate',
        //'policyGroupAddManualToDeny',
        //'denyManualGroupType',
]

HelperMethods.newPolicyTemplate(policyStem,
        "gitlab_access",
        "GitLab",
        "Access policy for the ITS GitLab version control system",
        myServiceActionIds
)

/* Add members to gitlab_access_allow */
Group gitlabAccessAllow = GroupFinder.findByName(gs, "app:gitlab:service:policy:gitlab_access_allow", true)
["ref:role:emp:staff", "ref:role:emp:faculty", "basis:hr:employee:dept:10901:affiliate"].each {
    Subject s = SubjectFinder.findByIdentifierAndSource(it, "g:gsa", true)
    HelperMethods.addSubjectWithCount(gitlabAccessAllow, s)
}



/***** 201.3 eduPersonAffiliation *****/

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "eduPersonAffiliation",
        "eduPersonAffiliation",
        "eduPersonAffiliation (defined in eduPerson 1.0); OID: 1.3.6.1.4.1.5923.1.1.1.1 Specifies the person's relationship(s) to the institution in broad categories such as student, faculty, staff, alum, etc.",
        null)

Stem policyStem = StemFinder.findByName(gs, "app:eduPersonAffiliation:service:policy", true)
HelperMethods.assignObjectTypeForStem(policyStem, "policy")

[
        "ePA_student": ["ref:student:students"],
        "ePA_staff": ["ref:role:emp:staff"],
        "ePA_faculty": ["ref:role:emp:faculty"],
        "ePA_member": ["${policyStem.name}:ePA_student", "${policyStem.name}:ePA_staff", "${policyStem.name}:ePA_faculty"]
].each { policyName, memberNames ->
    Group group = new GroupSave(gs).assignName("${policyStem.name}:${policyName}").save()
    memberNames.each { memberName ->
        Subject subject = SubjectFinder.findByIdentifierAndSource(memberName, "g:gsa", true)
        group.addMember(subject, false)
    }
}

/* Provisioning - the edupersonAffiliation provisioner should already be set up in 101.1.1 */
HelperMethods.provisionObject(policyStem, "eduPersonAffiliation")



/***** 201.4 eduPersonEntitlement *****/

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "wiki",
        "wiki",
        "Student wiki",
        null)

Stem policyStem = StemFinder.findByName(gs, "app:wiki:service:policy", true)
ArrayList<String> myServiceActionIds = [
        'policyGroupCreate',
        'policyGroupType',
        'policyGroupAllowGroupCreate',
        'allowIntermediatgeGroupType',
        //'policyGroupAllowManualGroupCreate',
        //'policyGroupAddManualToAllow',
        //'allowManualGroupType',
        'policyGroupDenyGroupCreate',
        'denyIntermediatgeGroupType',
        'policyGroupLockoutGroup_0',
        //'policyGroupDenyManualGroupCreate',
        //'policyGroupAddManualToDeny',
        //'denyManualGroupType',
        //'policyGroupRequireGroup_0'
]

HelperMethods.newPolicyTemplate(policyStem,
        "wiki_user",
        "wiki_user",
        "Access policy for student wiki",
        myServiceActionIds
)

Group group = GroupFinder.findByName(gs, "${policyStem.name}:wiki_user_allow", true)
Subject subject = SubjectFinder.findByIdentifierAndSource("ref:student:students", "g:gsa", true)
HelperMethods.addSubjectWithCount(group, subject)

/* Provisioning - students will configure a full sync provisioner in the UI */

GrouperDbConfig config = new GrouperDbConfig().configFileName("grouper-loader.properties")

config.propertyName("otherJob.eduPersonEntitlement_full_sync.class").value('''edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningFullSyncJob''').store()
config.propertyName("otherJob.eduPersonEntitlement_full_sync.provisionerConfigId").value('''eduPersonEntitlement''').store()
config.propertyName("otherJob.eduPersonEntitlement_full_sync.quartzCron").value('''0 0 4 * * ?''').store()




/* Provisioning - the edupersonAffiliation provisioner should already be set up in 101.1.1 */
HelperMethods.provisionObject(policyStem, "eduPersonAffiliation")

/* TODO ePA and ePT full sync provisioners are not working */

