//
//  Step.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Step : NSManagedObject

@property (nonatomic, retain) NSNumber * stepId;
@property (nonatomic, retain) NSString * stepName;
@property (nonatomic, retain) NSNumber * stepNumberOfLoops;
@property (nonatomic, retain) NSNumber * stepSequenceId;
@property (nonatomic, retain) NSNumber * stepType;

@end
