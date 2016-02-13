---
category: messaging
title: 'Groups'
---



###Get Existing Group

```objc
//ObjectiveC
Bit6Conversation *conv = ...
Bit6Group *group = [Bit6Group groupWithConversation:conv];
```
```swift
//Swift
var conv = ...
var group = Bit6Group(conversation:conv)
```

###Create a Group

```objc
//ObjectiveC
[Bit6Group createGroupWithMetadata:@{@"key1":@"value1", ...} 
					 completion:^(Bit6Group *group, NSError *error) {
			            if (!error) {
			                //group created
			            }
}];
```
```objc
//Swift
Bit6Group.createGroupWithMetadata(["key1":"value1", ...]){ (group, error) in
    if error == nil {
        //group created
    }
}
```

A `Bit6ConversationsChangedNotification` and a `Bit6GroupsChangedNotification` with change key `Bit6AddedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

__Note.__ If you want to set the title for a group the use of Bit6GroupMetadataTitleKey is recomended, as in:

```objc
//ObjectiveC
[Bit6Group createGroupWithMetadata:@{Bit6GroupMetadataTitleKey:@"some title", ...} 
					 completion:^(Bit6Group *group, NSError *error) {
			            if (!error) {
			                //group created
			            }
}];
```

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
group.leaveGroupWithCompletion(){ (error) in
    if error == nil {
        //you have left the group
    }
}
```

A `Bit6GroupsChangedNotification` with change key `Bit6ObjectDeleted` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Change Group Metadata

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
[group setMetadata:@{@"key1":@"value1", ...}
			completion:^(NSError *error) {
				if (!error) {
					//metadata has changed
				}
}];
```
```objc
//Swift
group.setMetadata(["key1":"value1", ...]){ (error) in
	if error == nil {
	  //metadata has changed
	}
}
```

A `Bit6GroupsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

__Note.__ If you want to set the title for a group the use of Bit6GroupMetadataTitleKey is recomended

###Invite members to a Group

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
Bit6Address *friendToInvite = ...
NSString *role = Bit6GroupMemberRole_User;

[group inviteGroupMemberWithAddress:friendToInvite role:role
			completion:^(NSArray *members, NSError *error) {
				if (!error) {
					//friend have been invited
					//members is the updated list of group members
				}
}];
```
```objc
//Swift
let friendToInvite : Bit6Address = ...
let role = Bit6GroupMemberRole_User

group.inviteGroupMemberWithAddress(friendToInvite, role:role){ (members, error) in
	if error == nil {
		//friend have been invited
		//members is the updated list of group members
	}
}
```

A `Bit6GroupsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).

###Remove members from a Group

#####Note. only available if group.isAdmin returns YES;

```objc
//ObjectiveC
Bit6GroupMember *friendToRemove = group.members[0];

[group kickGroupMember:friendToRemove 
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

group.kickGroupMember(friendToRemove){ (members, error) in
	if error == nil {
		//friend has been removed
		//members is the updated list of group members
	}
}
```

A `Bit6GroupsChangedNotification` with change key `Bit6UpdatedKey` will be sent. See "Listen to Changes" in [Conversations](#messaging-conversations).