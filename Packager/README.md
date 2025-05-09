# Packager

This will package up an application into a deb or RPM package for use with a
package manager on a Debian or RedHat based Linux operating system.


## Usage

For ease all operations are triggered via a `Makefile`.

All operations for packaging are run inside a container to avoid the need to
have to install extra tooling on your computer.


### Building the container

To build the image run the following on your system:

```shell
make container
```

This may take a few moments to complete.

Should you build any additional tools in to the container remember to rebuild
the container so that they are available to you.


### Building a package


The Builder is designed to build multiple application packages and needs to be
told which to build and what version.

This relies on a good tagging and release strategy within the SCM.

The following variables are required:

`APP` - the name of the application to build 
`VERSION` - The desired version of the application to build


```shell
make APP=demoapp-frontend VERSION="1.1" package
```


## TODO

The following bits of extra work need to be completed:

* Generating either deb or RPM packages rather than both at the same time to
  avoid wasting cycles
* The logic for where to get the application code needs to be added
  i.e. github.com/repo/?version=xx
* Additional steps need to be taken to prepare the application so its ready to
  be used after installation
* Dependencies need to be defined so that installing the application package
  will also install any supporting packages

Additional logic and preparation should be performed inside separate containers
to keep container sizes down.


There are some things to be aware of:

* Due to the format of the changelog being different to what the RPM builder
  tool expects the change log is not included in the RPM package.
* The repository building tools are included within the image but are not yet
  used to create a repo. This causes a slightly over sized container for its
  current level of functionality

