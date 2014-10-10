Load provisioning for the Rails app
===================================

This file describes how the Rails app is deployed and load-tested.

The Puma HTTP server is both multiprocess and multithreaded.
We currently use it in single-process, multithreaded mode.  (A single
Heroku dyno is essentially a lightweight VM so it could support
multiproces mode, but in our current architecture the chat server part
of the app cannot be replicated at the process level since it manages
global state.)

The following files and settings are involved in load provisioning:

* The environment variable `PUMA_THREADS` (which defaults to 16 if not
explicitly set for Heroku) controls how many threads.  It is used in
`Procfile` when the Puma webserver is started.

* `config/environments/production.rb` sets `config.threadsafe!`, which
allows Rack and Rails to run multithreaded.  (Without this, Rack puts a
mutex around every request, negating the benefit of multithreaded mode.)
Note that this means we promise our app code is thread-safe.

* By default, ActiveRecord's connection pool contains a single socket.
But since each thread can try to access the database, in a multithreaded
environment we need as many database connections in the pool as there
are threads. `config/initializers/puma_database_connection.rb` closes
the default AR connection pool and sets up a new one with the right
number of connections.  Heroku limits us to 20 connections on
non-enterprise database plans.



