//
//  ViewController.m
//  Readability-Objective-C Example
//
//  Created by Bracken Spencer <bracken.spencer@gmail.com>.
//  Copyright (c) 2014-2015 Bracken Spencer. All rights reserved.
//

#import "ViewController.h"
#import "Readability.h"

@interface ViewController () <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UILabel *fleschReadingEaseLabel;
@property (nonatomic, weak) IBOutlet UILabel *fleschKincaidGradeLevelLabel;
@property (nonatomic, weak) IBOutlet UILabel *gunningFogScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel *smogIndexLabel;
@property (nonatomic, weak) IBOutlet UILabel *automatedReadabilityIndexLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textViewDidChange:self.textView];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length) {
        NSDecimalNumber *automatedReadabilityIndex = [Readability automatedReadabilityIndexForString:self.textView.text];
        NSDecimalNumber *fleschKincaidGradeLevel = [Readability fleschKincaidGradeLevelForString:self.textView.text];
        NSDecimalNumber *fleschReadingEase = [Readability fleschReadingEaseForString:self.textView.text];
        NSDecimalNumber *gunningFogScore = [Readability gunningFogScoreForString:self.textView.text];
        NSDecimalNumber *smogIndex = [Readability smogIndexForString:self.textView.text];
        
        [self.automatedReadabilityIndexLabel setText:[NSString stringWithFormat:@"%@", automatedReadabilityIndex]];
        [self.fleschKincaidGradeLevelLabel setText:[NSString stringWithFormat:@"%@", fleschKincaidGradeLevel]];
        [self.fleschReadingEaseLabel setText:[NSString stringWithFormat:@"%@", fleschReadingEase]];
        [self.gunningFogScoreLabel setText:[NSString stringWithFormat:@"%@", gunningFogScore]];
        [self.smogIndexLabel setText:[NSString stringWithFormat:@"%@", smogIndex]];
    } else {
        [self.automatedReadabilityIndexLabel setText:@"N/A"];
        [self.fleschKincaidGradeLevelLabel setText:@"N/A"];
        [self.fleschReadingEaseLabel setText:@"N/A"];
        [self.gunningFogScoreLabel setText:@"N/A"];
        [self.smogIndexLabel setText:@"N/A"];
    }
}

@end

