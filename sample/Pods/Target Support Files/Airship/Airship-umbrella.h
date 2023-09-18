#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AirshipAutomationLib.h"
#import "UAActionSchedule.h"
#import "UAAirshipAutomationCoreImport.h"
#import "UAAutomationResources.h"
#import "UAAutomationSDKModule.h"
#import "UACancelSchedulesAction.h"
#import "UADeferredSchedule.h"
#import "UAInAppAutomation.h"
#import "UAInAppMessage.h"
#import "UAInAppMessageAdapterProtocol.h"
#import "UAInAppMessageAssetManager.h"
#import "UAInAppMessageAssets.h"
#import "UAInAppMessageBannerAdapter.h"
#import "UAInAppMessageBannerDisplayContent.h"
#import "UAInAppMessageBannerStyle.h"
#import "UAInAppMessageButtonInfo.h"
#import "UAInAppMessageButtonStyle.h"
#import "UAInAppMessageCustomDisplayContent.h"
#import "UAInAppMessageDefaultDisplayCoordinator.h"
#import "UAInAppMessageDefaultPrepareAssetsDelegate.h"
#import "UAInAppMessageDisplayContent.h"
#import "UAInAppMessageDisplayCoordinator.h"
#import "UAInAppMessageFullScreenAdapter.h"
#import "UAInAppMessageFullScreenDisplayContent.h"
#import "UAInAppMessageFullScreenStyle.h"
#import "UAInAppMessageHTMLAdapter.h"
#import "UAInAppMessageHTMLDisplayContent.h"
#import "UAInAppMessageHTMLStyle.h"
#import "UAInAppMessageImmediateDisplayCoordinator.h"
#import "UAInAppMessageManager.h"
#import "UAInAppMessageMediaInfo.h"
#import "UAInAppMessageMediaStyle.h"
#import "UAInAppMessageModalAdapter.h"
#import "UAInAppMessageModalDisplayContent.h"
#import "UAInAppMessageModalStyle.h"
#import "UAInAppMessageResolution.h"
#import "UAInAppMessageSceneManager.h"
#import "UAInAppMessageSchedule.h"
#import "UAInAppMessageStyleProtocol.h"
#import "UAInAppMessageTextInfo.h"
#import "UAInAppMessageTextStyle.h"
#import "UALandingPageAction.h"
#import "UALegacyInAppMessage.h"
#import "UALegacyInAppMessaging.h"
#import "UAPadding.h"
#import "UASchedule.h"
#import "UAScheduleAction.h"
#import "UAScheduleAudience.h"
#import "UAScheduleDeferredData.h"
#import "UAScheduleDelay.h"
#import "UAScheduleEdits.h"
#import "UAScheduleTrigger.h"
#import "UATagSelector.h"
#import "AirshipBasementLib.h"
#import "UAAppIntegrationDelegate.h"
#import "UAAutoIntegration.h"
#import "UAComponent.h"
#import "UACompression.h"
#import "UADisposable.h"
#import "UAEvent.h"
#import "UAFeature.h"
#import "UAGlobal.h"
#import "UALegacyAction.h"
#import "UALegacyLoggingBridge.h"
#import "UALegacySDKModule.h"
#import "UAPush.h"
#import "UAURLAllowListScope.h"
#import "AirshipKit.h"

FOUNDATION_EXPORT double AirshipKitVersionNumber;
FOUNDATION_EXPORT const unsigned char AirshipKitVersionString[];

