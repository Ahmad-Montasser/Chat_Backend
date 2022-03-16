# README

* Ruby version

3.1.1

* System dependencies

Docker

* Services

DB => MySQL
Qeueing => Sidekiq
Search => Elastic Search
Redis => To handle caching and race conditions

* Deployment instructions

clone The Repo 
run sudo mkdir -p volumes/elasticsearch/data && sudo chown 1000:1000 volumes/elasticsearch/data
run sudo docker-compose up --build

* Note

Due to time limitations the dockeraization was not tested but the app is working as it should locally so i hope you can test it locally if anything fails to work as expected. Thank You !! 
