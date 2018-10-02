
GrouperSession.startRootSession()

addStem("app", "vpn", "vpn")
addGroup("app:vpn", "vpn_authorized", "vpn_authorized")
addGroup("app:vpn", "vpn_allow", "vpn_allow")
addGroup("app:vpn", "vpn_deny", "vpn_deny")

addComposite("app:vpn:vpn_authorized", CompositeType.COMPLEMENT, "app:vpn:vpn_allow", "app:vpn:vpn_deny")