Outrigger
==========

[![Build Status](https://travis-ci.org/instructure/outrigger.svg?branch=master)](https://travis-ci.org/instructure/outrigger)

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

### Using with [Switchman](https://github.com/instructure/switchman)

If your application is also using Switchman to manage multiple shards, you'll
want the `rake db:migrate:tagged` task to run against all shards, not
just the default shard. To do this, add to a rake task file such as
`lib/tasks/myapp.rake`:

```ruby
Switchman::Rake.shardify_task('db:migrate:tagged')
```

Multiple Tags
-------------

Passing multiple tags to `db:migrate:tagged` means only run migrations that have
all of the given tags.

``` rake db:migrate:tagged[predeploy, dynamodb] ``` means run only migrations
tagged with both `predeploy` and `dynamodb`. It will not run migrations tagged
just `predeploy`.

RuboCop Linter
--------------

Outrigger comes with a custom RuboCop linter that you can add to your project,
to verify that all migrations have at least one valid tag.

Put this into your `.rubocop.yml`.

```
require:
  - outrigger/cops/migration/tagged

Migration/Tagged:
  Enabled: true
  AllowedTags:
    - predeploy
    - postdeploy
```

Modify `AllowedTags` as necessary.
