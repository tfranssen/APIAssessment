'use strict'
console.log('Loading function');

const fetch = require('node-fetch');

//async function main(){ 
exports.handler = async () => {  
  try {
    //Get temperature from Yahoo Weather service
    const url = 'https://weather-ydn-yql.media.yahoo.com/public/forecastrss?location=covilha,pt&format=json&u=c'; // u=c means celsius
    const respWeather = await fetch(url);
    const body = await respWeather.json();
    const temperature = body.current_observation.condition.temperature;
    const pubDate = body.current_observation.pubDate;
    const pubDateMillis = new Date(pubDate*1000);
    const pubDateStr = pubDateMillis.toDateString();
    //console.log(temperature);
    //console.log(pubDate);
    //console.log(pubDateMillis.toDateString());
    const data = {"timestamp": Math.round(Date.now()/1000), "pubdate": pubDate, "temp": temperature};
    console.log(data);
  
    //Write response
    const response = {
      statusCode: 200,
      body: data,
    }
    return response
  } catch (err) {
    const response = {
      statusCode: 500,
      body: JSON.stringify("InternalServerError"),
    }
    return response
  }
};

//main();