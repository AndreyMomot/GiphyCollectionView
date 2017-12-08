#import <UIKit/UIKit.h>

@interface GiphyFacade : NSObject

+ (GiphyFacade *)sharedInstance;

- (void)getGifsDescriptionsWithRequest:(NSString *)request
                          successBlock:(void(^)(NSArray *descriptions))successBlock
                             failBlock:(void(^)(NSError *error))failBlock
                           targetQueue:(dispatch_queue_t)targetQueue;

@end
