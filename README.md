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

## Translations

If there are new models' columns

```
rake gettext:store_model_attributes
```

If there are new localized strings
```
rake gettext_find
```

If there are new localized string in Javascript files

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
TODO