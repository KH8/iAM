//
//  AMAudioSessionHandler.h
//  iAM
//
//  Created by Krzysztof Reczek on 02.07.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AMViewController.h"
#import <UIKit/UIKit.h>

@interface AMAudioSessionHandler : NSObject

- (id)initWithController:(AMViewController *)controller
            andSeguencer:(AMSequencer *)mainSequencer ;

- (void)initAudioSession;

- (void)deinitAudioSession;

- (void)updateSession;

- (void)startPlayback;

- (void)stopPlayback;

@end
