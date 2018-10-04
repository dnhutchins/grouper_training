
GrouperSession.startRootSession()

//ex 201.2.2
addStem("ref", "employee", "employee")
addGroup("ref:employee", "fac_staff", "fac_staff")
addMember("app:vpn:vpn_allow", "ref:employee:fac_staff")

addStem("ref", "security", "security")
addGroup("ref:security", "locked_by_cisco", "locked_by_cisco")
addMember("app:vpn:vpn_deny", "ref:security:locked_by_cisco")

addStem("ref", "iam", "iam")
addGroup("ref:iam", "closure", "closure")
addMember("app:vpn:vpn_deny", "ref:iam:closure")

//ex 201.2.3
addStem("org", "irb", "irb")
addStem("org:irb", "ref", "ref")
addGroup("org:irb:ref", "irb_members", "irb_members")
addMember("app:vpn:vpn_allow", "org:irb:ref:irb_members")
addMember("org:irb:ref:irb_members", "jsmith")

//ex 201.2.4
addStem("ref", "app", "app")
addStem("ref:app", "vpn", "vpn")
addStem("ref:app:vpn", "etc", "etc")
addGroup("ref:app:vpn:etc", "vpn_admins", "vpn_admins")

grantPriv("ref:app:vpn", "ref:app:vpn:etc:vpn_admins", NamingPrivilege.STEM)