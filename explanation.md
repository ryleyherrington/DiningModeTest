the rabbit hole with not enough time. So I looked up some examples of this and modified the idea to this one. Just using a transitioning delegate to present and dismiss it was the idea here. 

Emoji's were used as button icons because I didn't have the time to go and download glyphicons or anything since a good portion of this was done on a plane with no wifi. But I think it worked out just fine. 

I made some choices for data transfer that weren't what I would do in real life but for a simple little project it worked plus it might be a good indicator that I know multiple ways of saving data. E.g. I sent data to the `SecondViewController` from the first `ViewController` via a notification. I was going to send it through the object field but I threw the type of file into `UserDefaults` because arguably that would be better anyway. I would read the filename from `UserDefaults` and then load it in as the `ReservationViewController` is going to be shown. 

I mostly stuck with a single storyboard instead of xibs or autolayout code. I threw in a few autolayout with visiual code examples just to exemplify it though. 

## Wishes
The darn `UITableView` stuff in the reservation view is my big wish. I have multiple scrolling delegates and it doesn't autosize. So I wouldn't publish this to the app store but it works and shows the textviews with the bolding. Since it had a max amount of items(3) I realized I could've switched this to be a stack view situation but when I started I was going to have the cells resize... well anyway. It's a wish. 

Then animations to make the insertion or deleting of cells (example: look at the full reservation view, then switch it to the partial one and notice the jarring reloading animation with that third cell being deleted). Also loading url's could take some time and loading the reservation view needs a loader before the collectionview actually finishes. 

And I would've added testing as well.

## Testing
 I just didn't have time for. Usually it would be good to have a unit tests and UI testing (especially this one with some crazy interactions) and multiple types of removeable cells and items within cells. There are also issues with error checking that I just omitted so I had enough to show. But that would be next. 

