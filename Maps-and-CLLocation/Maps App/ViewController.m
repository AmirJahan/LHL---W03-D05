#import "ViewController.h"
#import "MyAnnotationClass.h"



@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     MapKit display geographic data on device. It’s a framework used to show maps. It’s built upon UIView and has built in
     
     Scrolling
     Rotation
     delegation
     Region (center and ho / ve)
     */
    _myMapView.mapType = MKMapTypeStandard;
    [_myMapView setZoomEnabled: true];
    [_myMapView setRotateEnabled:true];
    [_myMapView setScrollEnabled:true];
    [_myMapView showsScale];
    _myMapView.delegate = self;
    
    
    /*
     CLLocationManager
     Is used to to detect user’s location.
     The CLLocationManager delegate can tell us about changes in authorization or location updates such as entering or exiting a region.
     */
    _locationManager = [[CLLocationManager alloc] init];
    
    // Default best accuracy decreased our battery life.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _locationManager.distanceFilter = 10;
    //have to move 10m before location manager checks again
    
    _locationManager.delegate = self;
    [_locationManager requestAlwaysAuthorization];
    
    NSLog(@"You probably should place this in a separate class and use a singleton for it");
    
    [_locationManager startUpdatingLocation];
    
    
    // coordinates
    
    
    
    /*
     MKAnnotaion protocol is what we use to produce our own classes of Annotations. MKPinAnnotation and MKPointAnnotation are default.
     */
    
    
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(49.281838, -123.108151);
    [myAnnotation setTitle:@"LHL"];
    [myAnnotation setSubtitle:@"Where we currently are"];
    [_myMapView addAnnotation: myAnnotation];
    
    
    
    
    //    [_myMapView addAnnotations:<#(nonnull NSArray<id<MKAnnotation>> *)#>];
    // _myMapView showAnnotations:<#(nonnull NSArray<id<MKAnnotation>> *)#> animated:<#(BOOL)#>
    
    
    
    MyAnnotationClass *myAnn = [MyAnnotationClass new];
    myAnn = [[MyAnnotationClass alloc] initWithCoordinate:CLLocationCoordinate2DMake(49.260675, -123.247153)
                                                 andTitle:@"UBC"
                                              andSubtitle:@"Where I lost my bike"];
    [_myMapView addAnnotation: myAnn];
}





- (IBAction)goThereAction:(id)sender {
    
    MKCoordinateRegion myRegion;
    
    // CLLocationCoordinate2D:  The latitude and longitude associated with a location
    
    CLLocationCoordinate2D myCen = CLLocationCoordinate2DMake(49.281838, -123.108151);
    myRegion = MKCoordinateRegionMakeWithDistance(myCen, 500, 500);
    
    [_myMapView setRegion:myRegion animated:true];
}





-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * loc = [locations lastObject];
    
    NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",[NSDate date],loc.coordinate.latitude,
          loc.coordinate.longitude,
          loc.horizontalAccuracy,
          loc.verticalAccuracy,
          fabs([loc.timestamp timeIntervalSinceNow]));
    
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0){
        NSLog(@"locationAge is %1.2f",locationAge);
        return;
    }
    
    if (loc.horizontalAccuracy < 0){
        NSLog(@"loc.horizontalAccuracy is %1.2f",loc.horizontalAccuracy);
        return;
    }
    
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= loc.horizontalAccuracy)
    {
        self.currentLocation = loc;
        CLLocationCoordinate2D zoomToLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude,
                                                                           _currentLocation.coordinate.longitude);
        
        MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomToLocation, 500, 500);
        
        [_myMapView setRegion:adjustedRegion animated:YES];
        
        if (loc.horizontalAccuracy <= self.locationManager.desiredAccuracy)
        {
            if ([CLLocationManager locationServicesEnabled])
            {
                if (_locationManager)
                {
                    [_locationManager stopUpdatingLocation];
                    NSLog(@"Stop Regular Location Manager");
                }
            }
        }
    }
}



//
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // MK Annotation View
    
    
    MKAnnotationView *anyView;
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        //////// VIEW
        anyView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pinId"];
        if (!anyView)
        {
            // If an existing pin view was not available, create one.
            anyView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinId"];
            anyView.canShowCallout = YES;
             anyView.image = [UIImage imageNamed:@"pin.png"];
            
            
            
            anyView.calloutOffset = CGPointMake(0, -32);
            
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            anyView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lhlLogo.png"]];
            anyView.leftCalloutAccessoryView = iconView;
        }
        else
        {
            anyView.annotation = annotation;
        }
    }
    return anyView;
    
     
    

     //    //////// PIN
    
    /*
     MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myId"];
     if (!pinView)
     {
     // If an existing pin view was not available, create one.
     pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myId"];
     pinView.canShowCallout = YES;
     pinView.pinTintColor = [UIColor greenColor];
     pinView.image = [UIImage imageNamed:@"pin.png"];

     UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
     pinView.rightCalloutAccessoryView = rightButton;
     
     // Add an image to the left callout.
     UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lhlLogo.png"]];
     pinView.leftCalloutAccessoryView = iconView;
     
     
     }
     return pinView;
     */
    
}




@end
