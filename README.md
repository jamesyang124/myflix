Project specification
=====================

To launch server:

```sh
# launch postgres

redis-server
sidekiq
```

1.  This pet project build a streaming service website by Ruby on Rails frameork.

2.  The front-end framework include twitter-bootstrap, JQeury, and Sass.

3.  Database is created by PostgreSql 9.3.1.

```sh
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log stop

# If missing folder due to OsX el Captain removed it.
mkdir /usr/local/var/postgres/{pg_tblspc,pg_twophase,pg_stat,pg_stat_tmp,pg_replslot,pg_snapshots}/


brew services start homebrew/versions/postgresql93
brew services stop homebrew/versions/postgresql93

# psql -l
# psql database_name:
# list all tables
\dt
```

4.  The image files have been uploaded to Amazon S3 service.

5.  Functionality of credit card payment has been done by Stripe credit card payment service.

6.  Stripe Webhook has tunnel to ngrok for testing.

7.  The project developed by test driven development, mvc test by Rspec, integration test by Capybara.

8.  Selenium gem for javascript test.

9.  Test Mail service by letter_opener gem.

10. Mail service move to Sidekiq gem, which is a background job handler backed by Redis server.

Heroku Deployment:

https://github.com/mperham/sidekiq/wiki/Deployment

11. Support file uploading by CarrierWave gem, should give it a go for Dragonfly gem in future.

12. View template is scripted by Haml, pick simple_form_for and bootstrap_form_for to customized form.

13. Refactored by design patterns, decorator, domain policy object include.

14. Functionality for inviting friends, has been done by setting up self-referential association.

15. Manage ENV by Figaro gem. `rake figaro:heroku`

16. Set `config.serve_static_assets = true` and `config.assets.compile = true` to allow heroku precompile assets if Nginx or apache do not handle its static files.
