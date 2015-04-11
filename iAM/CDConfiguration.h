//
//  CDConfiguration.h
//  iAM
//
//  Created by Krzysztof Reczek on 11.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDConfiguration : NSManagedObject

@property (nonatomic, retain) NSString * soundTrack1;
@property (nonatomic, retain) NSString * soundTrack2;
@property (nonatomic, retain) NSString * soundTrack3;
@property (nonatomic, retain) NSNumber * volumeGeneral;
@property (nonatomic, retain) NSNumber * volumeTrack1;
@property (nonatomic, retain) NSNumber * volumeTrack2;
@property (nonatomic, retain) NSNumber * volumeTrack3;
@property (nonatomic, retain) NSString * colorTheme;
@property (nonatomic, retain) NSString * colorTint;

@end
