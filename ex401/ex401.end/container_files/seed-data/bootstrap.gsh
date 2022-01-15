import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperNewServiceTemplateLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.GrouperTemplatePolicyGroupLogic
import edu.internet2.middleware.grouper.grouperUi.beans.ui.ServiceAction
import edu.internet2.middleware.grouper.grouperUi.beans.ui.StemTemplateContainer
import edu.internet2.middleware.grouper.app.grouperTypes.*
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningAttributeNames
import edu.internet2.middleware.grouper.app.provisioning.GrouperProvisioningSettings
import edu.internet2.middleware.grouper.app.attestation.*;
import java.text.SimpleDateFormat;

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

def oldStem = StemFinder.findByName(gs, "201_end", false)
if (oldStem != null) {
    oldStem.delete()
}

new StemSave(gs).assignName("401_end").
        assignDisplayExtension("401.end").
        assignCreateParentStemsIfNotExist(true).
        save()


/***** 401.1: VPN Access Control (I) *****/

Group vpnLegacyGroup = new GroupSave(gs).assignName("test:vpn:vpn_legacy").
        assignCreateParentStemsIfNotExist(true).
        save()

AttributeAssign attributeAssign = vpnLegacyGroup.attributeDelegate.assignAttribute(LoaderLdapUtils.grouperLoaderLdapAttributeDefName()).getAttributeAssign()

attributeAssign.attributeValueDelegate.with {
    assignValue(LoaderLdapUtils.grouperLoaderLdapTypeName(), "LDAP_SIMPLE")
    assignValue(LoaderLdapUtils.grouperLoaderLdapServerIdName(), "demo")
    assignValue(LoaderLdapUtils.grouperLoaderLdapFilterName(), "(cn=vpn_users)")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectAttributeName(), "member")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSearchDnName(), "ou=groups,dc=internet2,dc=edu")
    assignValue(LoaderLdapUtils.grouperLoaderLdapQuartzCronName(), "0 * * * * ?")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSourceIdName(), "eduLDAP")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectIdTypeName(), "subjectIdentifier")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSearchScopeName(), "SUBTREE_SCOPE")
    assignValue(LoaderLdapUtils.grouperLoaderLdapSubjectExpressionName(), "\${loaderLdapElUtils.convertDnToSpecificValue(subjectId)}")
}

GrouperLoaderType.validateAndScheduleLdapLoad(attributeAssign, null, false)
GrouperLoader.runJobOnceForGroup(gs, vpnLegacyGroup)


// Create vpn_facstaff
Group allFacStaff = GroupFinder.findByName("ref:role:all_facstaff", true)
Group vpnFacStaff = new GroupSave(gs).assignName("test:vpn:vpn_facstaff").save()
vpnFacStaff.assignCompositeMember(CompositeType.INTERSECTION, allFacStaff, vpnLegacyGroup)

println "${allFacStaff.extension}: Person subjects = ${HelperMethods.countPersonSubjects(allFacStaff)}"
println "${vpnLegacyGroup.extension}: Person subjects = ${HelperMethods.countPersonSubjects(vpnLegacyGroup)}"
println "${vpnFacStaff.extension}: Person subjects = ${HelperMethods.countPersonSubjects(vpnFacStaff)}"

// Create vpn_legacy_exceptions
Group vpnLegacyExceptions = new GroupSave(gs).assignName("test:vpn:vpn_legacy_exceptions").save()
vpnLegacyExceptions.assignCompositeMember(CompositeType.COMPLEMENT, vpnLegacyGroup, allFacStaff)

println "${vpnLegacyExceptions.extension}: Person subjects = ${HelperMethods.countPersonSubjects(vpnLegacyExceptions)}"

// Create app template

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
    "vpn",
    "vpn",
    "VPN access policies",
    null)


/* New policy Template */

Stem policyStem = StemFinder.findByName(gs, "app:vpn:service:policy", true)
ArrayList<String> myServiceActionIds = [
        'policyGroupCreate',
        'policyGroupType',
        'policyGroupAllowGroupCreate',
        'allowIntermediatgeGroupType',
        'policyGroupAllowManualGroupCreate',
        'policyGroupAddManualToAllow',
        'allowManualGroupType',
        'policyGroupDenyGroupCreate',
        'denyIntermediatgeGroupType',
        'policyGroupLockoutGroup_0',
        //'policyGroupDenyManualGroupCreate',
        //'policyGroupAddManualToDeny',
        //'denyManualGroupType',
]

HelperMethods.newPolicyTemplate(policyStem,
        "vpn_authorized",
        "vpn_authorized",
        "Access policy for the campus VPN",
        myServiceActionIds
)

/* Add members to vpn_authorized_allow */
Group vpnAccessAllow = GroupFinder.findByName(gs, "app:vpn:service:policy:vpn_authorized_allow", true)
HelperMethods.addSubjectWithCount(vpnAccessAllow, allFacStaff.toSubject())


/***** 401.2: VPN Access Control (II) *****/

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "eduPersonAffiliation",
        "eduPersonAffiliation",
        "eduPersonAffiliation (defined in eduPerson 1.0); OID: 1.3.6.1.4.1.5923.1.1.1.1 Specifies the person's relationship(s) to the institution in broad categories such as student, faculty, staff, alum, etc.",
        null)

Group policyGroup = GroupFinder.findByName(gs, "app:vpn:service:policy:vpn_authorized", true)
HelperMethods.assignObjectTypeForGroup(policyGroup, "policy")

/* Provisioning - the groupOfNames provisioner should already be set up */
HelperMethods.provisionObject(policyGroup, "groupOfNames")

GrouperLoader.runOnceByJobName(gs, "OTHER_JOB_groupOfNames_full_sync")


// Create ref group vpn_consultants

Group vpnConsultantsRef = new GroupSave(gs).assignName("app:vpn:service:policy:vpn_consultants").save()
Group wri250Ref = new GroupSave(gs).assignName("app:vpn:service:policy:vpn_wri250").save()
Group manualGroup = GroupFinder.findByName(gs, "app:vpn:service:policy:vpn_authorized_allow_manual", true)

[vpnConsultantsRef, wri250Ref].each {
    manualGroup.addMember(it.toSubject())
}

// Create security group and grant privileges

Group wri250Sec = new GroupSave(gs).assignName("app:vpn:security:vpn_wri250_mgr").save()
Group wri250Instructors = GroupFinder.findByName(gs, "basis:sis:course:wri:wri250:instructor", true)
wri250Sec.addMember(wri250Instructors.toSubject())
wri250Ref.grantPriv(wri250Sec.toSubject(), AccessPrivilege.READ)
wri250Ref.grantPriv(wri250Sec.toSubject(), AccessPrivilege.UPDATE)

// Add member as kjenkins

GrouperSession gs2 = GrouperSession.start(SubjectFinder.findByIdentifierAndSource("kjenkins", "eduLDAP", true))

wri250Ref.addMember(SubjectFinder.findByIdentifierAndSource("mwest", "eduLDAP", true), false)

// switch back to banderson
GrouperSession.start(gs.subject)

HelperMethods.addAttestation(wri250Ref, "true", "30")


// Set a rule on the consultants group vpnConsultantsRef
AttributeAssign attribAssign = vpnConsultantsRef.attributeDelegate.addAttribute(RuleUtils.ruleAttributeDefName()).attributeAssign

Subject actAs = SubjectFinder.findRootSubject()
int numberOfDays = 180
attribAssign.attributeValueDelegate.with {
    assignValue(RuleUtils.ruleActAsSubjectSourceIdName(), actAs.sourceId);
    assignValue(RuleUtils.ruleActAsSubjectIdName(), actAs.id)
    assignValue(RuleUtils.ruleCheckTypeName(), RuleCheckType.membershipAdd.name())
    assignValue(RuleUtils.ruleThenEnumName(), RuleThenEnum.assignMembershipDisabledDaysForOwnerGroupId.name())
    assignValue(RuleUtils.ruleThenEnumArg0Name(), numberOfDays.toString())
    assignValue(RuleUtils.ruleThenEnumArg1Name(), "T")
}

vpnConsultantsRef.addMember(SubjectFinder.findByIdentifierAndSource("rjohnso5", "eduLDAP", true), false)


//VPN access audit for a list of NetIDs

Group vpnAuditList = new GroupSave(gs).assignName("test:vpn:vpn_audit_list").save()

[
        "groberts",
        "shenders",
        "mwest",
        "mpeterso",
        "kclark",
].each {
    vpnAuditList.addMember(SubjectFinder.findByIdentifierAndSource(it, "eduLDAP", true), false)
}

Group vpnAudit = new GroupSave(gs).assignName("test:vpn:vpn_audit").save()

vpnAudit.addCompositeMember(CompositeType.INTERSECTION,
        GroupFinder.findByName(gs, "app:vpn:service:policy:vpn_authorized", true),
        vpnAuditList
)


/***** 401.3: MFA Policy Governance part 1 *****/

// Create app template

HelperMethods.newApplicationTemplate(StemFinder.findByName(gs, "app", true),
        "mfa",
        "mfa",
        "Multi-factor authentication (MFA) policies",
        null)


/* New policy Template */

Stem policyStem = StemFinder.findByName(gs, "app:mfa:service:policy", true)
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
        //'policyGroupLockoutGroup_0',
        //'policyGroupDenyManualGroupCreate',
        //'policyGroupAddManualToDeny',
        //'denyManualGroupType',
]

HelperMethods.newPolicyTemplate(policyStem,
        "mfa_enabled",
        "mfa_enabled",
        "Users with MFA enabled",
        myServiceActionIds
)


// reference group

Group mfaPilotRef = new GroupSave(gs).assignName("app:mfa:service:ref:mfa_pilot").save()

Group mfaEnabledAllow = GroupFinder.findByName(gs, "app:mfa:service:policy:mfa_enabled_allow", true)
mfaEnabledAllow.addMember(mfaPilotRef.toSubject(), false)

// Provisioning
Group mfaEnabled = GroupFinder.findByName(gs, "app:mfa:service:policy:mfa_enabled", true)
HelperMethods.provisionObject(mfaEnabled, "eduPersonEntitlement", '''{"md_entitlementValue":"http://tier.internet2.edu/mfa/enabled"}''')


// Onboard select departments
Group mfaBypass = new GroupSave(gs).assignName("app:mfa:service:ref:mfa_bypass").save()
Group mfaEnabledDeny = GroupFinder.findByName(gs, "app:mfa:service:policy:mfa_enabled_allow", true)
mfaEnabledDeny.addMember(mfaBypass.toSubject(), false)

["10904", "10902", "10903"].each {
    Group g = GroupFinder.findByName(gs, "basis:hr:employee:dept:${it}:staff", true)
    mfaEnabledAllow.addMember(g.toSubject(), false)
}


Group peerCounselRef = new GroupSave(gs).assignName("app:mfa:service:ref:mfa_peer_counseling").save()
[
        "jhoover",
        "csmith",
        "jthornto",
        "tgarrett",
        "cgarcia",
        "cpreston",
        "rnelson",
        "sberry",
        "pwilliam",
].each {
    Subject s = SubjectFinder.findByIdentifierAndSource(it, "eduLDAP", true)
    peerCounselRef.addMember(s, false)
}

mfaEnabledAllow.addMember(peerCounselRef.toSubject(), false)

// Add sensitive data group

Group sensitiveData = new GroupSave(gs).assignName("app:mfa:service:ref:sensitive_data").save()
Group eaStaff = GroupFinder.findByName(gs, "basis:hr:employee:dept:10830:staff", true)
sensitiveData.addMember(eaStaff.toSubject(), true)

Calendar cal = Calendar.getInstance();
cal.setTime(new Date());
cal.add(Calendar.DAY_OF_YEAR, 2);
mfaEnabledAllow.addOrEditMember(sensitiveData.toSubject(), true, true, cal.time, null, false)

// subtract faculty

Group sensitiveDataNoFaculty = new GroupSave(gs).assignName("app:mfa:service:ref:sensitive_no_faculty").save()
Group allFaculty = GroupFinder.findByName(gs, "ref:role:emp:faculty", true)
sensitiveDataNoFaculty.addCompositeMember(CompositeType.COMPLEMENT, sensitiveData, allFaculty)
mfaEnabledAllow.addOrEditMember(sensitiveDataNoFaculty.toSubject(), true, true, cal.time, null, false)
mfaEnabledAllow.deleteMember(sensitiveData.toSubject())


/***** 401.4 MFA Policy Governance part 2 *****/

Group mfaOptIn = new GroupSave(gs).assignName("app:mfa:service:ref:mfa_opt_in").save()
mfaEnabledAllow.addMember(mfaOptIn.toSubject(), false)


Stem policyStem = StemFinder.findByName(gs, "app:mfa:security", true)
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
        "mfa_opt_in_access",
        "mfa_opt_in_access",
        "Users with opt-in privileges",
        myServiceActionIds
)

Group mfaOptInAllowSec = GroupFinder.findByName(gs, "app:mfa:security:mfa_opt_in_access_allow", true)
["ref:role:emp:staff", "ref:role:emp:faculty", "ref:student:students"].each {
    Group allX = GroupFinder.findByName(gs, it, true)
    mfaOptInAllowSec.addMember(allX.toSubject(), false)
}

Group mfaOptInSec = GroupFinder.findByName(gs, "app:mfa:security:mfa_opt_in_access", true)
mfaOptIn.grantPriv(mfaOptInSec.toSubject(), AccessPrivilege.OPTIN)
mfaOptIn.grantPriv(mfaOptInSec.toSubject(), AccessPrivilege.OPTOUT)


// app:mfa:ref:mfa_required

Group mfaRequired = new GroupSave(gs).assignName("app:mfa:service:ref:mfa_required").save()
mfaEnabledAllow.addMember(mfaRequired.toSubject(), false)

[
        sensitiveDataNoFaculty.name,
        "basis:hr:employee:dept:10904:staff",
        "basis:hr:employee:dept:10902:staff",
        "basis:hr:employee:dept:10903:staff",
        peerCounselRef.name,
        mfaPilotRef.name
].each {
    Group g = GroupFinder.findByName(gs, it, true)
    mfaRequired.addMember(g.toSubject(), false)
    mfaEnabledAllow.deleteMember(g.toSubject())
}


// Users that are required to use MFA can not opt-in/out.

Group optinAccessDeny = GroupFinder.findByName(gs, "app:mfa:security:mfa_opt_in_access_deny", true)
optinAccessDeny.addMember(mfaRequired.toSubject(), false)


// Add all faculty, staff, and students to policy

List<Subject> currentMembers = mfaEnabledAllow.immediateMembers.collect {it.subject}

["ref:role:emp:staff", "ref:role:emp:faculty", "ref:student:students"].each {
    Group g = GroupFinder.findByName(gs, it, true)
    mfaEnabledAllow.addMember(g.toSubject(), false)
}

currentMembers.each {
    mfaEnabledAllow.deleteMember(it)
}
