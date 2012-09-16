#import "DirectionsViewController.h"

@implementation DirectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Route" style:UIBarButtonItemStyleDone target:self action:@selector(route:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    startLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    startLabel.text = @"Start:";
    startLabel.textColor = [UIColor grayColor];
    startLabel.textAlignment = NSTextAlignmentRight;
    [startLabel sizeToFit];
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    endLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    endLabel.text = @"End:";
    endLabel.textColor = [UIColor grayColor];
    endLabel.textAlignment = NSTextAlignmentRight;
    [endLabel sizeToFit];
    
    // Make the widths match so they offset the text by the same amount
    CGRect frame = startLabel.frame;
    frame.size.width = MAX(startLabel.frame.size.width, endLabel.frame.size.width);
    startLabel.frame = frame;
    endLabel.frame = frame;
    
    self.startField.leftView = startLabel;
    self.startField.leftViewMode = UITextFieldViewModeAlways;
    self.endField.leftView = endLabel;
    self.endField.leftViewMode = UITextFieldViewModeAlways;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.startField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.endField];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)title
{
    return @"Directions";
}

- (void)cancel:(id)sender
{
    [self.delegate directionsViewControllerDidCancel:self];
}

- (void)route:(id)sender
{
    [self.delegate directionsViewController:self routeFromAddress:self.startField.text toAddress:self.endField.text];
}

- (UIReturnKeyType)currentReturnKeyType
{
    if (self.startField.text.length > 0 && self.endField.text.length > 0) {
        return UIReturnKeyRoute;
    } else {
        return UIReturnKeyNext;
    }
}

- (void)textDidChange:(NSNotification *)notification
{
    self.navigationItem.rightBarButtonItem.enabled = (self.startField.text.length > 0 && self.endField.text.length > 0);
    
    UITextField *textField = [notification object];
    
    // Update the return key
    UIReturnKeyType returnKeyType = [self currentReturnKeyType];
    if (textField.returnKeyType != returnKeyType) {
        textField.returnKeyType = returnKeyType;
        [textField reloadInputViews];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.returnKeyType = [self currentReturnKeyType];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.startField.text.length > 0 && self.endField.text.length > 0) {
        [self route:self];
        return YES;
    }
    
    // Go to the empty field
    UITextField *emptyTextField = (textField == self.startField ? self.endField : self.startField);
    [emptyTextField becomeFirstResponder];
    return YES;
}

@end
