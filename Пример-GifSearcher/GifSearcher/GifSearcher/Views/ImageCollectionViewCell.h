#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign, setter=setLoading:) BOOL isLoading;

@end
