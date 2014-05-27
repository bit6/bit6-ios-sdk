---
category: calling
title: 'Video Calls'
layout: nil
---

### Make a Video Call

```objc
Bit6Address *otherUserAddress = ...
[Bit6 startCallToAddress:otherUserAddress hasVideo:YES];
```
In the current beta version we show very basic in-call UI. The future versions will allow UI customization.