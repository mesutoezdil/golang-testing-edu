why write tests?
1- initial build -> ensure correctness of app
2- production -> identify errors before users are impacted
3- enhancements -> prevent new development from breaking older features

testing support in go
1- test runner
2- testing api
3- assertion/expectation api (there is no such thing in golang)

the testing pyramid:
1- unit: prove that individual units of logic are correct
2- component: confirm that different app concerns (i.e. package) perform correctly
3- integration: validate that entire program works as expected
4- end to end: demonstrate that entire system works correctly together

communicate with test runner
1- report failures
2- logging
3- configure how test is executed
4- interact with environment
! No assertions

reporting test failures
1- non-immediate failures
# t.Fail()
# t.Error(...interface{})
# t.Errorf(string, ...interface{})
2- immediate failures
# t.FailNow{}
# t.Fatal(...interface{})
# t.Fatalf(string, interface{})

