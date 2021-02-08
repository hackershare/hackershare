# Hackershare

Social bookmarks website for hackers. Alternative to delicious, hackernews, pocket. 
Hackershare is the open source software which powers [hackershare.dev](https://hackershare.dev)

There is also a project introduction article for your reference: [hackershare: Social bookmarking reinvented!](https://blog.hackershare.dev/2020/09/22/hackershare-social-bookmarking-reinvented/)

[![CI](https://github.com/hackershare/hackershare/workflows/CI/badge.svg)](https://github.com/hackershare/hackershare/actions)

## Dependency

* Postgresql 12
* Rails 6
* Stimulusjs 
* Turbolinks 5
* rails-ujs
* imagemagic
* redis

## Setup local

* [PG extension install](https://github.com/hackershare/hackershare/blob/master/pg_extension.md)
* rails db:create
* rails db:migrate
* rails db:seed_fu

## Setup by Docker

1. Make a copy of the example environment file and modify as required [optional].

```
cp .docker.env .env
```

2. Build the images.

```
docker-compose build
```

3. After building the image or after destroying the stack you would have to reset the database using the following command.

```
docker-compose run --rm rails bundle exec rails db:create
docker-compose run --rm rails bundle exec rails db:migrate
docker-compose run --rm rails bundle exec rails db:seed_fu

or 

docker-compose run --rm rails bundle exec rails db:reset
docker-compose run --rm rails bundle exec rails db:seed_fu
```

4. Run app

```
docker-compose up
```

5. stop app

```
docker-compose down
```

## Deployment

* Nginx conf sync: bundle exec cap production puma:nginx_config
* Deploy: bundle exec cap production deploy

## chrome extension

* https://github.com/hackershare/hackershare-ext
* https://chrome.google.com/webstore/detail/hackershare/pinmchdpdbjbhijbagmealcojjpeebmh

## refresh sitemap

* bundle exec rake sitemap:refresh