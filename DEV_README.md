# Airship iOS Gimbal Adapter

## To Release
- create a release branch using the updated version number
- increment the adapter version in the podspec
- update the Changelog
- notify QA of availability for testing
- commit any outstanding changes
- push outstanding commits
- create a tag corresponding the the updated version
- push the tag
- run `pod spec lint`
- if tests pass, run `pod trunk push` 
