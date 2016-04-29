//
//  Bit6DemoContactSource.h
//  Bit6UI
//
//  Created by Carlos Thurber on 12/22/15.
//  Copyright © 2015 Bit6. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DemoContact : NSObject <BXUContact>

@property (nonnull, nonatomic, strong) NSString *uri;
@property (nonnull, nonatomic, strong) NSString *name;
@property (nullable, nonatomic, strong) NSURL *avatarURL;

- (nonnull instancetype)initWithURI:(nonnull NSString*)uri name:(nonnull NSString*)name avatarURLString:(nullable NSString*)avatarURLString;

@end

@interface DemoContactSource : NSObject <BXUContactSource>

@property (nonnull, strong, nonatomic) NSDictionary<NSString*,id<BXUContact>> *source;

@end
