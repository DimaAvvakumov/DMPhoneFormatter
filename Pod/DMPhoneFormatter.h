//
//  DMPhoneFormatter.h
//  polyphone
//
//  Created by Avvakumov Dmitry on 26.11.15.
//  Copyright © 2015 East Media Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPhoneFormatter : NSObject

+ (id)defaultFormatter;

- (void)setRegion:(NSString*)region;

- (NSString *)formatNumber:(NSString *)phoneNumber;

- (NSString *) removeGarbageChars: (NSString *)originalString;

+ (BOOL) isDigitChar:(unichar)c;

@end
