GrouperSession.startRootSession()
delStem("201.2.1")
addRootStem("201.2.end", "201.2.end")

addStem("app", "vpn", "vpn")
addStem("app:vpn", "service", "service")
addStem("app:vpn", "security", "security")
addStem("app:vpn:service", "policy", "policy")
addStem("app:vpn:service", "ref", "ref")
addStem("app:vpn:service", "attributes", "attributes")

addGroup("app:vpn:service:policy", "vpn_access", "vpn_access")
addGroup("app:vpn:service:policy", "vpn_access_allow", "vpn_access_allow")
addGroup("app:vpn:service:policy", "vpn_access_deny", "vpn_access_deny")
addComposite("app:vpn:service:policy:vpn_access", CompositeType.COMPLEMENT, "app:vpn:service:policy:vpn_access_allow", "app:vpn:service:policy:vpn_access_deny")

addGroup("app:vpn:security", "vpnAdmins", "vpnAdmins")
addGroup("app:vpn:security", "vpnReaders", "vpnReaders")
addGroup("app:vpn:security", "vpnUpdaters", "vpnUpdaters")
grantPriv("app:vpn", "app:vpn:security:vpnAdmins", NamingPrivilege.STEM)

grantPriv("app:vpn:service:policy:vpn_access_allow", "app:vpn:security:vpnAdmins", AccessPrivilege.ADMIN)
grantPriv("app:vpn:service:policy:vpn_access_allow", "app:vpn:security:vpnUpdaters", AccessPrivilege.UPDATE)
grantPriv("app:vpn:service:policy:vpn_access_allow", "app:vpn:security:vpnReaders", AccessPrivilege.READ)

//ex 201.2.2
addMember("app:vpn:service:policy:vpn_access_allow", "ref:employee:fac_staff")
addMember("app:vpn:service:policy:vpn_access_deny", "ref:security:locked_by_ciso")
addMember("app:vpn:service:policy:vpn_access_deny", "ref:iam:closure")

//ex 201.2.3
addMember("app:vpn:service:policy:vpn_access_allow", "org:irb:ref:irb_members")
addMember("org:irb:ref:irb_members", "jsmith")
