# Reference CNI plugins distribution

This is an additional `./images/` directory which has Dockerfiles for building the reference CNI plugins (e.g. from [containernetworking/plugins](https://github.com/containernetworking/plugins)).

Generally this is for building two images for distribution of the reference CNI plugins, unsupported & supported. 

The source of this README and the contents it describes is in the [nfvpe/plugins repo in the image-builder branch](https://github.com/redhat-nfvpe/plugins/tree/image-builder).

The workflow outlined here is intended to later be automated, it's currently manual for the sake of expediency in the short term.

## Workflow overview

* Sync this master (and any target branch) with the upstream fork
* Merge or cherry pick the single commit from the `image-builder` branch in the NFVPE repo
* Run the `./builder.sh`
* Commit and push to the downstream @ [openshift/ose-container-networking-plugins](https://github.com/openshift/ose-containernetworking-plugins).

## Inspecting the contents

Here we have two dockerfiles in two directories:

* `./supported/Dockerfile`: Builds image with OSE supported binaries
* `./unsupported/Dockerfile`: Builds image with unsupported OSE binaries

We also have here two files: 

* `./builder.sh`: a script to copy in the contents of the root directory into each of the `./images/supported|unsupported` directories (because the downstream build system needs all of the contents local to each images directory)
* `./README.md`: You're reading it now.

## Example manual run

Determine the branch you'd like to have as your release...

```
git branch -av
```

Or chose a tag...

```
git tag
```

Then checkout that tag as the release branch:

```
git checkout -b release v0.7.4
```

Merge in the `image-builder` branch:

```
git merge image-builder
```

Run the builder script (from the root of your clone)

```
./images/builder.sh
```

Commit it:

```
git add .; git commit -m "[downstream] Builder modified v0.7.4 tag"
```

Then push it downstream:

```
git push downstream release
```

And remember, if you fail, you can clean up with:

```
git clean -fd
```



And remember you can clean up with...

```
git clean -fd
```
