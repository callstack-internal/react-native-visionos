#import <UIKit/UIKit.h>

@interface RCTReactViewController : UIViewController

@property (nonatomic, strong) NSString *_Nonnull moduleName;
@property (nonatomic, strong) NSDictionary *_Nullable initialProps;

- (instancetype _Nonnull)initWithModuleName:(NSString *_Nonnull)moduleName
                                   initProps:(NSDictionary *_Nullable)initProps;

@end
