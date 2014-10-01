---
category: calling
title: 'Voice Calls'
layout: nil
---

### Make an Audio Call

```objc
Bit6Address *otherUserAddress = ...
[Bit6 startCallToAddress:otherUserAddress hasVideo:NO];
```
In the current beta version we show very basic in-call UI. The future versions will allow UI customization.
