## SoundCloud Instant

[![Code Climate](https://codeclimate.com/github/infinitus/soundcloud-instant/badges/gpa.svg)](https://codeclimate.com/github/infinitus/soundcloud-instant)

An excuse to play with Sinatra and SoundCloud APIs. The site is up on [Heroku](http://soundcloudinstant.herokuapp.com).

## Build

```sh
# Clone the repo
git clone git@github.com:infinitus/soundcloud-instant.git && cd soundcloud-instant

# Install gems
bundle install

# Start Redis (for session store)
redis-server

# Run the app with Thin
ruby app.rb
```

## License

MIT
