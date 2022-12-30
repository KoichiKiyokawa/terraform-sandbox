"use strict"

/** @type {import('aws-lambda').CloudFrontRequestHandler} */
exports.handler = (event, context, callback) => {
  console.log({ event })
  callback(null, {
    status: "200",
    body: "Hello, world!",
  })
}
