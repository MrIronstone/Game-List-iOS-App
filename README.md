# Game List App
This is the project where I developed game list app to learn VIPER architecture, UIKit and Swift and networking.

List games on a grid and shows details for each game when clicked on a cell. Games can be wishlisted and removed from the wishlist.

### *App demo*
<video src="https://user-images.githubusercontent.com/47990723/187899173-3c99f8fe-36c7-4612-aca9-37b4206f775e.mp4" controls="controls" style="max-width: 730px;"> </video>

### *Demo Highlights*
• Detail view properly handles the situation where the some details are not provided by the API. <br /><br />
• Detail view can be scrolled when needed and description area can be expended and collapsed back to 4 lines. <br /><br />
• In the result returned by the api, if the game's website and reddit pages exist, there are buttons that open their pages. If not, the keys are not displayed and the layout is automatically organized accordingly. <br /><br />
• When the details of any game are displayed, the name of that game, both on the games listing and on the wishlist, turns gray. And it can do this without reloading. I used the notification pattern for this. This color change is **not permanent**, it resets when the app is closed and opened. <br /><br />
• When any game is added to or removed from the wishlist, the wishlist button at the top right of the cells likewise gets the color it should be without needing to be reloaded. But this time, these are **not temporary** and when the application is opened again, the final state is restored. <br /><br />
• Pagination triggered when reaching to the bottom of the page. <br /><br />
• Shows empty case screen for each game list screen and wishlist screen if no results found. <br /><br />


### *Code Highlights*
• Caches images <br /><br />
• Uses Swift's Result type <br /><br />
• Created very generic network engine so and so it can do a lot of networking with very little code <br /><br />

Project pdf file : https://drive.google.com/file/d/1gWElnBEQBFKQGPOJ5N6cp2NBgvV1WFQd/view?usp=sharing
