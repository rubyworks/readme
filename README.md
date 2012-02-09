# README

[Website](http://rubyworks.github.com/readme) /
[Development](http://github.com/rubyworks/readme) /
[Issue Tracker](http://github.com/rubyworks/readme/issues) /
[Mailing List](http://groups.google.com/groups/rubyworks-mailinglist)

[![Build Status](https://secure.travis-ci.org/rubyworks/readme.png)](http://travis-ci.org/rubyworks/readme)


## Description

Ever thought perhaps that all the effect in creating a good README, while
great for your end-userss, did't every do you a hill of beans worth of good
when it came to constructing your project's metadata. Well, hang on to your
nerd glasses! Here comes a gem that does just that!

Okay, don't get too excited just yet. Readme's heuristics are rather limited
thus far, but with time and contribution she'll be right fine in the not
to distant future.


## Instruction

The library is about as easy to use as you can imagine.

    require 'readme'

    readme = Readme.file

    readme.name
    readme.description
    readme.copyright

It also come with a command line client to pump out the data into variant
formats, such a YAML, JSON and even Ruby code.

    $ readme --yaml

    $ readme description

See the [API documentation](http:/rubydoc.info/gems/readme) and `readme --help` for more information.


## Copyright

Copyright (c) 2009 Rubyworks. All rights reserved.

Readme can be reistributed in accordance with the **BSD-2-Clause** license.

See COPYING.md file for details.

