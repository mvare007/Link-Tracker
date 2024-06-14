
# Link Tracker


This application provides a solution for tracking and redirecting links. Built using Ruby on Rails and utilizing a SQLite database for simplicity, the application offers a seamless way for clients to generate, track, and analyze tracking links.
## Run Locally

Clone the project

```bash
  git clone https://github.com/mvare007/Link-Tracker.git
```

Go to the project directory

```bash
  cd Link-Tracker
```

Install ruby 3.3.1 using rbenv

```bash
	rbenv install 3.3.1
```

Set the local ruby version to 3.3.1

```bash
	rbenv local 3.3.1
```

Install gems

```bash
  bundle install
```

Setup the database and migrations

```bash
  rails db:prepare
```

Start the server

```bash
  rails server
```


## API Reference

This project uses Swagger for API documentation. To view the complete API reference:

Start the server and navigate to `/api-docs` in your browser.

For example, if running the server locally on port 3010, visit:

`http://localhost:3010/api-docs`

Important: Make sure you run it on localhost and not from 127.0.0.1 or else you will run into a CORS error.

The Swagger UI provides an interactive interface where you can explore all available endpoints, their parameters, request bodies, and response schemas. You can also test the API directly from this interface.

#### Note:

Swagger UI does not follow redirects, but you can observe them in your browser's developer tools.
To fully test and observe redirects, I recommend using an API client like Postman or cURL.