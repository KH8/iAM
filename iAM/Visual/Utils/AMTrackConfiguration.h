//
//  AMTrackConfiguration.h
//  iAM
//
//  Created by Krzysztof Reczek on 20.06.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMVolumeSlider.h"
#import "AMPanSlider.h"
#import "AMPlayer.h"
#import <Foundation/Foundation.h>

@interface AMTrackConfiguration : NSObject

- (id)initWithLabel:(UILabel *)soundLabel
             button:(UIButton *)soundButton
       volumeSlider:(AMVolumeSlider *)volumeSlider
          panSlider:(AMPanSlider *)panSlider
             player:(AMPlayer *)player
     viewController:(UIViewController *)parent
     soundSegueName:(NSString *)segueName
     popupSegueName:(NSString *)popupSegueName;

- (void)refresh;

@end
