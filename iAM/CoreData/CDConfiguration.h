//
//  CDConfiguration.h
//  iAM
//
//  Created by Krzysztof Reczek on 27.04.2015.
//  Copyright (c) 2015 miscApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDConfiguration : NSManagedObject

@property(nonatomic, retain) NSString *soundTrack1Key;
@property(nonatomic, retain) NSString *soundTrack1Value;
@property(nonatomic, retain) NSString *soundTrack2Key;
@property(nonatomic, retain) NSString *soundTrack2Value;
@property(nonatomic, retain) NSString *soundTrack3Key;
@property(nonatomic, retain) NSString *soundTrack3Value;
@property(nonatomic, retain) NSNumber *volumeGeneral;
@property(nonatomic, retain) NSNumber *volumeTrack1;
@property(nonatomic, retain) NSNumber *volumeTrack2;
@property(nonatomic, retain) NSNumber *volumeTrack3;

@end
