//
//  Sequences.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Sequences : NSManagedObject

@property (nonatomic, retain) NSDate * sequenceCreationDate;
@property (nonatomic, retain) NSNumber * sequenceId;
@property (nonatomic, retain) NSString * sequenceName;

@end
