#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;

- (id _Nullable )initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
                           andTitle:(NSString * _Nullable)aTitle
                        andSubtitle:(NSString * _Nullable)aSubtitle;

@end
