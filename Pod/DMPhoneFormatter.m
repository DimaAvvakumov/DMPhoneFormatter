//
//  DMPhoneFormatter.m
//  polyphone
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 East Media Ltd. All rights reserved.
//

#import "DMPhoneFormatter.h"

@interface DMPhoneFormatter()

@property (strong, nonatomic) NSString *defaultRegion;
@property (strong, nonatomic) NSDictionary *presets;

@end

@implementation DMPhoneFormatter

+ (id)defaultFormatter {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init{
    self = [super init];
    if (self == nil) return nil;
    
    self.defaultRegion = @"ru";
    self.presets = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DMPhoneFormatterPresets" ofType:@"plist"]];
    
    return self;
}

- (void)setRegion:(NSString*)region {
    self.defaultRegion = region;
}

- (NSString *)formatNumber:(NSString *)phoneNumber {
    NSString *originalString = [self removeGarbageChars:phoneNumber];
    
    // original length
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return phoneNumber;

    NSArray *allPresets = [self.presets objectForKey:@"all"];
    for (NSString *preset in allPresets) {
        NSString *formattedString = [self applyPreset:preset forString:originalString];
        
        if (formattedString) {
            return formattedString;
        }
    }
    
    NSArray *regionPresets = [self.presets objectForKey:self.defaultRegion];
    if (regionPresets == nil) return originalString;
    
    for (NSString *preset in regionPresets) {
        NSString *formattedString = [self applyPreset:preset forString:originalString];
        
        if (formattedString) {
            return formattedString;
        }
    }
    
    return originalString;
}

- (NSString *)applyPreset:(NSString *)preset forString:(NSString *)originalString {
    
    NSInteger presetLength = [preset length];
    NSInteger countDigit = 0;
    NSMutableArray *offsetOfDigit = [NSMutableArray arrayWithCapacity:presetLength];
    NSMutableString *pattern = [NSMutableString stringWithCapacity:presetLength * 10];
    
    [pattern appendString:@"^"];
    for (int i = 0; i < presetLength; i++) {
        unichar c = [preset characterAtIndex:i];
        
        if ([DMPhoneFormatter isDigitChar:c]) {
            [offsetOfDigit addObject:@(i)];
            
            if (c == '#') {
                [pattern appendString:@"([0-9]{1})"];
            } else {
                NSString *add = [NSString stringWithFormat:@"([%@]{1})", [NSString stringWithCharacters:&c length:1]];
                
                [pattern appendString:add];
            }
            
            countDigit++;
        }
    }
    [pattern appendString:@"$"];
    
    NSError *error = nil;
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"RegExp error: %@", error);
        
        return nil;
    }
    
    NSTextCheckingResult *result = [regExp firstMatchInString:originalString options:0 range:NSMakeRange(0, originalString.length)];
    if (result == nil) return nil;
    
    NSString *formattedString = preset;
    for (int i = 0; i < countDigit; i++) {
        NSNumber *offset = [offsetOfDigit objectAtIndex:i];
        NSRange range = NSMakeRange([offset integerValue], 1);
        NSRange rangeFromOriginal = [result rangeAtIndex:(i+1)];
        NSString *digit = [originalString substringWithRange:rangeFromOriginal];
        
        formattedString = [formattedString stringByReplacingCharactersInRange:range withString:digit];
    }
    
    return formattedString;
}

+ (BOOL) isDigitChar:(unichar)c {
    if (c >= '0' && c <= '9') {
        return YES;
    } else if (c == '+') {
        return YES;
    } else if (c == '*' || c == '#') {
        return YES;
    } else if (c == ',' || c == ';') {
        return YES;
    }
    
    return NO;
}

- (NSString *) removeGarbageChars: (NSString *)originalString {
    NSUInteger originalStringLength = [originalString length];
    
    // check length
    if (originalStringLength == 0) return originalString;
    
    NSMutableString *cleanString = [NSMutableString stringWithCapacity:originalStringLength];
    
    for (NSInteger i = 0; i < originalStringLength; i++) {
        unichar c = [originalString characterAtIndex:i];
        
        BOOL insert = [DMPhoneFormatter isDigitChar:c];
        
        if (insert) {
            [cleanString appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    
    return cleanString;
}

@end
