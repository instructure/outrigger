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

Modify `AllowedTags` as necessary. Note that due to a bug in RuboCop, you'll
currently get a warning on each run:

```
Warning: unrecognized cop Migration/Tagged found in .rubocop.yml
```

This is unfortunate, but can be safely ignored.
