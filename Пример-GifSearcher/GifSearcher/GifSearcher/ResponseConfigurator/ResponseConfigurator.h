#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol ResponseConfigurator <NSObject>

- (RKObjectMapping *)createResponseMapping;
- (RKResponseDescriptor *)createResponseDescriptor;

@end
