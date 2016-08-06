%hook UIViewController
- (void)presentViewController:(UIAlertController *)arg1 animated:(BOOL)arg2 completion:(void (^)(void))arg3
{
	BOOL canShow = YES;

	if(![arg1 isKindOfClass:[UIAlertController class]]){
		%orig;
	}
	else{
		NSArray *array = [[arg1 title] componentsSeparatedByString:@" "];
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}
		array = [[arg1 message] componentsSeparatedByString:@" "];
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}

		if(canShow){
			%orig;
		}
		else{
			// NSArray *actions = [arg1 actions];
			// long actionslen = (long)[actions count];
			// NSLog(@"actions length: %lu", actionslen);
			// for(UIAlertAction* action in actions)
			// {
			// 	if([[[action title] lowercaseString] isEqualToString:@"cancel"]){
			// 		NSLog(@"cancel found");
			// 	} //no access to action's handler
			// }
		}
	}
}
%end

%ctor
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	if([NSHomeDirectory() hasPrefix:@"/var/mobile/Containers/Data/Application/"])	// only hook App Store applications
	{
		%init;
	}
	[pool drain];
}
