%hook UIViewController
- (void)presentViewController:(UIAlertController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	if(![viewControllerToPresent isKindOfClass:[UIAlertController class]]){
		%orig;
	}
	else{
		BOOL canShow = YES;
		NSArray *array = [[viewControllerToPresent title] componentsSeparatedByString:@" "];
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}
		array = [[viewControllerToPresent message] componentsSeparatedByString:@" "];
		for(NSString* string in array)
		{
			if([[string lowercaseString] isEqualToString:@"rate"])
				canShow = NO;
		}

		if(canShow){
			%orig;
		}
		else{
			NSArray *actions = [viewControllerToPresent actions];
			long actionslen = (long)[actions count];
			NSLog(@"actions length: %lu", actionslen);
			for(UIAlertAction* action in actions)
			{
				if([action style] == UIAlertActionStyleCancel){//dismiss etc
					NSLog(@"cancel found");
					action.handler(action);//added handler property to UIAlerAction.h, though handler is called app does not continue:(
					// @property (nonatomic, copy) void (^handler) (UIAlerAction *action);
					break;
				}
			}
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
