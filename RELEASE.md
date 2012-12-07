Releasing NCS Navigator Field
==============================

Test
----
1. Change Bundle Name to 'NavField (Test)' (long and short)
1. Change Bundle Version with format 'x.x' or 'x.x.x' (long and short)
1. Change Bundle Identifier to 'edu.northwestern.nubic.NCS-NavField-Test'
1. Change icon to icon-test.png
1. Archive
1. Create the ipa and save in /dist with NavFieldTest-x.x.ipa or NavFieldTest-x.x.x.ipa
1. Commit the project file with the new version and the ipa file
1. Create a tag for the release
1. g push && g push --tags
1. Upload ipa to download.nubic.northwestern.edu/ncs_navigator_field_test
1. Upload ipa and dSYM to TestFlight
1. Email NCS-NU-TECHNICAL@LISTSERV.IT.NORTHWESTERN.EDU about new release

Production
----------
