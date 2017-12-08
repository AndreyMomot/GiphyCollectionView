#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageDescription : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) NSNumber *width;
@property (nonatomic, assign) NSNumber *height;

// can be nil
@property (nonatomic, strong) UIImage *image;

@end
