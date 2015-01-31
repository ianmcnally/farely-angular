# Farely
Calculate the best amount to put on your metrocard, so you don't have wasted change.

## Setup

1. `npm install -g gulp`
2. `npm install`

## Develop

1. `gulp`

## Test

1. `gulp test` - Run unit tests headless in PhantomJS (good for CI)
2. `gulp test:browser` - Run unit tests in Chrome

## Deployment

1. `gulp compile:prod` - Compile minified code
2. Upload `/public` to S3
3. Profit (j/k)