# SfA

## Installation

### Secret token

You have to generate your secret token for making this app work locally.

Use `rake secret >> .env` to create an Env file with the secret token, then edit `.env` like this

```
export SECRET_TOKEN="YOUR_GENERATED_SECRET_TOKEN"
```


## Development

There are two main branches: *master* and *development*.

Branch *master* is the one used for the **production** deployment.

Branch *development* is the one used for the **staging** deployment.


### Rake tasks env variables

#### in `development`

Since SfA is using `foreman`, use this command

```
foreman run rake some_task
```

to execute tasks that use things like `ENV['MY_VARIABLE']`

#### in `production`
the command is

```
heroku run rake some_task
```

since *heroku* uses `foreman`

## Translations

If there are new models' columns

```
rake gettext:store_model_attributes
```

If there are new localized strings

```
rake gettext:find
```

If there are new localized string in Javascript files, run this after saving the .po file

```
rake gettext:po_to_json
```

## Testing

To run Cucumber tests:

```bash
bundle exec cucumber # optionally specify features/<file_name>.feature
```

## Deployment

We deploy to Heroku using two environments, *staging* and *production*.

### Staging

To do a *staging* deploy just type

```
git push staging development:master
```

This command pushes the latest commit from the *development* local branch to the *staging* remote (that is the *master* branch on heroku)

If needed, migrate the database with

```
heroku run rake db:migrate
```

### Production

To do a *production* deploy just type

```
git push production master:master
```

This command pushes the latest commit from the *master* local branch to the *production* remote (that is the *master* branch on heroku)

If needed, migrate the database with

```
heroku
heroku run rake db:migrate --remote production
```

# Troubleshooting

## Mailchimp

Sometimes Mailchimp API change and screw up things, usually Delayed Jobs. The first thing to do is go and check API changes in [the gibbon gem](https://github.com/amro/gibbon).

If the some users don't have the `mc_member_id` you can assign it by executing (locally or on Heroku)

```
rake sfa:set_mc_member_id_to_users
```

To be sure that the user is in the correct Mailchimp group, just update each of his boats from the admin interface. This will trigger a `MCUserGroupUpdate` job.
