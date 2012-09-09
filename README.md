puppet-emacs
============
[![Build Status](https://secure.travis-ci.org/thomasvandoren/puppet-emacs.png)](http://travis-ci.org/thomasvandoren/puppet-emacs)

Description
-----------
A puppet module to install emacs from source. I installed emacs 24
from source twice, and it is kind of a pain, so I did this.

Requirements
------------

This has only been tested on Ubuntu 12.04 Precise. It won't work as
currently implemented on non-Debian systems.

Installation and Usage
----------------------

For a standard puppet setup, with a master and automated puppet
runs, include the module.

```puppet
node default {
  include emacs
}
```

For a host that is not managed by puppet, install puppet agent and
manually apply the smoke test.

```bash
apt-get install puppet
cd /etc/puppet/modules/emacs/tests
puppet apply --verbose init.pp
```

Author
------
Thomas Van Doren

License
-------
GPLv2
