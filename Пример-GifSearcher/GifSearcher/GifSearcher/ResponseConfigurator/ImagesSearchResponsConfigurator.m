#import "ImagesSearchResponsConfigurator.h"
#import "ImageDescription.h"

@implementation ImagesSearchResponsConfigurator

- (RKObjectMapping *)createResponseMapping {
    RKObjectMapping* imagesMapping = [RKObjectMapping mappingForClass:[ImageDescription class]];
    [imagesMapping addAttributeMappingsFromDictionary:@{@"type" : @"type",
                                                        @"images.original.url" : @"url",
                                                        @"id" : @"identifier",
                                                        @"images.original.width" : @"width",
                                                        @"images.original.height" : @"height"}];
    return imagesMapping;
}

- (RKResponseDescriptor *)createResponseDescriptor {
    RKObjectMapping *imagesMapping = [self createResponseMapping];
    RKResponseDescriptor *imagesResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:imagesMapping
                                                                                                  method:RKRequestMethodAny
                                                                                             pathPattern:nil
                                                                                                 keyPath:@"data"
                                                                                             statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    return imagesResponseDescriptor;
}

@end
