Nuxt + Plumber
===========

A basic sample Nuxt application with Plumber.

Plumber handles the controller and the model as an API. Nuxt handles the view and calls the API, e.g http://127.0.0.1:3000/ (from Nuxt) will call http://127.0.0.1:8000/api (from Plumber).

Quick start
=============

## Build Setup (Plumber/ API)

``` bash
# Production build
$ ./index.R
```

Access it at http://localhost:8000/

## Build Setup (Nuxt)

``` bash
# Dependencies
$ npm install

# Development
$ npm run dev

# Production build
$ npm start
```

Access it at http://localhost:3000/

Notes
=============

1. You must run these two apps concurrently.

References
=============

* https://nuxtjs.org/guide/commands/

