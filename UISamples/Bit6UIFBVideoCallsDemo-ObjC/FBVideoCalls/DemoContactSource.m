//
//  Bit6DemoContactSource.m
//  Bit6
//
//  Created by Carlos Thurber on 04/12/16.
//  Copyright © 2016 Bit6. All rights reserved.
//

#import "DemoContactSource.h"

@implementation DemoContactSource

- (id<BXUContact>)contactForURI:(NSString *)uri
{
    return self.dataSource[uri];
}

@end

@implementation DemoContact

- (nonnull instancetype)initWithURI:(nonnull NSString*)uri name:(nonnull NSString*)name avatarURLString:(nullable NSString*)avatarURLString
{
    self = [super init];
    if (self) {
        self.uri = uri;
        self.name = name;
        self.avatarURL = [NSURL URLWithString:avatarURLString];
    }
    return self;
}

@end
