#import "ViewController.h"
#import "Restaurant.h"


@interface ViewController ()

// Shows us the map
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

// tells us of the updates -> Level of accuracy
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic) UITableView *myTableview;


// A particular location
@property (nonatomic) CLLocation *currentLocation;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    
    _myMapView.mapType = MKMapTypeStandard;
    [_myMapView setZoomEnabled: true];
    [_myMapView setRotateEnabled: true];
    [_myMapView setScrollEnabled: true];
    [_myMapView showsScale];
    
    
    // Modularizing our code
    _myMapView.delegate = self;
    // where anotations are
    
    
    /*
     CLLocationManager; used to to detect user’s location.
     The CLLocationManager delegate can tell us about changes in authorization or location updates such as entering or exiting a region.
     */
    _locationManager = [[CLLocationManager alloc] init];
    
    // Default best accuracy decreased our battery life.
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    // How far before an update is fired
    _locationManager.distanceFilter = 10;
    
    // delegates the task of updating to HERE
    _locationManager.delegate = self;
    
    
    // type of access to location
    // that comes from pList
    [_locationManager requestAlwaysAuthorization];
    
    
    NSLog(@"You probably should place this in a separate class and use a singleton for it");
    
    [_locationManager startUpdatingLocation];
    
    
    
    
    // ANNOTATIONS //
    /*
     MKAnnotaion -> Classes conformed to this protocol, can produce objects that are used as annotations
     
     MKPinAnnotationView -> It's the view that contains your pin\   // and you can customize it
     MKPointAnnotation -> Default Anottation Ponit (pin)
     */
    
    // Point Annotation
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    
    myAnnotation.coordinate = CLLocationCoordinate2DMake(49.281422, -123.114626);
    
    [myAnnotation setTitle:@"LHL"];
    [myAnnotation setSubtitle:@"Where we currently are"];
    [_myMapView addAnnotation: myAnnotation];
    
    
     Restaurant *subWay;
     subWay = [[Restaurant alloc] initWithCoordinate: CLLocationCoordinate2DMake(49.260675,
     -123.247153)
     andTitle: @"UBC"
     andSubtitle: @"Where I used to GO"];
     [_myMapView addAnnotation: subWay];
    

    
    // array of annotations!
    
    //    [_myMapView addAnnotations:<#(nonnull NSArray<id<MKAnnotation>> *)#>];
    // _myMapView showAnnotations:<#(nonnull NSArray<id<MKAnnotation>> *)#> animated:<#(BOOL)#>
}


// a delegatre memeber of location manager
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"Updaing");
    CLLocation * loc = [locations lastObject];
    
    NSLog(@"Time %@, latitude %+.6f, longitude %+.6f currentLocation accuracy %1.2f loc accuracy %1.2f timeinterval %f",
          [NSDate date],loc.coordinate.latitude,
          loc.coordinate.longitude,
          loc.horizontalAccuracy,
          loc.verticalAccuracy,
          fabs([loc.timestamp timeIntervalSinceNow])
          );
    
    
    
    
    
    
    
    
    // the update is new. Not cahched
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    if (locationAge > 10.0)
    {
        NSLog(@"locationAge is %1.2f", locationAge);
        return;
    }
    
    
    
    
    
    
    
    
    // A negative value indicates that the latitude and longitude are invalid.
    if (loc.horizontalAccuracy < 0)
    {
        NSLog(@"Horizontal Accuracy is invalid");
        // so don't move the map anywhere
        return;
    }
    
    
    // let's push the map
    if (self.currentLocation == nil || self.currentLocation.horizontalAccuracy >= loc.horizontalAccuracy)
    {
        self.currentLocation = loc;
        CLLocationCoordinate2D zoomToLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude,    _currentLocation.coordinate.longitude);
        
        MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomToLocation, 500, 500);
        
        [_myMapView setRegion:adjustedRegion animated:YES];
        
        
        
        
        
        // if can't get needed accuracy, let's top this
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




- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    //    //////// PIN VIEW
    
    /*
     MKPinAnnotationView *pinView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"myId"];
     if (!pinView)
     {
     // If an existing pin view was not available, create one.
     pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myId"];
     pinView.canShowCallout = YES;
     pinView.pinTintColor = [UIColor greenColor];
     
     UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
     pinView.rightCalloutAccessoryView = rightButton;
     
     // Add an image to the left callout.
     UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lhlLogo.png"]];
     pinView.leftCalloutAccessoryView = iconView;
     
     }
     return pinView;
     */
    
    
    // OR
    
    // MK Annotation View
    
    MKAnnotationView *anyView;
    if ([annotation isKindOfClass: [MKPointAnnotation class]])
    {
        //////// VIEW
        anyView = [mapView dequeueReusableAnnotationViewWithIdentifier: @"pinId"];
        if (!anyView)
        {
            // If an existing pin view was not available, create one.
            anyView = [[MKAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"pinId"];
            anyView.canShowCallout = YES;
            anyView.image = [UIImage imageNamed:@"pin.png"];
            anyView.calloutOffset = CGPointMake(0, -32);
            UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
            
            [rightButton addTarget:self
                            action:@selector(myTempAction)
                  forControlEvents:UIControlEventTouchUpInside];
            
            
            anyView.rightCalloutAccessoryView = rightButton;
            
            // Add an image to the left callout.
            UIImageView *iconView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"lhlLogo.png"]];
            anyView.leftCalloutAccessoryView = iconView;
        }
        else
        {
            anyView.annotation = annotation;
        }
    }
    return anyView;
}


-(void)myTempAction
{
    NSLog(@"This is taht");
}




- (IBAction)goThereAction:(id)sender
{
    // map view to set to a region and the scroll view scrolls visible rect to that destination
    MKCoordinateRegion myRegion;
    
    // CLLocationCoordinate2D:  The latitude and longitude associated with a location
    CLLocationCoordinate2D myCen = CLLocationCoordinate2DMake(49.281838, -123.108151);
    
    myRegion = MKCoordinateRegionMakeWithDistance(myCen,
                                                  200, //m
                                                  200); //m
    [_myMapView setRegion:myRegion animated:true];
}
@end
