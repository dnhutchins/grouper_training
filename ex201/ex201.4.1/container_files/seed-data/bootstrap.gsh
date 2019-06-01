gs = GrouperSession.startRootSession()
delStem("201.3.end")
addRootStem("201.4.1", "201.4.1")

global_deny = addGroup("ref:iam", "global_deny", "global_deny");
AttributeDefName typeMarker = AttributeDefNameFinder.findByName("etc:objectTypes:grouperObjectTypeMarker", true);
AttributeAssign attributeAssign = global_deny.getAttributeDelegate().hasAttribute(typeMarker) ? global_deny.getAttributeDelegate().retrieveAssignments(typeMarker).iterator().next() : global_deny.getAttributeDelegate().addAttribute(typeMarker).getAttributeAssign();
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDirectAssignment", "true");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeName", "ref");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeDataOwner",
"Identity and Access Management");
attributeAssign.getAttributeValueDelegate().assignValue("etc:objectTypes:grouperObjectTypeMembersDescription",
"Global deny group");