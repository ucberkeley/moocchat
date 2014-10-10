Load provisioning for the Rails app
===================================

This file describes how the Rails app is deployed and load-tested on Heroku.

The [Puma HTTP server](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server) is both multiprocess and multithreaded.
We currently use it in single-process, multithreaded mode.  (A single
Heroku dyno is essentially a lightweight VM so it could support
multiproces mode, but in our current architecture the chat server part
of the app cannot be replicated at the process level since it manages
global state.)

The following files and settings are involved in load provisioning:

* The environment variable `PUMA_THREADS` (which defaults to 16 if not
  explicitly set for Heroku) controls how many threads.  It is used in
  `Procfile` when the Puma webserver is started.  To experiment with
  another value, say `heroku config:set PUMA_THREADS=10` (for example) and
  then `heroku ps:restart` to restart the app.  (Actually Puma supports
  setting a minimum and maximum number of threads, but since there's no
  particular benefit to a dyno releasing resources, we set min and max to
  same value to create all threads immediately and leave them active.)

* `config/environments/production.rb` sets `config.threadsafe!`, which
allows Rack and Rails to run multithreaded.  (Without this, Rack puts a
mutex around every request, negating the benefit of multithreaded mode.)
Note that this means we promise our app code is thread-safe.

* By default, ActiveRecord's connection pool contains a single socket.
But since each thread can try to access the database, in a multithreaded
environment [we need as many database connections in the pool as there
are threads](https://devcenter.heroku.com/articles/concurrency-and-database-connections). `config/initializers/puma_database_connection.rb` closes
the default AR connection pool and sets up a new one with the right
number of connections.  Heroku [limits us to 20 connections](https://addons.heroku.com/heroku-postgresql) on
non-enterprise database plans.



Results
=======

* I benchmarked the `POST` to `TasksController#create` as of master commit
061a45, which was identified by NewRelic monitoring as the most
expensive operation.

* I used `httperf` running on an Amazon EC2 small instance (see
`rpmforge.repo` file for how to install it on 
RedHat) to create a total of 1000 tasks, varying the rate of
task-creation arrival.  `httperf` reports min, max, median, and stdev of
service time in ms; I report them in seconds.  `httperf` also reports
what percent of connections failed due to timeout; any number greater
than 0 is basically bad.  I set the timeout fail threshold to 10
seconds, because Heroku has a 10-second timeout that *may* trigger on
long-running requests.

## 16 threads, 1 dyno, batch of tasks arrive simultaneously each second

| tasks/sec | run | min | max | median | stdev | timeout | fail% |
|        10 |   1 |     |     |        |       |         |       |
|        16 |     | 1.3 | 9.9 |    4.9 |   2.4 |      10 |   14% |
|        16 |     |     |     |        |       |         |       |
