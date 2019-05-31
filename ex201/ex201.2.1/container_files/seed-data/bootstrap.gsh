GrouperSession.startRootSession()
delStem("201.1.end")
addRootStem("201.2.1", "201.2.1")

// should be a loader job?
addStem("ref", "employee", "employee")
fac_staff = addGroup("ref:employee", "fac_staff", "fac_staff")

// Set ref object type on fac_staff reference group
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = fac_staff.getAttributeDelegate().hasAttribute(typeMarker) ? fac_staff.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : fac_staff.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"HR and Provost Office");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"All faculty and staff");

addStem("ref", "security", "security")
locked_by_ciso = addGroup("ref:security", "locked_by_ciso", "locked_by_ciso")
AttributeAssign attributeAssign = locked_by_ciso.getAttributeDelegate().hasAttribute(typeMarker) ? locked_by_ciso.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : locked_by_ciso.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"CISO");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Subjects denied access by CISO");

addStem("ref", "iam", "iam")
closure = addGroup("ref:iam", "closure", "closure")
AttributeAssign attributeAssign = closure.getAttributeDelegate().hasAttribute(typeMarker) ? closure.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : closure.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"IAM");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Accounts in the process of being closed");

addStem("org", "irb", "irb")
addStem("org:irb", "ref", "ref")
irb_members = addGroup("org:irb:ref", "irb_members", "irb_members")
AttributeAssign attributeAssign = irb_members.getAttributeDelegate().hasAttribute(typeMarker) ? irb_members.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : irb_members.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"Institutional Review Board");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Members of the IRB");

