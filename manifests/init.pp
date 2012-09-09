# == Class: emacs
#
# Build and install emacs from source.
#
# === Parameters
#
# [*emacs_src_dir*]
#   The location to unpack the tarball.
#   Default: /opt/emacs-src
#
# === Examples
#
#   include emacs
#
# === Authors
#
# Thomas Van Doren
#
# === Copyright
#
# Copyright 2012 Thomas Van Doren, unless otherwise noted
#
class emacs (
  $emacs_src_dir = '/opt/emacs-src',
  ) {
  $packages = ['build-essential', 'make',]
  package { $packages:
    ensure => present,
  }
  group { 'local-build':
    ensure => present,
  }
  user { 'local-build':
    ensure  => present,
    gid     => 'local-build',
    require => Group['local-build'],
  }
  File {
    ensure => present,
    owner  => 'local-build',
    group  => 'local-build',
  }
  file { $emacs_src_dir:
    ensure => directory,
  }
  file { 'emacs.tar.gz':
    path   => "${emacs_src_dir}/emacs.tar.gz",
    source => 'puppet:///modules/emacs/emacs-24.2.tar.gz',
  }
  Exec {
    cwd   => $emacs_src_dir,
    user  => 'local-build',
    group => 'local-build',
  }
  exec { 'build-dep-emacs':
    command => '/usr/bin/apt-get --yes -o Dpkg::Options="--confold" build-dep emacs23',
    user    => 'local-build',
    group   => 'local-build',
    creates => '/usr/bin/quilt',
  }
  exec { 'unpack-emacs':
    command => '/bin/tar --strip-components 1 --extract --gzip --file emacs.tar.gz',
    creates => "${emacs_src_dir}/configure",
    require => [ File['emacs.tar.gz'], Exec['build-dep-emacs'], ],
  }
  exec { 'configure-emacs':
    command => '/bin/sh ./configure',
    creates => "${emacs_src_dir}/Makefile",
    require => Exec['unpack-emacs'],
  }
  exec { 'make-emacs':
    command => '/usr/bin/make',
    creates => "${emacs_src_dir}/src/emacs",
    require => Exec['configure-emacs'],
  }
  exec { 'install-emacs':
    command => '/usr/bin/make install',
    user    => 'root',
    group   => 'root',
    creates => '/usr/local/bin/emacs',
    require => Exec['make-emacs'],
  }
}
