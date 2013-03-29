# Leadership Macon Nominations Form

This webapp is a Node.js/Express app I developed for [Leadership Macon](http://leadershipmacon.org) to
collect online nominations. I had previously done a much more sophisticated system in PHP that was
beginning to show its age, and they needed a quick turn-around on implementing a replacement that could
handle their online nominations.

This app is constructed with the Express framework, using Mongoose as a pipeline to the Mongo datastore.
Additionally, Twitter Bootstrap has been used to provide some simple look-n-feel elements. I'm no
designer, and they didn't particularly care about having it look fancy as long as it worked, so Bootstrap
was the natural choice.

This app additionally uses Amazon SES for email transport, and ReCAPTCHA to prevent spamming by bots. The
run.sh script gives you a general idea of how things are supposed to start up.

This code is released under the terms of the Apache 2 Licesne without any warranty of any kind, express or
implied. For more information on your rights under the license, please see the LICENSE file in the root of
this project.

## Who's behind this?

My name is Matt Farmer. I'm a Software Engineer based in Atlanta, GA. Although I occasionally dabble in
Node.js, Scala and Lift have become my latest passion. I've worked in a consultant capacity for several
years, worked to innovate in the social learning space with [OpenStudy](http://openstudy.com), and am
currently shipping code at [Elemica](http://elemica.com) and [Anchor Tab](http://anchortab.com).
You can follow my ramblings about technology, Atlanta, and life on [my Twitter](http://twitter.com/farmdawgnation)
and my [blog](http://farmdawgnation.com).
