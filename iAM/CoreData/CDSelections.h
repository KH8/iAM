//
//  CDSelections.h
//  iAM
//
//  Created by Krzysztof Reczek on 09.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDSelections : NSManagedObject

@property (nonatomic, retain) NSNumber * sequenceSelected;
@property (nonatomic, retain) NSNumber * stepSelected;
@property (nonatomic, retain) NSNumber * barSelected;

@end
