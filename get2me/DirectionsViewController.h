#import <UIKit/UIKit.h>

@protocol DirectionsViewControllerDelegate;

@interface DirectionsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *startField;
@property (nonatomic, strong) IBOutlet UITextField *endField;

@property (nonatomic, weak) id<DirectionsViewControllerDelegate> delegate;

@end

@protocol DirectionsViewControllerDelegate <NSObject>

- (void)directionsViewControllerDidCancel:(DirectionsViewController *)viewController;
- (void)directionsViewController:(DirectionsViewController *)viewController routeFromAddress:(NSString *)startAddress toAddress:(NSString *)endAddress;

@end
