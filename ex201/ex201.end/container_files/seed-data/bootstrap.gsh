import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperNewServiceTemplateLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperTemplatePolicyGroupLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.ServiceAction
import edu.internet2.middleware.grouper.grouperUi.beans.ui.StemTemplateContainer
import edu.internet2.middleware.grouper.app.grouperTypes.*
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningAttributeNames
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningSettings
import edu.internet2.middleware.grouper.cfg.dbConfig.GrouperDbConfig
import edu.internet2.middleware.grouper.app.attestation.*;
import java.text.SimpleDateFormat;


/***** START Defaults that may need to be changed for each class *****/

Range<Integer> ACTIVE_CLASS_YEARS = 2022..2025
int RECENT_GRADUATE_YEAR = 2021
java.util.Calendar cal = Calendar.getInstance()
cal.set(2022, Calendar.MARCH, 31, 17, 0, 0)
java.util.Date RECENT_GRAD_END_DATE = cal.time

/***** END Defaults that may need to be changed for each class *****/

GrouperSession gs = GrouperSession.start(SubjectFinder.findByIdentifierAndSource("banderson", "eduLDAP", true))

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

    static int countPersonSubjects(Group g) {
        return g.members.findAll {it.subjectType.name == "person"}.size()
    }

    static void addSubjectWithCount(Group g, Subject s) {
        int countBefore = countPersonSubjects(g)
        g.addMember(s, false)
        int countAfter = countPersonSubjects(g)
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

    static void provisionObject(AttributeAssignable object, String provisioningTargetId, String metadataJson=null) {

        AttributeAssign attributeAssign = object.attributeDelegate.assignAttribute(GrouperProvisioningAttributeNames.retrieveAttributeDefNameBase()).getAttributeAssign()
        attributeAssign.attributeValueDelegate.with {
            assignValue(GrouperProvisioningAttributeNames.retrieveAttributeDefNameDirectAssignment().getName(), "true")
            assignValue(GrouperProvisioningAttributeNames.retrieveAttributeDefNameDoProvision().getName(), provisioningTargetId)
            assignValue(GrouperProvisioningAttributeNames.retrieveAttributeDefNameTarget().getName(), provisioningTargetId)

            if (object instanceof Stem) {
                assignValue(GrouperProvisioningAttributeNames.retrieveAttributeDefNameStemScope().getName(), "sub")
            }

            if (metadataJson != null) {
                // GRP-3592 no method for provisioningMetadataJson
                assignValue(AttributeDefNameFinder.findByName(
                        GrouperProvisioningSettings.provisioningConfigStemName() + ":" + GrouperProvisioningAttributeNames.PROVISIONING_METADATA_JSON, true).
                        getName(), metadataJson)
            }
        }

    }

    static void addAttestation(g, isSendMail, daysUntilRecertify) {
        AttributeAssign attributeAssign = g.attributeDelegate.assignAttribute(GrouperAttestationJob.retrieveAttributeDefNameValueDef()).getAttributeAssign()
        // Set date certified to today, so that it won't force attestation until the next time due
        def date = new SimpleDateFormat("yyyy/MM/dd").format(new Date())
        attributeAssign.attributeValueDelegate.with {
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameDirectAssignment().getName(), "true")
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameSendEmail().getName(), isSendMail)
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameHasAttestation().getName(), "true")
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameEmailAddresses().getName(), null)
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameDaysUntilRecertify().getName(), daysUntilRecertify)
            assignValue(GrouperAttestationJob.retrieveAttributeDefNameDateCertified().getName(), date)
        }
    }

    static void attestGroup(Group g) {
        //TODO
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

Group xferStudentGroup = new GroupSave(gs).assignName("ref:student:transfer_student").
        assignDisplayExtension("Transfer Student").
        assignDescription($/Students recently transfered but not yet in SIS/$).
        save()

HelperMethods.assignObjectTypeForGroup(xferStudentGroup, "manual", "Registrar", "Ad-hoc recent transfer students not yet in SIS")

['whawkins', 'hyoung', 'jmejia'].each {
    Subject s = SubjectFinder.findByIdentifier(it, true)
    xferStudentGroup.addMember(s, false)
}

/* Add transfer students to All Students */
classSubject = xferStudentGroup.toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)

/* Add leave of absence students to All Students */
classSubject = GroupFinder.findByName(gs, "basis:sis:prog_status:all:la", true).toSubject()
HelperMethods.addSubjectWithCount(studentGroup, classSubject)



/***** 201.2 Access Policy Groups *****/

/* New application Template */

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
    "gitlab",
    "GitLab",
    "Access policies for the ITS GitLab version control system",
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
        "GitLab Access",
        "Overall access policy for the ITS GitLab version control system",
        myServiceActionIds
)

/* Add members to gitlab_access_allow */
Group gitlabAccessAllow = GroupFinder.findByName(gs, "app:gitlab:service:policy:gitlab_access_allow", true)
["ref:role:all_facstaff", "basis:hr:employee:dept:10901:affiliate"].each {
    Subject s = SubjectFinder.findByIdentifierAndSource(it, "g:gsa", true)
    HelperMethods.addSubjectWithCount(gitlabAccessAllow, s)
}

/* Grant update to Infrastructure staff */

Group gitlabUpdaters = GroupFinder.findByName(gs, "app:gitlab:security:gitlabUpdaters", true)
Group infrastructureStaff = GroupFinder.findByName(gs, "basis:hr:employee:dept:10903:staff", true)
HelperMethods.addSubjectWithCount(gitlabUpdaters, infrastructureStaff.toSubject())



/***** 201.3 eduPersonAffiliation *****/

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "eduPersonAffiliation",
        "eduPersonAffiliation",
        "eduPersonAffiliation (defined in eduPerson 1.0); OID: 1.3.6.1.4.1.5923.1.1.1.1 Specifies the person's relationship(s) to the institution in broad categories such as student, faculty, staff, alum, etc.",
        null)

Stem policyStem = StemFinder.findByName(gs, "app:eduPersonAffiliation:service:policy", true)
HelperMethods.assignObjectTypeForStem(policyStem, "policy")

[
        "student": ["ref:student:students"],
        "staff": ["ref:role:emp:staff"],
        "faculty": ["ref:role:emp:faculty"],
        "member": ["${policyStem.name}:student", "${policyStem.name}:staff", "${policyStem.name}:faculty"]
].each { policyName, memberNames ->
    Group group = new GroupSave(gs).assignName("${policyStem.name}:${policyName}").save()
    memberNames.each { memberName ->
        Subject subject = SubjectFinder.findByIdentifierAndSource(memberName, "g:gsa", true)
        group.addMember(subject, false)
    }
}

/* Provisioning - the eduPersonAffiliation provisioner should already be set up in 101.1.1 */
HelperMethods.provisionObject(policyStem, "eduPersonAffiliation", '''{"md_grouper_allowPolicyGroupOverride":true}''')


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


/* Provisioning - the eduPersonEntitlement provisioner should already be set up in 101.1.1 */
Group group = GroupFinder.findByName(gs, "app:wiki:service:policy:wiki_user", true)

HelperMethods.provisionObject(group, "eduPersonEntitlement", '''{"md_entitlementValue":"http://sp.example.org/wiki"}''')


/***** 201.5: Policy groups and dynamic application permissions (Cognos) *****/

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "cognos",
        "cognos",
        "Manage policy roles for Cognos application",
        null)

Stem policyStem = StemFinder.findByName(gs, "app:cognos:service:policy", true)
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
        "cg_fin_report_reader",
        "cg_fin_report_reader",
        "Report Reader Access Policy",
        myServiceActionIds
)

HelperMethods.newPolicyTemplate(policyStem,
        "cg_fin_report_writer",
        "cg_fin_report_writer",
        "Report Writer Access Policy",
        myServiceActionIds
)


Group financeStaff = GroupFinder.findByName(gs, "basis:hr:employee:dept:10810:staff", true)
Group cg_fin_report_reader_allow = GroupFinder.findByName(gs, "app:cognos:service:policy:cg_fin_report_reader_allow", true)
"app:cognos:service:policy:cg_fin_report_reader_allow"

HelperMethods.addSubjectWithCount(cg_fin_report_reader_allow, financeStaff.toSubject())


Group financeWritersRef = new GroupSave(gs).assignName("app:cognos:service:ref:finance_report_writer").
        assignCreateParentStemsIfNotExist(true).
        save()

HelperMethods.assignObjectTypeForGroup(financeWritersRef, "ref", "Finance Manager", $/Employees authorized by the Finance Manager have access to write reports/$)


Group financeMgrRole = new GroupSave(gs).assignName("ref:role:financeManager").
        assignDisplayExtension("Finance Manager").
        save()
HelperMethods.assignObjectTypeForGroup(financeMgrRole, "ref")

Subject driddle = SubjectFinder.findByIdentifierAndSource("driddle", "eduLDAP", true)
financeMgrRole.addMember(driddle, false)

financeWritersRef.grantPriv(financeMgrRole.toSubject(), AccessPrivilege.READ, false)
financeWritersRef.grantPriv(financeMgrRole.toSubject(), AccessPrivilege.UPDATE, false)

HelperMethods.addAttestation(financeWritersRef, "true", "30")

GrouperSession gs2 = GrouperSession.start(SubjectFinder.findByIdentifierAndSource("driddle", "eduLDAP", true))

Subject ccampbe2 = SubjectFinder.findByIdentifierAndSource("ccampbe2", "eduLDAP", true)
financeWritersRef.addMember(ccampbe2, false)

// Mark reviewed
//TODO HelperMethods.attestGroup(financeWritersRef)
