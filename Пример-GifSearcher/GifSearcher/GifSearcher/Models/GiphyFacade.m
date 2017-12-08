#import "GiphyFacade.h"
#import <RestKit/RestKit.h>
#import "ImageDescription.h"
#import "ImagesSearchResponsConfigurator.h"
#import "Macros.h"

static NSString *const kServerHost = @"http://api.giphy.com/";
// it is not secure solution
// TODO: set API key
static NSString *const kApiKey = @"APIKEY";

@interface GiphyFacade ()

- (void)setupRestkit;

@end

@implementation GiphyFacade

#pragma mark - initialization

+ (instancetype)sharedInstance {
    static GiphyFacade *giphyFacade = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        giphyFacade = [[self alloc] init];
    });
    return giphyFacade;
}

- (id)init {
    if (self = [super init]) {
        [self setupRestkit];
    }
    return self;
}

- (void)setupRestkit {
    NSURL *baseURL = [NSURL URLWithString:kServerHost];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [objectManager addResponseDescriptor:[[[ImagesSearchResponsConfigurator alloc] init] createResponseDescriptor]];
    [RKObjectManager setSharedManager:objectManager];
}

#pragma mark - public methods

- (void)getGifsDescriptionsWithRequest:(NSString *)request
                          successBlock:(void(^)(NSArray *descriptions))successBlock
                             failBlock:(void(^)(NSError *error))failBlock
                           targetQueue:(dispatch_queue_t)targetQueue {

    [[RKObjectManager sharedManager] getObjectsAtPath:@"v1/gifs/search"
                                           parameters:@{@"api_key" : kApiKey,
                                                        @"q" : request}
                                              success:^(RKObjectRequestOperation *operation,
                                                        RKMappingResult *mappingResult) {
                                                  
                                                  NSArray *response = (NSArray *)mappingResult.array;
                                                  BlockSafeRunOnTargetQueue(targetQueue, successBlock, response);
                                                  
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  BlockSafeRunOnTargetQueue(targetQueue, failBlock, error);
                                              }];
}

@end
