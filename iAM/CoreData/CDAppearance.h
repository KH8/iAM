//
//  CDAppearance.h
//  iAM
//
//  Created by Krzysztof Reczek on 15.04.2015.
//  Copyright (c) 2015 H@E. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDAppearance : NSManagedObject

@property (nonatomic, retain) NSString * tintColorKey;
@property (nonatomic, retain) NSString * colorThemeKey;

@end
