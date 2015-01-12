//
//  AMNote.h
//  iAM
//
//  Created by Krzysztof Reczek on 08.01.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NoteDelegate <NSObject>

@required

- (void) noteHasBeenTriggered;

@end

@interface AMNote : NSObject
{
    // Delegate to respond back
    id <NoteDelegate> _delegate;

}
@property (nonatomic,strong) id delegate;
@property NSNumber *id;

- (BOOL)isSelected;

- (void)select;
- (void)play;

@end
