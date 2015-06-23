//
//  AMNote.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMClonableObject.h"

@protocol AMNoteDelegate <NSObject>

@required

- (void)noteStateHasBeenChanged;

@end

@interface AMNote : AMClonableObject

@property NSNumber *id;
@property(nonatomic, weak) id <AMNoteDelegate> delegate;

- (BOOL)isSelected;

- (BOOL)isTriggered;

- (BOOL)isPlaying;

- (BOOL)isMajorNote;

- (void)select;

- (void)trigger;

- (void)changeSelectState:(BOOL)state;

- (void)changeTriggerMarker:(BOOL)state;

- (void)markMajorNoteState:(BOOL)state;

@end
