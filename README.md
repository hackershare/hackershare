# Hackershare

[中文](https://github.com/hackershare/hackershare/blob/master/README_cn.md)

Social bookmarks website for hackers. Alternative to delicious, hackernews, pocket. 
Hackershare is the open source software which powers [hackershare.dev](https://hackershare.dev)

[![CI](https://github.com/hackershare/hackershare/workflows/CI/badge.svg)](https://github.com/hackershare/hackershare/actions)

## Dependency

* Postgresql 12+
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

## Deployment

* Nginx conf sync: bundle exec cap production puma:nginx_config
* Deploy: bundle exec cap production deploy


## chrome extension

* https://github.com/hackershare/hackershare-ext
* https://chrome.google.com/webstore/detail/hackershare/pinmchdpdbjbhijbagmealcojjpeebmh

## refresh sitemap

* bundle exec rake sitemap:refresh
