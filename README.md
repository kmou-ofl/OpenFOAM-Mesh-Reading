# OpenFOAM-Mesh-Reading

## prepare OpenFOAM debugging

### download source
```bash
cd $HOME
git clone git@github.com:kmou-ofl/OpenFOAM-Mesh-Reading.git
cd OpenFOAM-Mesh-Reading
```

### edit Dockerfile
```bash
vi Dockerfile
```
>```Dockerfile
>ARG dockerusername=yourusername
>ARG dockeruserid=youruserid
>```

### build image
```bash
docker build -t openfoam8-debug .
```

### run docker container
```bash
docker run -it --rm --name readMesh -u $(id -u) -w /home/jwy/OpenFOAM/jwy-8/run/tutorial openfoam8-debug bash
```

### run blockMesh (in docker container)
```bash
blockMesh
```
## debugging OpenFOAM

### run gdb (in docker container)
```bash
gdb laplacianFoam
```

### listing source (in gdb)

```gdb
l laplacianFoam.C:43
```

### set breakpoint (in gdb)

```gdb
b createMesh.H:1
run
    ...
b polyMesh.C:163
```