If you're not a developer, please go away now.

## Developers -- getting started

0. Clone this repo
0. Change into app's root directory
0. Run `bundle` to make sure you have all gems/libraries
0. Install PhantomJS to run JavaScript tests headlessly:
  1. Mac OS with [homebrew](http://brew.sh): `brew install phantomjs`
  1. Other cases: [download here](phantomjs.org/download.html)
0. Install Google Chrome and `chromedriver` for certain Cucumber tests
that require it:
  1. Mac OS with [homebrew](http://brew.sh): `brew install chromedriver`
  1. Mac OS without homebrew, or other platforms:   
  [Download here](https://code.google.com/p/selenium/wiki/ChromeDriver), but in
  general, after download `sudo mv chromedriver /usr/bin/` and `sudo chmod +x /usr/bin/chromedriver`
0. First time: run `rake db:migrate db:seed` to create your development
database, populate its schema, and insert any initial data
0. run `gem install foreman` to install foreman
0. `foreman run local` to start the app
0. It should now be live on `http://localhost:3000`

## Deploying to master

0. Before you do any merging:  go back to master and do a git pull to make sure you have latest master
0. Then switch back into your branch and rebase against master, fixing any conflicts, and making sure all your tests are passing.
0. Running `make check` will delete your development database (works
correctly even if you are on a branch other than master) and will then run:

```bash
rm -rf tmp/      # deletes any cached assets
rake db:migrate  # reconstructs DB "clean" from schema
rake db:seed     # loads fixed data
rake db:test:prepare  # loads DB schema into test database
rake cucumber    # runs all scenarios
rake spec        # runs all specs, including javascript
```

to verify that there is no bug introduced
0. Then do pull request

## To deploy on Heroku for your own staging:

0. First time: `heroku app:create pick-some-app-name`
0. First time: `heroku labs:enable websockets` to enable websockets for chat app
0. Make sure your changes are committed locally
0. `git push heroku master`
0. Your app should now be live at `http://pick-some-app-name.herokuapp.com`
0. If you get an application failed error message, try 'heroku run rake db:migrate' then refresh page

## Testing your JavaScript

See the JavaScript chapter in the book for how to write JS tests using
Jasmine.  It's almost exactly like writing RSpec.

0. You can add tests in `spec/javascripts/*.js` or `*.js.coffee`
0. To run tests with browser GUI: start the app locally (`foreman run
local` or even just `rails s`), then go to `http://localhost:3000`; each
time you re-load this page, it re-runs all your JS specs
0. To run tests from command line: `rake spec:javascript`

## Other useful tasks

**Do not push code that causes these tasks to fail!**

* `git push heroku master` deploys on Heroku; don't push code that
cannot be deployed
* `rake diagram:all` creates three `.svg` picture files in `doc/` that
contain the app's class diagrams.  The most interesting is probably `doc/models_complete.svg`
* `rake spec` runs all unit and functional tests
* `rake spec:javascript` runs all JavaScript tests in headless mode
* `rake cucumber` runs all features that should pass (user stories)
* `rake metrics:all` generates a bunch of metrics; to see them, open
`./tmp/metric_fu/output/index.html` in a browser after running this
command
* [CodeClimate code
quality](https://codeclimate.com/github/ucberkeley/moocchat) for this project

