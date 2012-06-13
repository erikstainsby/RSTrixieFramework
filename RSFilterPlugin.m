//
//  RSConditionPlugin.m
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSFilterPlugin.h"

@interface RSFilterPlugin ()

@end

@implementation RSFilterPlugin

@synthesize pluginName;
@synthesize selectorField;
@synthesize valueOfField;
@synthesize predicate;

- (NSString *) expression {
	return [NSString stringWithFormat:@"The method [callback] requires an override in the %@ instance of subclass %@",[self pluginName],[self className]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void) resetForm {
		//	[[self selectorField]  setStringValue:@""];  // vestigial - no selector field in use for Condition rules
	[[self valueOfField] setStringValue:@""];
	[self setPredicate:@""];
}


@end
