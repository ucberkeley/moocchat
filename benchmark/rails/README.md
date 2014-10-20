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

* I used `httperf` running on an Amazon EC2 small instance
to create a total of 1000 tasks, varying the rate of
task-creation arrival.  I ran each experiment four times without
clearing out the tasks table in between, to see if the length of the
table made a difference.
`httperf` reports min, max, median, and stdev of
service time in ms; I report them in seconds.

The table below shows:

* rate - number of tasks arriving simultaneously per second.  In real
life, the server tries to smooth out task arrivals by not having all
waiting rooms expire exactly at the same time, so this experiment is
somewhat pessimistic.

* run - I ran each rate experiment 4 times

* min, max, median, stdev - response times in seconds over 1000 requests

* fail% - percent of requests that timed out (exceeded Heroku's 10s
timeout threshold).  Basically anything above 0 is bad, because those users
would see hard errors and would have to reload the page (if they're so
inclined). 

* time - total time (seconds) to run the experiment.  
This number times the rate should equal the total number of successful
requests. 

## 16 threads, 1 dyno, batch of tasks arrive simultaneously each second

| run | rate | min |  max |  med | stdv | fail% | dur |
|   1 |   10 | 0.1 |  4.2 |  0.2 |  0.3 |     0 | 100 |
|   2 |   10 | 0.1 |  3.5 |  0.2 |  0.3 |     0 | 100 |
|   3 |   10 | 0.1 |  2.1 |  0.3 |  0.3 |     0 | 100 |
|   4 |   10 | 0.1 |  7.1 |  0.3 |  1.6 |     0 | 106 |
|   1 |   11 | 1.6 | 15.6 | 10.6 |  3.4 |     0 |  99 |
|   2 |   11 | 0.1 |  2.2 |  0.3 |  0.4 |     0 |  92 |
|   3 |   11 | 0.1 |  2.3 |  0.3 |  0.3 |     0 |  91 |
|   4 |   11 | 0.1 |  2.0 |  0.3 |  0.2 |     0 |  91 |
|   1 |   12 | 0.1 |  2.3 |  0.5 |  0.6 |     0 |  84 |
|   2 |   12 | 0.1 |  1.7 |  0.3 |  0.3 |     0 |  83 |
|   3 |   12 | 0.1 |  3.1 |  1.2 |  0.8 |     0 |  85 |
|   4 |   12 | 0.2 |  6.3 |  2.6 |  1.9 |     0 |  86 |
|   1 |   13 | 0.2 | 14.0 | 10.9 |  4.2 |     0 |  85 |
|   2 |   13 | 0.1 |  6.1 |  0.4 |  1.6 |     0 |  82 |
|   3 |   13 | 0.1 |  6.0 |  2.0 |  1.7 |     0 |  82 |
|   4 |   13 | 0.2 | 10.0 |  7.9 |  2.2 |     0 |  85 |
|   1 |   14 | 0.1 |  1.6 |  0.2 |  0.2 |     0 |  72 |
|   2 |   14 | 0.1 |  6.3 |  1.0 |  1.2 |     0 |  77 |
|   3 |   14 | 1.1 |  6.5 |  5.3 |  0.8 |     0 |  76 |
|   4 |   14 | 0.1 | 15.0 |  5.6 |  5.3 |     0 |  85 |
|   1 |   15 | 0.2 |  6.3 |  4.6 |  1.6 |     0 |  72 |
|   2 |   15 | 0.8 | 10.7 |  6.9 |  2.9 |     0 |  77 |
|   3 |   15 | 0.2 | 14.7 |  4.2 |  3.2 |     0 |  76 |
|   4 |   15 | 0.2 | 10.7 |  7.8 |  3.0 |     0 |  76 |
|   1 |   16 | 0.1 |  8.3 |  1.1 |  1.4 |     0 |  67 |
|   2 |   16 | 0.1 |  5.1 |  2.9 |  1.2 |     0 |  66 |
|   1 |   17 | 0.2 | 10.0 |  5.9 |  3.0 |    19 |  69 |
|   2 |   17 | 0.2 |  8.0 |  2.6 |  2.4 |     0 |  66 |
|   3 |   17 | 0.3 | 17.9 |  9.3 |  5.3 |     0 |  76 |
|   1 |   18 | 0.3 | 17.3 |  8.3 |  5.0 |     0 |  72 |
|   2 |   18 | 0.1 | 13.8 |  5.5 |  4.4 |     0 |  69 |
|   3 |   18 | 0.2 | 20.6 |  8.2 |  5.7 |     0 |  76 |


Still to be determined
======================

* Can we get the same performance with fewer threads?  Threads buys us
concurrency inside a process---we can only switch threads when another
thread is waiting on the database---but to get rid of queueing beyond
that, we need more worker processes.  However, we're limited to 20
database connections overall, so fewer threads per worker would allow us
to have more than one worker.

* Why so much noise (high stdev) in the measurements at lower loads, and
only during some runs?
