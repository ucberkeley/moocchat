If you're not a developer, please go away now.

## Development methodology -- read me first

0. We use branch-per-feature for development, so that master is always
clean and ready to deploy.  **NEVER PUSH MASTER THAT HAS FAILING TESTS.
EVER.**  See below for how to run tests.  The main repo is
`ucberkeley/moocchat` on GitHub. 
0. We use [Pivotal
Tracker](https://www.pivotaltracker.com/s/projects/1100148) to track
features, bugs, releases, etc.
0. Branch naming convention is `feature/XX/name-of-feature` (where XX
are initials of developer, eg "AF") for new features,
`bug/XX/description-of-bug` for bug fixes,
`test/XX/description-of-test` for changes that add test coverage, etc.
0. We are using [CodeClimate to monitor our code
quality](https://codeclimate.com/github/ucberkeley/moocchat)

## Developers -- detailed setting up on a fresh Ubuntu 14.04.1 install

0. `sudo apt-get update && sudo apt-get upgrade`
0. `mkdir .ssh`
0. Install your SSH key for Github in `~/.ssh/id_rsa`
0. `chmod 600 ~/.ssh/id_rsa`
0. `sudo apt-get install git curl libpq-dev phantomjs chromium-chromedriver python-selenium nodejs`
0. `sudo ln -s /usr/lib/chromium-browser/chromedriver /usr/bin/chromedriver`
0. `sudo ln -s /usr/lib/chromium-browser/libs/lib*.so /usr/lib/`
0. `curl -sSL https://get.rvm.io | bash`
0. `source ~/.rvm/scripts/rvm`
0. `git clone git@github.com:ucberkeley/moocchat.git`
0. `cd moocchat`
0. `rvm install ruby-1.9.3-p547`
0. `bundle install`
0. `make check`
0. `foreman run local`
0. Access http://localhost:3000 in a web browser to try the app.

## Developers -- getting started on other systems

0. Clone this repo
0. Change into app's root directory
0. Run `bundle install` to make sure you have all gems/libraries
0. Install PhantomJS to run JavaScript tests headlessly:
  1. Mac OS with [homebrew](http://brew.sh): `brew install phantomjs`
  1. Other cases: [download here](phantomjs.org/download.html)
0. Install Google Chrome and `chromedriver` for certain Cucumber tests
that require it:
  1. Mac OS with [homebrew](http://brew.sh): `brew install chromedriver`
  1. Mac OS without homebrew, or other platforms:   
  [Download here](https://code.google.com/p/selenium/wiki/ChromeDriver), but in
  general, after download `sudo mv chromedriver /usr/bin/` and `sudo chmod +x /usr/bin/chromedriver`;
0. Run `make check` (that's make, not rake) to create development
database, populate its schema, insert any initial data, and run
regression tests to make sure all is well (see below under Deploying)
0. `foreman run local` to start the app
0. It should now be live on `http://localhost:3000`

## Pushing to master

0. Before you do any merging:  go back to master and do a git pull to make sure you have latest master
0. Then switch back into your branch and rebase against master, fixing any conflicts, and making sure all your tests are passing.
0. Running `make check` will run the following, which "clean-tests" your branch:

```bash
rm -rf tmp/      # deletes any cached assets
rake db:schema:load  # recreates fresh set of empty tables in DB
rake db:seed     # loads fixed data
rake db:test:prepare  # loads DB schema into test database
rake cucumber    # runs all scenarios
rake spec        # runs all specs, including javascript
```

to verify that there is no bug introduced
0. Then do pull request on your rebased branch

## To deploy on Heroku for your own testing:

0. First time: `heroku apps:create pick-some-app-name`
0. Make sure your changes are committed locally
0. `git push heroku master`
0. The first time you deploy, you must also `heroku run rake db:migrate`
to setup the database, and `heroku run rake db:seed` to populate it with
necessary initial data.  (**Warning:**  the `db:seed` task wipes the
database before re-seeding it, so don't use it if you want to preserve
existing data!)
0. Your app should now be live at `http://pick-some-app-name.herokuapp.com`
0. If you get an application failed error message, try 'heroku run rake db:migrate' then refresh page

## Testing your JavaScript

0. You can add tests in `spec/javascripts/*.js` or `*.js.coffee`
0. To run tests with browser GUI: start the app locally (`foreman start`)
then go to `http://localhost:5000`; each
time you re-load this page, it re-runs all your JS specs
0. To run tests from command line: `rake spec:javascript` (uses
`phantomjs`) 

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

## The Heroku production deployment

The app is hosted on Armando's Heroku account as
`moocchat.herokuapp.com`.

We have [extended monitoring](https://devcenter.heroku.com/articles/log-runtime-metrics) 
turned on to help troubleshoot system load issues.  `heroku logs --tail`
shows them.

NewRelic APM (application performance monitoring) is turned on.  In
the app's [Heroku resources
dashboard](https://dashboard-next.heroku.com/apps/moocchat/resources),  
click New Relic.
