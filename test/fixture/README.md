# README

[Home](http://rubyworks.github.com/readme) /
[Work](http://github.com/rubyworks/readme) /
[Mail](http://groups.google.com/groups/rubyworks-mailinglist)


## Description

Ever thought perhaps that all the effect in creating a good README, while
great for your end-userss, did't every do you a hill of beans worth of good
when it came to constructing your project's metadata. Well, hang on to your
nerd glasses! Here comes a gem that does just that!


## Instruction

The library is about as easy to use as you can imagine.

    require 'readme'

    readme = Readme.file

    readme.name
    readme.description
    readme.copyright

It also come with a command line client to pump out the data into variant
formats, such a YAML, JSON and even Ruby code.


## Copyright

Copyright (c) 2009 Rubyworks. All rights reserved.

Readme can be reistributed in accordance with the **BSD-2-Clause** license.

See COPYING.md file for details.

