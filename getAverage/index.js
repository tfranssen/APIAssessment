exports.handler = async () => {
  //Write response
  const response = {
    isBase64Encoded: false,
    headers : {"content-type" : "application/json"},
    statusCode: 200,
    body: JSON.stringify({minTemp: 19, maxTemp: 30, average: 24.5}),
}
return response
};