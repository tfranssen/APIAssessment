'use strict'
//Load libraries
const fetch = require('node-fetch');
const mongoist = require('mongoist');

let MONGODB_URI;

//async function main(){ 
exports.handler = async () => {
  //Get connection string from AWS environment variables 
  MONGODB_URI = process.env['URI_MONGO_DB']
  try {
    //Get temperature from Yahoo Weather service
    const url = 'https://weather-ydn-yql.media.yahoo.com/public/forecastrss?location=covilha,pt&format=json&u=c'; // u=c means celsius
    const respWeather = await fetch(url);
    const body = await respWeather.json();
    const temperature = body.current_observation.condition.temperature;
    const pubDate = body.current_observation.pubDate;
    const pubDateMillis = new Date(pubDate*1000);
    const pubDateStr = pubDateMillis.toDateString();
    //Create document for MongoDB
    const data = {"timestamp": Math.round(Date.now()/1000), "pubdate": pubDate, "temp": temperature};
    
    //Write to DB
    try {
      //Make connection
      const Client = mongoist(MONGODB_URI);
      Client.on('connect', () => {
        console.log('Database connected');
      });
      //Write
      await Client.Temps.insert(data);
      Client.close();
    } catch (err) {
      console.log(err);
    }
    console.log(data);

    //Write response
    const response = {
      statusCode: 200,
      body: {"timestamp": Math.round(Date.now()/1000), "pubdate": pubDate, "temp": 100},
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