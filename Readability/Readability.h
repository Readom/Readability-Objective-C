//
//  Readability.h
//  Readability-Objective-C Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

@import Foundation;

@interface Readability : NSObject

+ (NSDecimalNumber *)automatedReadabilityIndexForString:(NSString *)string; // Automated Readability Index
+ (NSDecimalNumber *)fleschKincaidGradeLevelForString:(NSString *)string; // Flesch-Kincaid Grade Level
+ (NSDecimalNumber *)fleschReadingEaseForString:(NSString *)string; // Flesch Reading Ease
+ (NSDecimalNumber *)gunningFogScoreForString:(NSString *)string; // Gunning Fog Index
+ (NSDecimalNumber *)smogIndexForString:(NSString *)string; // SMOG

@end
