# SfA

## Installation

### Secret token
You have to generate your secret token for making this app work locally.

Use `rake secret >> .env` to create an Env file with the secret token, then edit `.env` like this

```
export SECRET_TOKEN="YOUR_GENERATED_SECRET_TOKEN"
```

## Testing

To run Cucumber tests:

```bash
bundle exec cucumber # optionally specify features/<file_name>.feature
```