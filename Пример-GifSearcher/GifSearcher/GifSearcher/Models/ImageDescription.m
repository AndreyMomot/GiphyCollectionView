#import "ImageDescription.h"

@implementation ImageDescription

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.url];
}

@end
