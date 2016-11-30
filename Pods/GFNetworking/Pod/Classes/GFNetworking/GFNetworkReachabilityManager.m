// GFNetworkReachabilityManager.m
// 
// Copyright (c) 2013-2014 GFNetworking (http://afnetworking.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "GFNetworkReachabilityManager.h"

#import <UIKit/UIKit.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

NSString *const kGFNetworkingReachabilityDidChangeNotification = @"kReachabilityChangedNotification";

@class GFNetworkReachabilityManager;

typedef void (^GFNetworkReachable)(GFNetworkReachabilityManager * reachability);
typedef void (^GFNetworkUnreachable)(GFNetworkReachabilityManager * reachability);

@interface GFNetworkReachabilityManager ()

@property (nonatomic, copy) GFNetworkReachable    reachableBlock;
@property (nonatomic, copy) GFNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;
@property (nonatomic, strong) dispatch_queue_t          reachabilitySerialQueue;
@property (nonatomic, strong) id                        reachabilityObject;

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags;
- (BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags;

@end

static void TMReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target)
    
    GFNetworkReachabilityManager *reachability = ((__bridge GFNetworkReachabilityManager*)info);
    
    @autoreleasepool {
        [reachability reachabilityChanged:flags];
    }
}

@implementation GFNetworkReachabilityManager

+ (instancetype)sharedManager {
    static GFNetworkReachabilityManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger systemVersion = [[[UIDevice currentDevice] systemVersion] integerValue];

        instance = systemVersion >= 8 ? [self reachabilityForInternetConnection] : [self reachabilityWithHostname:@"www.baidu.com"];
    });
    return instance;
}

+ (instancetype)reachabilityWithHostname:(NSString*)hostname {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [hostname UTF8String]);
    if (ref) {
        return [[self alloc] initWithReachability:ref];
    }
    
    return nil;
}

+ (instancetype)reachabilityWithAddress:(void *)hostAddress {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
    if (ref) {
        return [[self alloc] initWithReachability:ref];
    }
    
    return nil;
}

+ (instancetype)reachabilityForInternetConnection {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    return [self reachabilityWithAddress:&zeroAddress];
}

+ (instancetype)managerForDomain:(NSString *)domain {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithName(NULL, [domain UTF8String]);
    if (ref) {
        return [[self alloc] initWithReachability:ref];
    }
    
    return nil;
}

+ (instancetype)managerForAddress:(const void *)address {
    SCNetworkReachabilityRef ref = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)address);
    if (ref) {
        return [[self alloc] initWithReachability:ref];
    }
    
    return nil;
}

- (instancetype)initWithReachability:(SCNetworkReachabilityRef)reachability {
    if (self = [super init]) {
        self.reachableViaWWAN = YES;
        self.reachabilityRef = reachability;
        self.reachabilitySerialQueue = dispatch_queue_create("com.tonymillion.reachability", NULL);
    }
    
    return self;
}

- (BOOL)startMonitoring {
    if(self.reachabilityObject && (self.reachabilityObject == self)) {
        return YES;
    }
    
    SCNetworkReachabilityContext context = { 0, NULL, NULL, NULL, NULL };
    context.info = (__bridge void *)self;
    
    if(SCNetworkReachabilitySetCallback(self.reachabilityRef, TMReachabilityCallback, &context)) {
        
        if(SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, self.reachabilitySerialQueue)) {
            self.reachabilityObject = self;
            return YES;
        } else {
#ifdef DEBUG
            NSLog(@"SCNetworkReachabilitySetDispatchQueue() failed: %s", SCErrorString(SCError()));
#endif
            SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
        }
    } else {
#ifdef DEBUG
        NSLog(@"SCNetworkReachabilitySetCallback() failed: %s", SCErrorString(SCError()));
#endif
    }
    
    self.reachabilityObject = nil;
    return NO;
}

- (void)stopMonitoring {
    SCNetworkReachabilitySetCallback(self.reachabilityRef, NULL, NULL);
    SCNetworkReachabilitySetDispatchQueue(self.reachabilityRef, NULL);
    
    self.reachabilityObject = nil;
}

#pragma mark - Getter Methods

- (BOOL)isReachable {
    SCNetworkReachabilityFlags flags;
    
    if(!SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
        return NO;
    
    return [self isReachableWithFlags:flags];
}

- (BOOL)isReachableViaWWAN {
#if	TARGET_OS_IPHONE
    
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        // Check we're REACHABLE
        if(flags & kSCNetworkReachabilityFlagsReachable)
        {
            // Now, check we're on WWAN
            if(flags & kSCNetworkReachabilityFlagsIsWWAN)
            {
                return YES;
            }
        }
    }
#endif
    
    return NO;
}

- (BOOL)isReachableViaWiFi {
    SCNetworkReachabilityFlags flags = 0;
    
    if(SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags))
    {
        // Check we're reachable
        if((flags & kSCNetworkReachabilityFlagsReachable))
        {
#if	TARGET_OS_IPHONE
            // Check we're NOT on WWAN
            if((flags & kSCNetworkReachabilityFlagsIsWWAN))
            {
                return NO;
            }
#endif
            return YES;
        }
    }
    
    return NO;
}

- (GFNetworkReachabilityStatus)networkReachabilityStatus {
    if([self isReachable]) {
        if([self isReachableViaWiFi])
            return GFNetworkReachabilityStatusReachableViaWiFi;
        
#if	TARGET_OS_IPHONE
        return GFNetworkReachabilityStatusReachableViaWWAN;
#endif
    }
    
    return GFNetworkReachabilityStatusNotReachable;
}

- (NSString *)localizedNetworkReachabilityStatusString {
    GFNetworkReachabilityStatus temp = self.networkReachabilityStatus;
    
    if(temp == GFNetworkReachabilityStatusReachableViaWWAN) {
        return NSLocalizedString(@"Current network connection type: WWAN", @"");
    } else if (temp == GFNetworkReachabilityStatusReachableViaWiFi) {
        return NSLocalizedString(@"Current network connection type: WIFI", @"");
    }
    
    return NSLocalizedString(@"Current network connection type: No Connection", @"");
}

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags {
    if([self isReachableWithFlags:flags]) {
        if(self.reachableBlock) {
            self.reachableBlock(self);
        }
    } else {
        if(self.unreachableBlock) {
            self.unreachableBlock(self);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kGFNetworkingReachabilityDidChangeNotification
                                                            object:self];
    });
}

#define testcase (kSCNetworkReachabilityFlagsConnectionRequired | kSCNetworkReachabilityFlagsTransientConnection)

-(BOOL)isReachableWithFlags:(SCNetworkReachabilityFlags)flags
{
    BOOL connectionUP = YES;
    
    if(!(flags & kSCNetworkReachabilityFlagsReachable))
        connectionUP = NO;
    
    if( (flags & testcase) == testcase )
        connectionUP = NO;
    
#if	TARGET_OS_IPHONE
    if(flags & kSCNetworkReachabilityFlagsIsWWAN) {
        if(!self.reachableViaWWAN) {
            connectionUP = NO;
        }
    }
#endif
    
    return connectionUP;
}

-(void)dealloc
{
    [self stopMonitoring];
    
    if(self.reachabilityRef) {
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }
    
    self.reachableBlock          = nil;
    self.unreachableBlock        = nil;
    self.reachabilitySerialQueue = nil;
}

@end
