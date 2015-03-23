//
//  Bars.h
//  iAM
//
//  Created by Krzysztof Reczek on 23.03.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bars : NSManagedObject

@property (nonatomic, retain) NSNumber * barDensity;
@property (nonatomic, retain) NSNumber * barId;
@property (nonatomic, retain) NSNumber * barSigDenominator;
@property (nonatomic, retain) NSNumber * barSigNumerator;
@property (nonatomic, retain) NSNumber * barStepId;
@property (nonatomic, retain) NSNumber * barTempo;

@end
