NCS Navigator Field
===================

This is an ios application which assists field workers in data collection for the National Children's Study. 

Configuration
-------------

1. `cd ncs_navigator_field`
1. git submodule init
1. git submodule update
1. Copy NUCas/NUCas.plist-sample to NUCas.plist
1. Update cas.base.url, cas.retrieve.url, and cas.receive.url in NUCas.plist
1. `wget http://curl.haxx.se/ca/cacert.pem`
1. `gem install cocoapods`
1. `pod setup`
1. `mkdir -p ~/.cocoapods/master/RestKit/0.9.4`
1. `cp RestKit-Custom-0.9.4.podspec ~/.cocoapods/master/RestKit/0.9.4/RestKit.podspec`
1. `pod install`
1. Open NCSMobile.xcworkspace and change the Pods deploy target to 5.0 (Pods Project -> Build Settings -> Deploy Target)

Testing
-------

NCS Navigator Field currently only supports pulling data from the ncs core services stub service located in the ncs-core-stub subdirectory.

To run this you need to:

1. Have a working ruby and rubygems installation
2. Change directory to ncs-core-stub
<pre>cd ncs-core-stub</pre>
3. Install the bundler rubygem
<pre>gem install bundler</pre>
4. Install dependent gems
<pre>bundle install</pre>
5. Start the NCS Core Services Stub
<pre>./run.sh</pre>

