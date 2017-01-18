#import <GoogleMobileAds/GoogleMobileAds.h>
#import "iAdMob.h"


@interface B4IBannerDelegate:NSObject <GADBannerViewDelegate>

@end

@implementation B4IBannerDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)view {
    [B4IObjectWrapper raiseEvent:view :@"_receivead" :nil];
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    [B4IObjectWrapper raiseEvent:view :@"_failedtoreceivead:" :@[error.description]];
}

@end

@implementation B4IAdView
#define AD ((GADBannerView *) self.object)
+(Class)getClass {
    return [GADBannerView class];
}

- (NSObject *)SIZE_BANNER {
    return [NSValue valueWithBytes:&kGADAdSizeBanner objCType:@encode(GADAdSize)];
}

- (NSObject *)SIZE_LARGE_BANNER {
    return [NSValue valueWithBytes:&kGADAdSizeLargeBanner objCType:@encode(GADAdSize)];
}

- (NSObject *)SIZE_FULL_BANNER {
    return [NSValue valueWithBytes:&kGADAdSizeFullBanner objCType:@encode(GADAdSize)];
}

- (NSObject *)SIZE_LEADERBOARD {
    return [NSValue valueWithBytes:&kGADAdSizeLeaderboard objCType:@encode(GADAdSize)];
}

- (NSObject *)SIZE_SMART_BANNER_PORTRAIT {
    return [NSValue valueWithBytes:&kGADAdSizeSmartBannerPortrait objCType:@encode(GADAdSize)];
}

- (NSObject *)SIZE_SMART_BANNER_LANDSCAPE {
    return [NSValue valueWithBytes:&kGADAdSizeSmartBannerLandscape objCType:@encode(GADAdSize)];
}

- (void)Initialize:(B4I *)bi :(NSString *)EventName :(NSString *)AdUnit :(B4IPage *)Parent :(NSObject *)AdSize {
    GADAdSize size;
    [(NSValue *)AdSize getValue:&size];
    GADBannerView *v = [[GADBannerView alloc] initWithAdSize:size];
    v.adUnitID = AdUnit;
    v.rootViewController = Parent.object;
    self.object = v;
    [super innerInitialize:bi :EventName :true];
    B4IBannerDelegate *del = [B4IBannerDelegate new];
    v.delegate = del;
    [B4IObjectWrapper getMap:v][@"delegate"] = del;
}
- (void)LoadAd {
    GADRequest *req = [GADRequest request];
    NSArray *arr = [B4IObjectWrapper getMap:AD][@"testDevices"];
    req.testDevices = arr;
    [AD loadRequest:req];
}
- (void)SetTestDevices:(B4IList *)DeviceIds {
    [B4IObjectWrapper getMap:AD][@"testDevices"] = DeviceIds.object;
}
@end
@interface B4IAdInterstitial (private) <GADInterstitialDelegate>

@end
@implementation B4IAdInterstitial {
    NSArray *testDevices;
    NSString *adu;
    GADInterstitial *ad;
}

- (void)Initialize:(B4I*)bi :(NSString*)EventName :(NSString *)AdUnit {
    [B4IObjectWrapper setBIAndEventName:self :bi :EventName];
    adu = AdUnit;
}

- (void)interstitial:(GADInterstitial *)ad1 didFailToReceiveAdWithError:(GADRequestError *)error {
    [B4I shared].lastError = error;
    [B4IObjectWrapper raiseUIEvent:self :@"_ready:" :@[@false]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [B4IObjectWrapper raiseUIEvent:self :@"_ready:" :@[@true]];
}
- (void)SetTestDevices:(B4IList *)DeviceIds {
    testDevices = DeviceIds.object;
}
- (void)RequestAd {
    ad = [[GADInterstitial alloc] initWithAdUnitID:adu];
    GADRequest *req = [GADRequest request];
    ad.delegate = self;
    if (testDevices != nil)
        req.testDevices = testDevices;
    [ad loadRequest:req];
}
- (BOOL)IsReady {
    return ad.isReady;
}
- (void)Show:(B4IPage *)Parent {
    [ad presentFromRootViewController:Parent.object];
}
@end

@interface B4IRewardVideoDelegate:NSObject <GADRewardBasedVideoAdDelegate>

@end

@implementation B4IRewardVideoDelegate
- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didFailToLoadWithError:(NSError *)error {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_failedtoreceivead:" :@[error.description]];
}

- (void)rewardBasedVideoAdDidReceiveAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_receivead" :nil];
}

- (void)rewardBasedVideoAdDidOpen:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_adopened" :nil];
}

- (void)rewardBasedVideoAdDidStartPlaying:(GADRewardBasedVideoAd *)rewardBasedVideoAd {

}

- (void)rewardBasedVideoAdDidClose:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_adclosed" :nil];
}

- (void)rewardBasedVideoAdWillLeaveApplication:(GADRewardBasedVideoAd *)rewardBasedVideoAd {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_adleftapplication" :nil];
}

- (void)rewardBasedVideoAd:(GADRewardBasedVideoAd *)rewardBasedVideoAd didRewardUserWithReward:(GADAdReward *)reward {
    [B4IObjectWrapper raiseUIEvent:rewardBasedVideoAd :@"_rewarded:" :@[reward]];
}


@end


@implementation B4IRewardedVideoAd
#define REW ((GADRewardBasedVideoAd *) self.object)
+(Class)getClass {
    return [GADRewardBasedVideoAd class];
}

- (BOOL)Ready {
    return [REW isReady];
}

- (void)Initialize:(B4I *)bi :(NSString *)EventName {
    GADRewardBasedVideoAd *r = [[GADRewardBasedVideoAd alloc] init];
    self.object = r;
    B4IRewardVideoDelegate* del = [B4IRewardVideoDelegate new];
    r.delegate = del;
    [B4IObjectWrapper getMap:r][@"delegate"] = del;
    [B4IObjectWrapper setBIAndEventName:REW :bi :EventName];
}

- (void)LoadAd:(NSString *)AdUnitId {
    [REW loadRequest:[GADRequest request] withAdUnitID:AdUnitId];
}

- (void)Show:(B4IPage *)Parent {
    [REW presentFromRootViewController:Parent.object];
}

@end