//
//  Flesch–Kincaid-iOS.h
//  Flesch–Kincaid-iOS Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014 Bracken Spencer. All rights reserved.
//

// Automated Readability Index -- automatedReadabilityIndexForString
// Flesch-Kincaid Grade Level -- fleschKincaidGradeLevelForString
// Flesch Reading Ease -- fleschReadingEaseForString
// Gunning Fog Index -- gunningFogScoreForString
// SMOG -- smogIndexForString

#import <Foundation/Foundation.h>

@interface Readability_iOS : NSObject

+ (NSDecimalNumber *)automatedReadabilityIndexForString:(NSString *)string;
+ (NSDecimalNumber *)fleschKincaidGradeLevelForString:(NSString *)string;
+ (NSDecimalNumber *)fleschReadingEaseForString:(NSString *)string;
+ (NSDecimalNumber *)gunningFogScoreForString:(NSString *)string;
+ (NSDecimalNumber *)smogIndexForString:(NSString *)string;

@end
