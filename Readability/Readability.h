//
//  Readability.h
//  Readability-Objective-C
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

// Automated Readability Index: automatedReadabilityIndexForString
//          Coleman–Liau Index: colemanLiauIndexForString
//  Flesch-Kincaid Grade Level: fleschKincaidGradeLevelForString
//         Flesch Reading Ease: fleschReadingEaseForString
//           Gunning Fog Index: gunningFogScoreForString
//                  SMOG Grade: smogGradeForString

@import Foundation;

@interface Readability : NSObject

+ (NSDecimalNumber *)automatedReadabilityIndexForString:(NSString *)string;
+ (NSDecimalNumber *)colemanLiauIndexForString:(NSString *)string;
+ (NSDecimalNumber *)fleschKincaidGradeLevelForString:(NSString *)string;
+ (NSDecimalNumber *)fleschReadingEaseForString:(NSString *)string;
+ (NSDecimalNumber *)gunningFogScoreForString:(NSString *)string;
+ (NSDecimalNumber *)smogGradeForString:(NSString *)string;

@end
