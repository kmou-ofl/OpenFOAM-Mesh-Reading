# OpenFOAM-Mesh-Reading

## Prepare for debugging OpenFOAM

### build docker image
```bash
cd $HOME
git clone git@github.com:kmou-ofl/OpenFOAM-Mesh-Reading.git
cd OpenFOAM-Mesh-Reading
docker build -t openfoam8-debug .
```

### run docker container
```bash
docker run -it --rm --name readMesh -u $(id -u) -w /home/jwy/OpenFOAM/jwy-8/run/tutorial openfoam8-debug bash
```

### run blockMesh
```bash
blockMesh
```

### run gdb
```bash
gdb laplacianFoam
```