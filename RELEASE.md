Releasing NCS Navigator Field
==============================

Test
----
1. Change Bundle Name to 'NavField (Test)' (long and short)
1. Change Bundle Version with format 'x.x' or 'x.x.x' (long and short)
1. Change Bundle Identifier to 'edu.northwestern.nubic.NCS-NavField-Test'
1. Change icon to icon-test.png
1. `git pull`
1. `rm -rf Pods && pod install`
1. `cp RKRequest.0.10.2.fixed.m Pods/RestKit/Code/Network/RKRequest.m`
1. Archive
1. Create the ipa and save in /dist with NavFieldTest-x.x.ipa or NavFieldTest-x.x.x.ipa
1. Commit the project file with the new version and the ipa file
1. Create a tag for the release
1. g push && g push --tags
1. Upload ipa to download.nubic.northwestern.edu/ncs_navigator_field_test
1. Email NCS-NU-TECHNICAL@LISTSERV.IT.NORTHWESTERN.EDU about new release

Production
----------
1. `git co v<x.x.x>`
1. Change Bundle Name to 'NavField' (long and short) in NCSNavField-Info.plist
1. Change Bundle Version with format 'x.x' or 'x.x.x' (long and short) in NCSNavField-Info.plist
1. Change Bundle Identifier to 'edu.northwestern.nubic.NCS-NavField'
1. Change icon to icon.png
1. `rm -rf Pods && pod install`
1. `cp RKRequest.0.10.2.fixed.m Pods/RestKit/Code/Network/RKRequest.m`
1. Archive
1. Create the ipa and save in /dist with NavField-x.x.ipa or NavField-x.x.x.ipa
1. Checkout master
1. Commit the new version and the ipa file
1. g push 
1. Upload ipa to download.nubic.northwestern.edu/ncs_navigator_field
1. Email NCS-NU-TECHNICAL@LISTSERV.IT.NORTHWESTERN.EDU about new release
