# MsxHub packages

# How to build a package

Example command:

```
docker run -u $(id -u) -it --rm -v $(pwd):/usr/src fr3nd/msxhub-packages build packages/VI.yaml out
```

package will be stored in the out directory
