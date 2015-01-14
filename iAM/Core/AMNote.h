//
//  AMNote.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AMNoteDelegate <NSObject>

@required

- (void) noteHasBeenTriggered;

@end

@interface AMNote : NSObject
{
    // Delegate to respond back
    id <AMNoteDelegate> _delegate;

}
@property (nonatomic,strong) id delegate;
@property NSNumber *id;

- (BOOL)isSelected;
- (BOOL)isTriggered;
- (BOOL)isPlaying;

- (void)select;
- (void)trigger;

@end
