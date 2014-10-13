//
//  Readability_iOS_ExampleTests.m
//  Readability-iOS ExampleTests
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014 Bracken Spencer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Readability_iOS.h"
#import "SyllableCounter.h"

@interface Readability_iOS (Test)

+ (NSDecimalNumber *)roundFloat:(CGFloat)aFloat places:(NSInteger)places;
+ (NSUInteger)count:(NSStringEnumerationOptions)open inString:(NSString *)string;
+ (NSUInteger)countAlphanumericCharactersInString:(NSString *)string;
+ (BOOL)isWordPolysyllable:(NSString *)word excludeCommonSuffixes:(BOOL)excludeCommonSuffixes;
+ (NSUInteger)countPolysyllablesInString:(NSString *)string excludeCommonSuffixes:(BOOL)excludeCommonSuffixes;
+ (BOOL)isWordCapitalized:(NSString *)word;
+ (NSUInteger)countComplexWordsInString:(NSString *)string;

@end

@interface Readability_iOS_ExampleTests : XCTestCase

@property (nonatomic, strong) NSString *testString1;
@property (nonatomic, strong) NSString *testString2;

@end

@implementation Readability_iOS_ExampleTests

- (void)setUp {
    [super setUp];
    
    // https://en.wikipedia.org/wiki/Flesch–Kincaid_readability_tests
    //                        Text: The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.
    //         Flesch Reading Ease: 24.1
    //  Flesch–Kincaid Grade Level: 13.1
    // Automated Readability Index: 9.7
    //                  SMOG Index: 11.6
    //           Gunning Fog Score: 14.4
    // Checked with http://read-able.com
    self.testString1 = @"The Australian platypus is seemingly a hybrid of a mammal and reptilian creature.";
    
    self.testString2 = @"Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battlefield of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate, we can not consecrate, we can not hallow this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us—that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion—that we here highly resolve that these dead shall not have died in vain—that this nation, under God, shall have a new birth of freedom—and that government of the people, by the people, for the people, shall not perish from the earth.";
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Readability_iOS

- (void)testReadability {
    XCTAssert([Readability_iOS automatedReadabilityIndexForString:self.testString1].doubleValue == 9.7);
    XCTAssert([Readability_iOS fleschKincaidGradeLevelForString:self.testString1].doubleValue == 13.1);
    XCTAssert([Readability_iOS fleschReadingEaseForString:self.testString1].doubleValue == 24.4);
    XCTAssert([Readability_iOS gunningFogScoreForString:self.testString1].doubleValue == 14.4);
    XCTAssert([Readability_iOS smogIndexForString:self.testString1].doubleValue == 11.6);
}

- (void)testReadabilityHelpers {
    XCTAssert([Readability_iOS roundFloat:9.7069229712853051 places:1].doubleValue == 9.7);
    XCTAssert([Readability_iOS roundFloat:13.079999923706055 places:1].doubleValue == 13.1);
    XCTAssert([Readability_iOS roundFloat:24.440014648437511 places:1].doubleValue == 24.4);
    XCTAssert([Readability_iOS roundFloat:14.430769445804451 places:1].doubleValue == 14.4);
    XCTAssert([Readability_iOS roundFloat:11.573498725891113 places:1].doubleValue == 11.6);
    
    XCTAssertEqual([Readability_iOS count:NSStringEnumerationByWords inString:self.testString1], 13);
    XCTAssertEqual([Readability_iOS count:NSStringEnumerationByWords inString:self.testString2], 271);
    
    XCTAssertEqual([Readability_iOS count:NSStringEnumerationBySentences inString:self.testString1], 1);
    XCTAssertEqual([Readability_iOS count:NSStringEnumerationBySentences inString:self.testString2], 10);
    
    XCTAssertEqual([Readability_iOS countAlphanumericCharactersInString:self.testString1], 68);
    
    XCTAssert([Readability_iOS isWordPolysyllable:@"crowdsourcing" excludeCommonSuffixes:NO] == YES);
    XCTAssert([Readability_iOS isWordPolysyllable:@"crowdsourcing" excludeCommonSuffixes:YES] == NO);
    
    XCTAssertEqual([Readability_iOS countPolysyllablesInString:self.testString1 excludeCommonSuffixes:NO], 4);
    XCTAssertEqual([Readability_iOS countPolysyllablesInString:self.testString1 excludeCommonSuffixes:YES], 4);
    
    XCTAssert([Readability_iOS isWordCapitalized:@"Test"] == YES);
    XCTAssert([Readability_iOS isWordCapitalized:@"test"] == NO);
    
    XCTAssertEqual([Readability_iOS countComplexWordsInString:self.testString1], 3);
}

#pragma mark - SyllableCounter

- (void)testSyllableCounter {
    XCTAssertEqual([SyllableCounter syllableCountForWords:self.testString1], 26);
}

@end
