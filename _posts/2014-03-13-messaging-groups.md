---
category: messaging
title: 'Groups'
---



###Get Existing Group

```objc
//ObjectiveC
Bit6Conversation *conversation = ...
Bit6Group *group = [Bit6Group groupForConversation:conversation];
```
```swift
//Swift
var conversation = ...
var group = Bit6Group.groupForConversation(conversation)
```

###Create a Group

```objc
//ObjectiveC
[Bit6Group createGroupWithTitle:@"MyGroup" 
					 completion:^(Bit6Group *group, NSError *error) {
			            if (!error) {
			                //group created
			            }
}];
```
```objc
//Swift
Bit6Group.createGroupWithTitle:("MyGroup", 
					completion:{(group, error) -> Void in
					    if (error != nil) {
					        //group created
					    }
});
```

A `Bit6ConversationsChangedNotification` with change key `Bit6AddedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Leave a Group

```objc
//ObjectiveC
[group leaveGroupWithCompletion:^(NSError *error) {
	if (!error) {
		//you have left the group
	}
}];
```
```swift
//Swift
group.leaveGroupWithCompletion({(error) -> Void in
    if (error != nil) {
        //you have left the group
    }
})
```

A `Bit6ConversationsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Change Group Title

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
[group setTitle:@"New Title"
			completion:^(NSError *error) {
				if (!error) {
					//title has changed
				}
}];
```
```objc
//Swift
group.setTitle("New Title", completion:{(error) -> Void in
      if (error != nil) {
          //title has changed
      }
})
```

A `Bit6ConversationsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Invite members to a Group

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
Bit6Address *friendToInvite = ...
NSArray *friendsToInvite = @[friendToInvite];

[group inviteAddresses:friendsToInvite 
			completion:^(NSArray *members, NSError *error) {
				if (!error) {
					//friend has been invited
					//members is the updated list of group members
				}
}];
```
```objc
//Swift
var friendToInvite : Bit6Address = ...
let friendsToInvite = [friendToInvite]

group.inviteAddresses(friendsToInvite, completion:{(members, error) -> Void in
      if (error != nil) {
          //friend has been invited
		  //members is the updated list of group members
      }
})
```

A `Bit6ConversationsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Remove members from a Group

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
Bit6GroupMember *friendToRemove = group.members[0];

[group deleteMember:friendToRemove 
			completion:^(NSArray *members, NSError *error) {
				if (!error) {
					//friend has been removed 
					//members is the updated list of group members
				}
}];
```
```objc
//Swift
let friendToRemove = group.members[0]

group.deleteMember(friendToRemove, completion:{(members, error) -> Void in
      if (error != nil) {
          //friend has been removed
		  //members is the updated list of group members
      }
})
```

A `Bit6ConversationsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).