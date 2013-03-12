//
//  NUEndpoint.m
//  
//
//  Created by Jacob Van Order on 2/14/13.
//
//

#import "NUEndpoint.h"
#import "NUEndpointEnvironment.h"

@implementation NUEndpoint

#pragma mark delegate methods

#pragma mark customization

-(UIImage *)endpointImage {
    if (_endpointImage) {
        return _endpointImage;
    }
    else {
        NSURLRequest *imageRequest = [NSURLRequest requestWithURL:self.imageURL];
        NUEndpoint __weak *weakSelf = self;
        if (imageRequest) {
            [NSURLConnection sendAsynchronousRequest:imageRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                weakSelf.endpointImage = (image != nil) ? image : [UIImage imageNamed:@"NoImageAvailable"];
                NSDictionary *userInfo = (weakSelf.name) ? @{@"name" : weakSelf.name} : @{};
                [[NSNotificationCenter defaultCenter] postNotificationName:ENDPOINT_IMAGE_DOWNLOADED object:weakSelf userInfo:userInfo];
            }];
        }
        return nil;
    }
}

#pragma mark prototyping

-(NUEndpointEnvironment *)enviromentBasedOnPlistFromArray:(NSArray *)enviromentArray {
    
    NSDictionary *environmentDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NCSNavField-environment" ofType:@"plist"]];
    NSString __block *chosenEnvironmentName = environmentDictionary[@"environment"];
    NSArray *filteredEnvironmentArray = [enviromentArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NUEndpointEnvironment *environment, NSDictionary *bindings) {
        return [environment.name isEqualToString:chosenEnvironmentName];
    }]];
    NUEndpointEnvironment *chosenEnvironment = [filteredEnvironmentArray lastObject];
    return chosenEnvironment;
}

#pragma mark stock code

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        _environmentArray = [aDecoder decodeObjectForKey:@"environmentArray"];
        _enviroment = [self enviromentBasedOnPlistFromArray:_environmentArray];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.environmentArray forKey:@"environmentArray"];
}

-(instancetype)initWithDataDictionary:(NSDictionary *)dataDictionary {
    self = [super init];
    if (self) {
        _name = dataDictionary[@"name"];
        _imageURL = [NSURL URLWithString:dataDictionary[@"logo_url"]];
        _environmentArray = @[];
        for (NSDictionary *environmentDictionary in dataDictionary[@"environments"]) {
            NUEndpointEnvironment *environment = [[NUEndpointEnvironment alloc] initWithEnviromentDictionary:environmentDictionary];
            _environmentArray = [_environmentArray arrayByAddingObject:environment];
        }
        _enviroment = [self enviromentBasedOnPlistFromArray:_environmentArray];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ has the imageURL: %@\ncoreURL: %@\ncasServerURL: %@\npgtReceiveURL: %@\n pgtRetriveURL: %@", self.name, self.imageURL, self.enviroment.coreURL, self.enviroment.casServerURL, self.enviroment.pgtReceiveURL, self.enviroment.pgtRetrieveURL];
}



@end
