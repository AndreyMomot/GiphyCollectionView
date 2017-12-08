#import "SearchView.h"
#import "NSLayoutConstraint+Helpers.h"

@interface SearchView () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIButton *cancelButton;

- (UITextField *)createTextField;
- (NSArray *)createTextFieldConstraints;

@end

@implementation SearchView

#pragma mark - initialization

static id CommonInit(SearchView *self) {
    if (self != nil) {
        UITextField *textField = self.createTextField;
        textField.translatesAutoresizingMaskIntoConstraints = NO;
        self.textField = textField;
        [self addSubview:textField];
        [self addConstraints:[self createTextFieldConstraints]];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return CommonInit(self);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return CommonInit(self);;
}

#pragma mark - private methods

- (UITextField *)createTextField {
    UITextField *textField = [[UITextField alloc] init];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.layer.cornerRadius = 5.f;
    textField.layer.borderWidth = 0.5f;
    textField.layer.borderColor = [UIColor grayColor].CGColor;
    textField.clipsToBounds = YES;
    textField.font = [UIFont systemFontOfSize:15.f];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.enablesReturnKeyAutomatically = YES;
    textField.returnKeyType = UIReturnKeyGo;
    textField.leftViewMode = UITextFieldViewModeAlways;
    UIView *emptyView = [UIView new];
    emptyView.frame = CGRectMake(0.f, 0.f, 10.f, 10.f);
    textField.leftView = emptyView;
    textField.rightViewMode = UITextFieldViewModeUnlessEditing;
    textField.placeholder = NSLocalizedString(@"idsSearchFieldPlaceholder", @"");
    return textField;
}

- (NSArray *)createTextFieldConstraints {
    NSMutableArray *constraints = [NSMutableArray array];
    UITextField *textField = self.textField;
    [textField addConstraint:[NSLayoutConstraint constraintForView:textField withHeight:24]];
    [constraints addObject:[NSLayoutConstraint constraintForCenterByYView:self.textField withView:self]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[textField]-8-|"
                                                                               views:NSDictionaryOfVariableBindings(textField)]];
    
    return constraints;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.delegate searchView:self requestsString:textField.text];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.textField selectAll:self.textField];
}

@end
