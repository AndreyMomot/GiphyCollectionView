#import <UIKit/UIKit.h>

@protocol SearchViewDelegate;

@interface SearchView : UIView

@property (nonatomic, weak) IBOutlet id <SearchViewDelegate> delegate;

@end

@protocol SearchViewDelegate

- (void)searchView:(SearchView *)view requestsString:(NSString *)requestString;

@end

