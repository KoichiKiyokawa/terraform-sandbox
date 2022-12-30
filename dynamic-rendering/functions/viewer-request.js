/** @param {AWSCloudFrontFunction.Event} event */
function handler(event) {
  var ua = event.request.headers["user-agent"].value
  console.log(ua)
  event.request.headers["x-user-agent"] = { value: ua }
  return event.request
}
