# IntervalDispatcher

Simple dispatcher which will execute task only once per specified interval. Tasks can be added any time only the newest gets executed when the interval expires.

NOTE: Uses main queue so the timing is not perfect. If you need precise timing you should use different form of scheduling

I use it to limit number of touch events which are passed onto the network
