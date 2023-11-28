why write tests?
1- initial build -> ensure correctness of aoo
2- production -> identify errors before users are impacted
3- enhancements -> prevent new development from breaking older features

testing support in go
1- test runner
2- testing api
3- assertion/expectation api

the testing pyramid:
1- unit: prove that individual units of logic are correct
2- component: confirm that different app concerns (i.e. package) perform correctly
3- integration: validate that entire program works as expected
4- end to end: demonstrate that entire system works correctly together
