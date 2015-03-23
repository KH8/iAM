//
//  Notes.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSNumber * noteBarId;
@property (nonatomic, retain) NSNumber * noteCoordLine;
@property (nonatomic, retain) NSNumber * noteCoordPos;
@property (nonatomic, retain) NSNumber * noteId;

@end
