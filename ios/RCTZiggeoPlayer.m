//
//  RCTZiggeoPlayer.m
//  ReactIntegrationDemo
//
//  Copyright © 2017 Ziggeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RCTZiggeoPlayer.h"
#import <Ziggeo/Ziggeo.h>
#import <React/RCTLog.h>
@import AVKit;
@implementation RCTZiggeoPlayer

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(setAppToken:(NSString *)token)
{
  RCTLogInfo(@"application token set: %@", token);
  _appToken = token;
}

RCT_EXPORT_METHOD(play:(NSString*)videoToken)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    Ziggeo* ziggeo = [[Ziggeo alloc] initWithToken:self.appToken];
    ZiggeoPlayer* player = nil;

    NSMutableDictionary* mergedParams = nil;
    if(self->_additionalParams != nil)
    {
        mergedParams = [[NSMutableDictionary alloc] initWithDictionary:self->_additionalParams];
        if(self->_themeParams) [mergedParams addEntriesFromDictionary:self->_themeParams];
    }
    else if(self->_themeParams != nil)
    {
        mergedParams = [[NSMutableDictionary alloc] initWithDictionary:self->_themeParams];
    }
    bool hideControls = mergedParams && ([@"true" isEqualToString:mergedParams[@"hidePlayerControls"]] || [[mergedParams valueForKey:@"hidePlayerControls"] boolValue] );

    if(mergedParams == nil)
    {
        player = [[ZiggeoPlayer alloc] initWithZiggeoApplication:ziggeo videoToken:videoToken];
        AVPlayerViewController* playerController = [[AVPlayerViewController alloc] init];
        playerController.player = player;
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerController animated:true completion:nil];
        [playerController.player play];
    }
    else {
        [ZiggeoPlayer createPlayerWithAdditionalParams:ziggeo videoToken:videoToken params:mergedParams callback:^(ZiggeoPlayer *player) {
            AVPlayerViewController* playerController = [[AVPlayerViewController alloc] init];
            playerController.player = player;
            
            if(hideControls)
            {
                player.didFinishPlaying = ^(NSString *videoToken, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^
                    {
                       [playerController dismissViewControllerAnimated:true completion:nil];
                    });
                };
                playerController.showsPlaybackControls = false;
            }
            
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerController animated:true completion:nil];
            [playerController.player play];
        }];
    }
  });
}

RCT_EXPORT_METHOD(setExtraArgsForPlayer:(NSDictionary*)map)
{
    _additionalParams = map;
}

RCT_EXPORT_METHOD(setThemeArgsForPlayer:(NSDictionary*)map)
{
    _themeParams = map;
}

@end
