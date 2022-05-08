TODO
=====


202205
-------
- Once upgrading to 2.6.9, can remove gsh code marked "Temporary fix for GRP-4024" from bootstrap.gsh files
- Bug in 2.6.8, attr_read isn't enough to see attributes; need admin privileges on the object to see the option in the menu
- 301.6 and 301.7 slides need to be finished
- 301.8 view privilege on the App folder not enough for kjenkins to view; needs create priv

202202
-------

- (NO IT REQUIRES JAVA 11+) Upgrade Shibboleth IDP to latest 4.1.4 (low priority). But the configs have been modified to reduce warnings
- How to get rid of the LDAP warnings that come up the first time the page comes up?
- The All Faculty/Staff group is missing the ref type
- Fix this error

        Loading class `com.mysql.jdbc.Driver'. This is deprecated. The new driver class is `com.mysql.cj.jdbc.Driver'. The driver is automatically registered via the SPI and manual loading of the driver class is generally unnecessary.
- Main wiki page doesn't have a link to container configure, install, etc.
- Add a gsh report to 401.2

Slide updates:
201.1.1
- Years need to be +1. Then grace period graduate should be 9 months (end date 2022/03/01)
201.1.2
- The slide says exchange students are not in SIS. Are they a loaded basis group, ref group, what?
- Should transfer students be a basis group? Is there such a thing as an ad hoc basis group?
- slide 6, why is Create Digital Policy there twice?
- should we do away with the All Staff being a rollup of 100's of groups? Hard to see visualization that way
201.2
- Add some visualization steps to easily understand the app structure
- (DONE) Already has an All Faculty/Staff group, don't need to add faculty and staff separately
201.3
- We can either add the type to the policy folder, or autoassign types to the folder above, which will do the same
- the ePA_full_sync daemon job has already been created
201.5
- (DONE) ref:role:financeManager needs to add the ref type
- after adding Carrie Campbell, should go to the policy group to show it's there


211.3
- TEST: What privs do you need to add an assignment to an assignment
