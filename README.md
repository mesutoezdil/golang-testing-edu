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
 t.Fail()
 t.Error(...interface{})
 t.Errorf(string, ...interface{})
2- immediate failures
 t.FailNow{}
 t.Fatal(...interface{})
 t.Fatalf(string, interface{})

WHY ARE ASSERTIONS MISSING

1- reduce learning curve
------------------------
func TechThing(t *testing.T) {
  l, r := 2, 4
  expect := 6

  got := l + r

  if got != expect {
    // report failure
  } 
 }

Checking for test failures uses same constructs as production code. If you can write production code, you can write tests.


2- focus on common concerns
-----------------------------
func TechThing(t *testing.T) {
  l, r := 2, 4
  expect := 6

  got := l + r

  assert.Equal(got, expect)         // assertion style
  Expect(expect).To(Equal(got))     // expect style
 }
Both styles are equally valid and subject to team preference

WHITE VS BLACK BOX TESTS
------------------------
w test has access to all tested code
w tests in same package as production code
b test can only interact via public api
b tests in separate package



go test -cover                        run tests with basic coverage stats

go test -coverprofile cover.out       generate coverage report to cover.out

go tool cover                         analyse coverage report

go test -coverprofile cover.out       set cover mode
  -covermode count
                                      set - is statement executed
                                      count - execution count
                                      atomic - execution count (threadsafe)

How to use code coverage reports:
- do use code coverage to find missed/uncovered code
- do not use code coverage as an indicator of how good tests are

Benchmarking Tests
--------------------
Tests are used to confirm the correctness of the application. Benchmarks are used to determine how performant the app is. 

func BenchmarkFoo(b *testing.B) {             Benchmark test signature
        //setup code
        b.ResetTimer()                        Reset benchmark timer
        for i := 0; i < b.N; i++ {
          ...
        }
        b.StopTimer                           Stop benchmark timer
        //tear down code
}      

go test -bench .                              Include benchmark tests in test run

go test -bench . -benchmem                    Include memory allocations in results

go test -bench . -benchtime 1m                Tune b.N to run tests for approx. 1 minute


FUZZING
In programming and software development, fuzzing or fuzz testing is an automated software testing technique that involves providing invalid, unexpected, or random data as inputs to a computer program.

func FuzzFoo(f *testing.F) {                 Prefix test with "Fuzz"
  f.Add(...args)                             Add arguments in order they should be passed to fuzz test

                                             - string, []byte
                                             - int, int8, int16, int32, int64
                                             - uint, uint8, uint32, uint64
                                             - float32, float64
                                             - bool
  
  f.Fuzz(func(t *testing.T, ...args) {        One and only one f.Fuzz per test
    // arrange                                Tests run in parallel - do not test shared memory!
    // act                                    Arguments controlled made against arguments
    // assert                                 Assertions typically made against arguments
  })
}
go test -fuzz regexp                          Run fuzz tests matching regular expression
                                              Failed tests stored in
                                              ./testdata/fuzz/{FuzzTestName}
