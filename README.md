Outrigger
==========

### Tag your rails migrations

Outrigger allows you to tag your migrations so that you can have
complete control. This is especially useful for zero downtime deploys to Production environments.

Usage
------------

1. Add `gem outrigger` to your Gemfile and run `bundle install`
2. Tag migrations like so.
```
  class PreDeployMigration < ActiveRecord::Migration
    tag :predeploy
  end
  class PostDeployMigration < ActiveRecord::Migration
    tag :super_fun
  end
```
3. Run only the migrations you want.
``` rake db:migrate:tagged[predeploy] ```
or
``` rake db:migrate:tagged[super_fun] ```
