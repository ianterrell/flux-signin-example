## Nimble-Snapshots Testing

### Installation
Add Nimble-Snapshots to the tests target of the projects podfile.
Run `pod install`. This will install Nimble-Snapshots and all of its dependencies.


### Testing
To start, an environment variable will need to be added in order for the tests to find reference images.
Add name `FB_REFERENCE_IMAGE_DIR` with value `$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages` or where reference images should be stored.

Within a test file, make sure to import the following

    import Nimble
    import Quick
    import Nimble_Snapshots
    import UIKit

Once imported, testing can begin. Using Nimble syntax, a view can be set up to test it has the correct styling.

Example code:

    class MySpec: QuickSpec {
      override func spec() {
          describe("in some context", { () -> () in
              it("has valid snapshot") {
                  let view = ... // some view to test
                  expect(view).to( haveValidSnapshot() )
              }
          });
      }
    }

The `haveValidSnapshot()` method grabs the reference image specific to the test and compares it with the view specified before.

Before running tests with `haveValidSnapshot()`, there needs to be reference images to compare against. Replace all instances of `haveValidSnapshot()` with `recordSnapshot()` and run once. This will create images from the views and put them in the directory specified in the `FB_REFERENCE_IMAGE_DIR` variable. Replace `recordSnapshot()` with `haveValidSnapshot()` and testing can begin.

The tests will continue to pass when the view matches the reference image. However, when they do not match - the test case fails. The console log will contain a terminal command to launch Kaleidoscope (a file comparison tool) to view the reference next to the failed view. If Kaleidoscope is not installed, the name of the failed view with a path to its location can be found in the command.
