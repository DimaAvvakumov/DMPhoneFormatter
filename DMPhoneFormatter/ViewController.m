//
//  ViewController.m
//  DMPhoneFormatter
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 Dmitry Avvakumov. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(id)sender {
    
    UITextPosition *startPosition = [self.textField positionFromPosition:[self.textField beginningOfDocument] offset:3];
    UITextPosition *endPosition = [self.textField endOfDocument];
    UITextRange *textRange = [self.textField textRangeFromPosition:startPosition toPosition:startPosition];
    [self.textField setSelectedTextRange:textRange];
    
}

@end
