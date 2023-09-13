# WeatherApp
This app get the weather for any location based on your input. You can also just use your location without typing anything in! It utilizes OpenWeather API to get the weather data,
and stores it in a Firebase Firestore Database. 


# Release Notes
1.0.0
Initial Release. Barebones fundamentals working.

1.0.1
Improvements: 
  * Integrated Firebase into source code.
  * Converted temperature from celcius to farenheit
Bug Fixes:
  * Stopped showing a bunch of trailing decimals on the temperature reading

1.0.2
Improvements: 
  * Successfully able to store each weather api call in firestore DB.
Bug Fixes:
  * Added GoogleService-Info.plist to github so that anyone who clones repository can run it with Firebase features

1.0.3
Improvements: 
  * Improved UI colors and look.

1.0.4
Improvements: 
  * Added functionality for users to use their current location to get weather.
Bug Fixes:
  * Fixed bug in which the app wouldn't ask for user's permission to use their location.
