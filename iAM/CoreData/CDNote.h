//
//  CDNote.h
//  iAM
//
//  Created by Krzysztof Reczek on 04.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDBar;

@interface CDNote : NSManagedObject

@property (nonatomic, retain) NSNumber * noteCoordLine;
@property (nonatomic, retain) NSNumber * noteCoordPos;
@property (nonatomic, retain) CDBar *bar;

@end
