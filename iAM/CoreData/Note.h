//
//  Note.h
//  iAM
//
//  Created by Krzysztof Reczek on 25.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bar;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * noteBarId;
@property (nonatomic, retain) NSNumber * noteCoordLine;
@property (nonatomic, retain) NSNumber * noteCoordPos;
@property (nonatomic, retain) NSNumber * noteId;
@property (nonatomic, retain) Bar *bar;

@end
