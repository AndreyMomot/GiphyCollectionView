#import "ImageCollectionViewCell.h"
#import "NSLayoutConstraint+Helpers.h"

@interface ImageCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIActivityIndicatorView *indicatorView;

@end

@implementation ImageCollectionViewCell

#pragma mark - properties

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (UIImage *)image {
    return self.imageView.image;
}

- (void)setLoading:(BOOL)isLoading {
    _isLoading = isLoading;
    if (isLoading) {
        [self.indicatorView startAnimating];
    }
    else {
        [self.indicatorView stopAnimating];
    }
}

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsForWrappedSubview:self.imageView
                                                                               withInsets:UIEdgeInsetsZero]];
        
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        self.indicatorView = indicatorView;
        [self addSubview:indicatorView];
        [self addConstraint:[NSLayoutConstraint constraintForCenterByXView:indicatorView withView:self]];
        [self addConstraint:[NSLayoutConstraint constraintForCenterByYView:indicatorView withView:self]];
        [self.indicatorView startAnimating];
        self.isLoading = YES;
        
        [self.imageView addObserver:self
                         forKeyPath:@"image"
                            options:NSKeyValueObservingOptionNew
                            context:NULL];
    }
    return self;
}

- (void)dealloc {
    [self.imageView removeObserver:self forKeyPath:@"image"];
}

#pragma mark - private methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == self.imageView && [keyPath isEqualToString:@"image"]) {
        if (change[NSKeyValueChangeNewKey] == nil || [change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
            self.isLoading = YES;
        }
        else {
            self.isLoading = NO;
        }
    }
}

@end
