If you're not a developer, please go away now.

## Developers -- getting started

0. Clone this repo
0. Change into app's root directory
0. Run `bundle` to make sure you have all gems/libraries
0. Install Google Chrome and `chromedriver` for certain Cucumber tests
that require it:
  1. Mac OS with [homebrew](http://brew.sh): `brew install chromedriver`
  1. Mac OS without homebrew, or other platforms:   [Download and
  instructions are
  here](https://code.google.com/p/selenium/wiki/ChromeDriver), but in
  general, after download `sudo mv chromedriver /usr/bin/` and `sudo chmod +x /usr/bin/chromedriver`
0. First time: run `rake db:migrate db:seed` to create your development
database, populate its schema, and insert any initial data
0. run `gem install foreman` to install foreman
0. `foreman run local` to start the app
0. It should now be live on `http://localhost:3000`

## To deploy on Heroku for your own staging:

0. First time: `heroku app:create pick-some-app-name`
0. First time: `heroku labs:enable websockets` to enable websockets for chat app
0. Make sure your changes are committed locally
0. `git push heroku master`
0. Your app should now be live at `http://pick-some-app-name.herokuapp.com`
0. If you get an application failed error message, try 'heroku run rake db:migrate' then refresh page

## Other useful tasks

**Do not push code that causes these tasks to fail!**

* `git push heroku master` deploys on Heroku; don't push code that
cannot be deployed
* `rake diagram:all` creates three `.svg` picture files in `doc/` that
contain the app's class diagrams.  The most interesting is probably `doc/models_complete.svg`
* `rake spec` runs all unit and functional tests
* `rake cucumber` runs all features that should pass (user stories)
* `rake metrics:all` generates a bunch of metrics; to see them, open
`./tmp/metric_fu/output/index.html` in a browser after running this
command
* [CodeClimate code
quality](https://codeclimate.com/github/ucberkeley/moocchat) for this project


