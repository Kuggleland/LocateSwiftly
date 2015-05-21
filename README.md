# LocateSwiftly
## About
Swift Class abstracts away CoreLocation and its delegates and uses NSNotification's to post updates that any class can listen too, and then request information from the class as needed.

## Notification tyoes
* **initialized** - This is when the class is created
* **foreground.start** - This is when full powered location is started
* **foreground.stop** - This is when full powered location is stopped
* **background.start** - This is when full powered location is started
* **background.stopped** - This is when full powered location is stopped
* **error.general** - This is when the location services encounters an error (Todo: store the error so we can handle it)
* **location.updated** - This is when location is updated so that you can query this class for the location
* **error.deny** - This is when the user has denied the location

## To Do
* Separate **error.deny** into another type called **error.restrict**
* Store the error from CoreLocation
