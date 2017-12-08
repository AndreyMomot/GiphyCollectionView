#import "ImagesCollectionViewController.h"
#import "GiphyFacade.h"
#import "SearchView.h"
#import "ImageCollectionViewCell.h"
#import "ImageDescription.h"
#import <AFNetworking/AFNetworking.h>
#import <RestKit/RestKit.h>
#import "UIImage+animatedGIF.h"
#import "Macros.h"

// TODO: keyboard events

static NSString *const kImageCellId = @"ImageCellId";

@interface ImagesCollectionViewController () <SearchViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (nonatomic, strong) GiphyFacade *giphyFacade;
@property (nonatomic, strong) NSArray *imageDescriptions;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *stateDescriptionsLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomOffset;

@property (nonatomic, strong) NSOperationQueue *loadingImagesQueue;

- (void)showConnectionError;
- (void)loadImages;
- (void)setDescriptionLabelLoading:(BOOL)loading;

@end

@implementation ImagesCollectionViewController

#pragma mark - properties

- (void)setImageDescriptions:(NSArray *)imageDescriptions {
    _imageDescriptions = imageDescriptions;
    self.stateDescriptionsLabel.hidden = !(imageDescriptions.count == 0);
}

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingImagesQueue = [[NSOperationQueue alloc] init];
    [self.collectionView registerClass:[ImageCollectionViewCell class]
            forCellWithReuseIdentifier:kImageCellId];
}

- (void)dealloc {
    [self.loadingImagesQueue cancelAllOperations];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.imageDescriptions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = (ImageCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:kImageCellId
                                                                                                              forIndexPath:indexPath];
    ImageDescription *description = self.imageDescriptions[indexPath.row];
    cell.image = description.image;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    return CGSizeMake(screenSize.width / 4.f, screenSize.width / 5.f);
}


#pragma mark - SearchViewDelegate

- (void)searchView:(SearchView *)view requestsString:(NSString *)requestString {
    [self.loadingImagesQueue cancelAllOperations];
    self.imageDescriptions = nil;
    [self.collectionView reloadData];
    [self setDescriptionLabelLoading:YES];
    WeakifySelf;
    [[GiphyFacade sharedInstance] getGifsDescriptionsWithRequest:requestString
                                                    successBlock:^(NSArray *descriptions) {
                                                        StrongifySelf;
                                                        self.imageDescriptions = descriptions;
                                                        [self setDescriptionLabelLoading:NO];
                                                        [self.collectionView reloadData];
                                                        [self loadImages];
                                                    } failBlock:^(NSError *error) {
                                                        StrongifySelf;
                                                        [self setDescriptionLabelLoading:NO];
                                                        [self showConnectionError];
                                                    }
                                                     targetQueue:dispatch_get_main_queue()];
}

#pragma mark - private methods

- (void)showConnectionError {
    NSString *title = @"Connection error";
    NSString *alertMesage = @"Connection error";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:alertMesage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                     }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                     }];
}

- (void)loadImages {
    [self.imageDescriptions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ImageDescription *description = (ImageDescription *)obj;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:description.url]];
        AFHTTPRequestOperation *imageRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        WeakifySelf;
        
        [imageRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            StrongifySelf;
            
            NSData *imageData = operation.responseData;
            description.image = [UIImage animatedImageWithAnimatedGIFData:imageData];
            
            // TODO: find index by url
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            // TODO: handle
        }];
        [self.loadingImagesQueue addOperation:imageRequestOperation];
    }];
}

- (void)setDescriptionLabelLoading:(BOOL)loading {
    if (loading) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        self.stateDescriptionsLabel.text = @"Loading";
    }
    else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (self.imageDescriptions.count == 0) {
            self.stateDescriptionsLabel.text = @"Try another request";
        }
    }
}

@end
