# ReelSync: Movie Night App

## Description
ReelSync is a mobile application designed for two people to collaboratively select a movie to watch together. The application uses The Movie DB API (TMDb), and streamlines the process of choosing a movie, ensuring a seamless movie night experience between friends.

## Screens

### Welcome Screen
- Users choose to start a session or join an existing one.
- Utilizes platform_device_id package to retrieve device ID.
- Options to get a code to share or enter a shared code.
<img src="./assets/reelSync-home.png" alt="ReelSync Home Screen" height="300">

### Share Code Screen
- Generates a code to share with another user.
- Makes an HTTP call to the MovieNight API's /start-session endpoint.
- Saves session ID for future reference.
<img src="./assets/reelSync-shareCode.png" alt="ReelSync Share Vote Session Code Screen" height="300">


### Enter Code Screen
- Allows users to enter a shared code.
- Makes an HTTP call to the MovieNight API's /join-session endpoint.
- Handles errors gracefully.
<img src="./assets/reelSync-joinCode.png" alt="ReelSync Join Vote Session Code Screen" height="300">


### Movie Selection Screen
- Fetches movies from The Movie DB API.
- Displays movie details and allows users to swipe left or right to indicate preferences.
- Makes HTTP calls to the MovieNight API's /vote-movie endpoint for each vote.
- Notifies users of matches with partner.
<table>
  <tr>
    <td><img src="./assets/reelSync-vote.png" alt="ReelSync Movie Vote Screen" width="400" /></td>
    <td><img src="./assets/reelSync-match.png" alt="ReelSync Movie Match Preview" width="400" /></td>
  </tr>
</table>


## Functionality

### Welcome Screen
- Utilizes device ID package to retrieve unique device ID.
- Allows users to start or join a session.

### Share Code Screen
- Generates a code to share with another user.
- Saves session ID for future reference.
- Navigates to Movie Selection Screen.

### Enter Code Screen
- Allows users to enter a shared code.
- Handles errors in case of invalid session code.
- Navigates to Movie Selection Screen upon successful code submission.

### Movie Selection Screen
- Fetches movies from The Movie DB API.
- Displays movie details and allows swiping to indicate preferences.
- Makes HTTP calls to MovieNight API for each vote.
- Notifies users of matches with partner.
- Handles loading of additional movies from TMDB API.

### HTTP and Data
- Implements an HttpHelper class for API calls.
- Saves device ID and session ID using SharedPreferences (device local storage).

### Design Considerations
- Unique launcher icon and splash screen.
- Accessible text readability and color palette.
- Standardized spacing (padding/margin) using base number.
- Using MaterialApp for defining ColorScheme and TextTheme.
