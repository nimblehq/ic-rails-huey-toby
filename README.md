Staging: https://ic-rails-huey-toby-staging.herokuapp.com/

Production: https://ic-rails-huey-toby.herokuapp.com/

[![Build Status](https://img.shields.io/github/actions/workflow/status/nimblehq/ic-rails-huey-toby/test.yml?branch=main)](https://github.com/nimblehq/ic-rails-huey-toby)

## Introduction

This API app extracts large amounts of data from the Google or Bing search results page. 

A user can upload a CSV file containing keywords, and the app will scrape and store its results.

## Project Setup

### Prerequisites

- Ruby: v3.0.1
- Rails: v7.0.1
- Docker: v4.13.1
- Postman: v10.15.8
- TablePlus: v5.3.8 (Optional)

To run the app locally, do the following:

1. Run Docker container
2. Set the correct environment variables in `application.yml`
3. Start Rails server: `make dev`
4. Start Sidekiq: `bundle exec sidekiq`

## Usage

Here's a summary of the available endpoints:

- Sign-up with e-mail/password and Google.
- Sign-in wit e-mail/password and Google.
- Upload keywords with Google/Bing.
- Show list of search results.
- Filter through search results.
- Show details of search result.
- Download PDF of search result.

For convenience, you can import the Postman collection: `postman-collection.json`

## Workflows

- Run tests and generate code coverage report: `test.yml`
- Deploy to staging/production with Heroku: `deploy_heroku.yml`

## About
![Nimble](https://assets.nimblehq.co/logo/dark/logo-dark-text-160.png)

This project is created to complete **API Certification Path** using **Ruby** at [Nimble][nimble]

[nimble]: https://nimblehq.co