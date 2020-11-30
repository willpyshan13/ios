//
//  GlobalData.m
//
//  Created by 123a on 13-10-24.
//

#import "ZVGlobalData.h"
#import "Reachability.h"
#import "NCSwitchWifiIp.h"
#import "AppDelegate.h"

@interface ZVGlobalData ()

@property (nonatomic) Reachability *hostReachability;

@end;

@implementation ZVGlobalData

static ZVGlobalData  * instance = nil;

+ (instancetype)shared {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    }) ;
    return instance;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    
    return [ZVGlobalData shared];
    
}


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        NSString *remoteHostName = @"www.baidu.com";
        self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
        [self.hostReachability startNotifier];
        [self updateInterfaceWithReachability];

    }
    
    return  self;
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability];
}


- (void)updateInterfaceWithReachability
{
    NetworkStatus netStatus = [self.hostReachability currentReachabilityStatus];
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.currentNetworkStatus = netStatus;
    
    switch (netStatus)
    {
        case NotReachable:        {
            NSLog(@"----------------------无网络");
            break;
        }

        case ReachableViaWWAN:        {
            NSLog(@"----------------------手机网络");
            break;
        }
        case ReachableViaWiFi:        {
            NSLog(@"----------------------wifi网络");
            
            if (appdelegate.wifiUrlIp == nil || appdelegate.isOK == NO) {
                [NCSwitchWifiIp checkBaseUrl];
            }
            break;
        }
    }
        
  

}


@end
