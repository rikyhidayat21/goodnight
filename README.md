# Good Night APIs

## Overview
Good Night APIs let users track when do they go to bed and when do they wake up.

This application is using:
- ruby version 3.3.5
- rails version 8.0.0

## Features
- Users is able to clock in ✅ 
- Users is able to clock out ✅ 
- Users is able to follow another users ✅ 
- Users is able to unfollow another users ✅ 
- Users is able to see their following users sleep records from previous week, which sorted based on duration sleep times ✅
- Users is unable to follow themselves ✅ 

## Sequence Diagram

![alt text](<Good Night APIs.png>)

## How to run locally

**Prerequisite**
- installed Ruby & Ruby on Rails

**Step by step**
```bash
git clone https://github.com/rikyhidayat21/goodnight.git
cd goodnight
bundle install
rails db:schema:load
rails db:seed # create users dummy (check on db/seeds.rb)
rails s
```

## How to use the APIs
There's an openapi that I've been created for this app. To use them easily, just follow these steps:
- copy all the content inside `openapi.yaml`
- open a browser, and go to this website: https://editor.swagger.io/
- at the editor page, paste the content from `openapi.yaml` to the left page panel
- you can try the APIs at the website page, don't forget to run the local server

![alt text](<swagapi.png>)

## Build with
Vanilla Rails API only

- Ruby 3.3.5
- Rails 8.0.0