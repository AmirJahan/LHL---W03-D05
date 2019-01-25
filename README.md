Hey everyone, 

Today, we talked about using Map Kit and Core Location to develop map enabled apps. 

Before anything, you should make sure to get user's consent in using their locations in your app. You can do this in the following two ways:

In Use  - only when the app is being used
Always - more pressure on your battery

To display maps, we use MapKit. It doesn't provide us with the location. It only shows us the map. It's a framework based on UIView. It allows you to scale, rotate or zoom.

We use CLLocation to get a specific location such as that of a user and the CLLocationManager to inform of the location update. Keep in mind updates are not necessarily valid, and you might want to test for that. 
You can use the updates for situations such as entering or exiting a region.

Core Location uses a wide range of data from sensors, Apple's location database as well as cell towers and known Wifis to find a location.

CLLocation objects has GPS coordinates (latitude and longitude), a timestamp and other information about the location.

MKAnnotaion protocol is what we use to produce our classes of Annotations. MKPinAnnotationView is the default view for a MKPointAnnotation.

Geocoding is the process of turning a string to a location or getting the address from a set of GPS coordinates.
