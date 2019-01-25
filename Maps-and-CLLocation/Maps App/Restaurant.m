

#import "Restaurant.h"

@implementation Restaurant

- (id _Nullable )initWithCoordinate:(CLLocationCoordinate2D)aCoordinate
                           andTitle:(NSString * _Nullable)aTitle
                        andSubtitle:(NSString * _Nullable)aSubtitle;
{
    self = [super init];
    if (self)
    {
        _coordinate = aCoordinate;
        _title = aTitle;
        _subtitle = aSubtitle;
    }
    return self;
}


@end
