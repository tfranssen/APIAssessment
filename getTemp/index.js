'use strict'
console.log('Loading function');

const fetch = require('node-fetch');
const MongoClient = require('mongodb').MongoClient;

const uri = "mongodb+srv://dbuser:admin@firstcluster-qi6mu.mongodb.net/test?retryWrites=true&w=majority"


exports.handler = async (event) => {
  try {
    //Get temperature from Yahoo Weather service
    const url = 'https://weather-ydn-yql.media.yahoo.com/public/forecastrss?location=covilha,pt&format=json&u=c'; // u=c means celsius
    const respWeather = await fetch(url);
    const body = await respWeather.json();
    const temperature = body.current_observation.condition.temperature;
    const pubDate = body.current_observation.pubDate;
    const pubDateMillis = new Date(pubDate*1000)
    const pubDateStr = pubDateMillis.toDateString();
    console.log(temperature);
    console.log(pubDate);
    console.log(pubDateMillis.toDateString());
    //Write to DB
    MongoClient.connect(uri, {useUnifiedTopology: true}, function(err, db) {
      if(err) {
           console.log('Error occurred while connecting to MongoDB Atlas...\n',err);
      }
      var dbo = db.db('Weather');
      console.log('database connected!');
      var collection = dbo.collection('Temps');
      let data = {"timestamp": Math.round(Date.now()/1000), "city": "Covilhanpm", "pubdate": pubDate, "temp": temperature};
      collection.insertOne(data, (err, result) => {
          if(err) {
              console.log(err);
              process.exit(0);
          }
          console.log("");
          db.close();
      });
   });


    //Write response
    const response = {
      statusCode: 200,
      body: JSON.stringify({temperature, pubDate, pubDateStr}),
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