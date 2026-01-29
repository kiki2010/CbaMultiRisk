# CbaMultiRisk
An app focused on the province of Córdoba to find out the risk of fire and floods in your area.

<img width="512" height="512" alt="multirisklogo" src="https://github.com/user-attachments/assets/14abe224-b26f-4625-a4cb-118608eeb277" />

## The idea:
The idea was to create an all-in-one app focused on the province of Córdoba, using weather data and featuring a cute mascot.
The app has three main screens (risk, tips, and settings). It features alerts for high risk, a quiz-style game, and... It's currently in the 14 days of testing before being released on the Play Store!

<img width="1366" height="519" alt="Captura de pantalla 2026-01-28 211559" src="https://github.com/user-attachments/assets/8adfbe03-542e-4585-a7d7-1d3f103f3f57" />

## Screens:
### Risk Screen:
This screen is the app main screen. Its function is to assess the risk of the user’s location, combining meteorological data with artificial intelligence models.
Based on the device’s location, we obtain information from the weather station closest to the user, including current conditions, historical conditions (7 days) and forecast (3 days). This data will be displayed on the weatherCard.
With this data, the risk of fire and flooding will be calculated using two independent classification models. The prediction results will be displayed using the riskCard widget visually for quick interpretations.By tapping the riskCard you can get information about the risk calculation process.
We also have a Suqui that helps to humanize the experience and helps to contextualize the data according to the current location.

<img width="1080" height="2400" alt="Screenshot_20260121-170821" src="https://github.com/user-attachments/assets/80c0a9ca-620c-4f3b-a09e-66613b02761c" />

### Suqui Screen + Game:
- Suqui Screen:
In this screen we will be able to see useful information about floods, fires and general information. Also, by this screen we can get to the Quiz Menu + game.
The widgets + Suqui controllers can be found on the avatar.dart file. Tips are saved on a json file called: suqui_tips.json.

<img width="1080" height="2400" alt="Screenshot_20260121-170833" src="https://github.com/user-attachments/assets/5a3d6f73-b4b9-4cfe-b52b-00ebe8c4c890" />

- Game Menu:
This is an introduction to the game; here you can see some simple instructions. You can also find your highest and last scores. These scores will be saved using SharedPreferences, and the logic behind this is stored in quizlogic.dart.

![WhatsApp Image 2026-01-28 at 11 53 27 (1)](https://github.com/user-attachments/assets/4c0c68c8-6723-4011-93c5-b38ac59a821b)

- Game:
On this screen, you'll find the quiz-type game. The logic behind this screen (including the timer, point tracking, GIFs, and answer validation) is located on the quizlogic.dart screen.
We load the Timer + game logic
Functions for when we answer correctly (or wrong) and for when we finish the game (exactly, we load this functions, because the full logic in on quizlogic.dart).

![WhatsApp Image 2026-01-28 at 11 53 27](https://github.com/user-attachments/assets/ca529c37-b4cc-43e2-8c5e-7e119f1c4c52)
![WhatsApp Image 2026-01-28 at 12 02 26](https://github.com/user-attachments/assets/abda54b8-ba4c-41a1-8c54-020db4a6aefe)

### Settings Screen:
In this screen the user will be able to: change the language of the app (English or Spanish), select a dark theme, enable notifications or read the disclaimer again.
To save this preferences we use SharedPreferences, anyway, the logic behind is on:
- For language → lib\l10n\locale_controller.dart
- For theme → lib\theme\theme_controller.dart
- For notifications → lib\services\risknotifications.dart

<img width="800" height="600" alt="MultiRisk _ Documentación general" src="https://github.com/user-attachments/assets/c04dad26-d339-4102-9093-a2a1bbc2726f" />

## AI models:
The app has two AI models. Both neural networks were developed from scratch. The fire model used around 736 examples, and the flood model used around 1000 examples. I used google colabs for them.
### Fire AI model
- We import the necessary libraries.
- We load and prepare the data: We select the variables and convert the input columns to numeric values to ensure correct processing. We manually normalize the input (Wind Speed, Humidity and Temperature) variables to ensure we can implement it correctly in the app.
- We divided the dataset into three sets: Training (70%) Validation (15%) Test (15%)
- We create the Neural Network; Input Layer with 3 neurons. One hidden layer with 8 neurons. Output layer for multiclass classification.
- We compile the model.
- We train the model, using early stopping for avoiding overtraining.
- We evaluate the model to validate if it’s reliable and detect class confusion.
- Then we export and save the model using TensorFlowLite to implement it in flutter.

### Flood AI model
- We import the necessary libraries.
- We load and prepare the data: We convert the input columns to numeric values.
- We set up the input and output data: Inputs: SPI, Rainfall, Intensity and Humidity | Output: Risk Level | We split the dataset into training and testing sets (80% training, 20% testing).
- We create the Neural Network: Input Layer | Two hidden Layers |Output layer with 3 neurons.
- We compile the model
- We train the Model.
- We test the model
- We export it as a .tflite to implement it on flutter.

## How I made the app:
This project was built using the Flutter SDK (Dart). I also used the Windows Update API, Python, and TensorFlow for the AI ​​model.

In summary, for all screens:
### Risk:
1. We obtain the location.
2. We obtain API data.
3. We calculate the risk using both models.
4. We display everything on the screen.

### Tips:
1. We load random tips and poses.
2. Tapping "Suqui" changes the pose and random tips. Tapping the button displays a tip from the category. Tapping the "Game" button takes you to the game menu.

### Quiz:
1. We display the menu screen, where we save the last and highest scores using shared preferences. Tapping the "Game" button takes you to the game screen.

2. In the game: First, the counter and logic are initialized (according to the JSON, it checks if the questions are answered correctly). If you answer incorrectly, points will be deducted and an error message will be displayed.

### Settings: 
1. Using sharedpreferences, we save user preferences. You can modify the language, theme, enable notifications, view the disclaimer, and save the phone numbers of three local authorities.

## How to set up the project on your device:
Once the Flutter SDK is installed and configured, run the command `flutter pub get`. This will install the necessary libraries and allow you to modify the code.

## Changes based on user feedback and problems solved:
In this section we will explore some changes made to the application based on user feedback and explore the problems solved during development. Most of the changes were suggested during the closed testing period before the release on the Play Store.

1. Problems displaying data text on smaller screens: 
    This problem in the weatherCard was solved with two key changes: first we used AutoSizeText for better adaptation and then we put all the elements in the card (weather data + forecast for the next three days) as vertical SingleChildScrollView.

2. Changes were also suggested to the translation of words into Spanish, correcting typographical errors and adapting it to be better accepted locally, mainly on the game screen and the app's disclaimer.

3. Forecast Language:
	One of the most requested changes from users was to display the forecast in their selected language, as the API defaulted to English. This adjustment presented several challenges, primarily because the icon selection was based on the forecast keyword, which meant that even minor variations would display the "n/a" icon.
    The process for correctly implementing this functionality was:
    The information was retrieved from the API in the user's selected language ('es' or 'en').
    The icon code provided by the Weather Underground API was also retrieved. The switch to display the corresponding icon for each day now uses this code instead of the forecast keyword.
    The data is displayed in the same way as before.

> An additional note: when implementing language selection, it was discovered that app notifications stopped working. Thanks to the testing period, we were able to identify and correct this issue before launch.

4. Changes on the quiz screen: 
    The Quiz screen received many user suggestions. Some of the changes implemented based on this feedback are:
    The "Play" and "True/False" buttons were enlarged for easier use.
    Suqui's position was adjusted to make the questions easier to read.
    The game menu screen was forced to restart to always display the last game's results. Previously, the screen didn't restart, which could give the impression that the app was crashing.

5. Problems with notifications after the forecast change:
	Risk notifications weren't being sent in the background. The cause was that the Workmanager callback was using BuildContext. Functions like getAllWeatherData(position, context) require context, but BuildContext doesn't exist in the background, so Dart was throwing errors and the task was failing. We fixed this problem by creating a version of the function that doesn't depend on BuildContext. This solved the issue, and now notifications are sent correctly when the risk is high and the calculation is performed every 4 hours.

6. Icons:
    On the Suqui screen, we made several changes related to the icons:
    We added icons related to the tip category to help guide users to the specific topic.
    We changed the icon that referred to floods to match the rest of the app's screens.

## Extra:
I usually like to leave special thanks at the end of my readme, this time I'm going to dedicate it to the MATTEO project, since they are the ones who installed most of the weather stations in the schools in my area.

> And remember: Data is the base of all projects.

💖I love weather stations💖