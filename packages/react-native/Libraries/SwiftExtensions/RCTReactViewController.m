#import "RCTReactViewController.h"
#import <React/RCTConstants.h>
#import <React/RCTUtils.h>
#import <React/RCTRootView.h>
#import <React-RCTAppDelegate/RCTAppDelegate.h>

@protocol RCTRootViewFactoryProtocol <NSObject>

- (UIView *)viewWithModuleName:(NSString *)moduleName initialProperties:(NSDictionary*)initialProperties launchOptions:(NSDictionary*)launchOptions;

@end

@protocol RCTFocusedWindowProtocol <NSObject>

@property (nonatomic, nullable) UIWindow *lastFocusedWindow;

@end

@implementation RCTReactViewController

- (instancetype)initWithModuleName:(NSString *)moduleName initProps:(NSDictionary *)initProps {
    if (self = [super init]) {
        _moduleName = moduleName;
        _initialProps = initProps;
    }
    return self;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [[NSNotificationCenter defaultCenter] postNotificationName:RCTWindowFrameDidChangeNotification object:self];
}

- (void)loadView {
  RCTAppDelegate * appDelegate = (RCTAppDelegate *)[UIApplication sharedApplication].delegate;
    if ([appDelegate respondsToSelector:@selector(rootViewFactory)]) {
        self.view = [appDelegate.rootViewFactory viewWithModuleName:_moduleName initialProperties:_initialProps];
    } else {
        [NSException raise:@"UIApplicationDelegate:viewWithModuleName:initialProperties:launchOptions: not implemented"
                    format:@"Make sure you subclass RCTAppDelegate"];
    }
}

- (void)viewDidLoad {
  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
  [self.view addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer*)recognizer {
  id<RCTFocusedWindowProtocol> appDelegate = (id<RCTFocusedWindowProtocol>)RCTSharedApplication().delegate;
  
  if (![appDelegate respondsToSelector:@selector(lastFocusedWindow)]) {
    return;
  }
  
  UIWindow *targetWindow = recognizer.view.window;
  if (targetWindow != appDelegate.lastFocusedWindow) {
    appDelegate.lastFocusedWindow = targetWindow;
  }
}

- (void)updateProps:(NSDictionary *)newProps {
  RCTRootView *rootView = (RCTRootView *)self.view;
  if (rootView.appProperties == newProps) {
    return;
  }
  
  if (newProps != nil && ![rootView.appProperties isEqualToDictionary:newProps]) {
    [rootView setAppProperties:newProps];
  }
}
@end
