FROM ubuntu:20.04
LABEL maintainer="jeon@g.kmou.ac.kr"

ARG dockerusername=jwy
ARG dockeruserid=930213

# 사용자 입력없이 패키지 설치를 진행함
ENV DEBIAN_FRONTEND noninteractive

# 속도가 빠른 국내 미러 서버 사용
RUN sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
RUN apt update 

# install openfoam requirements
# https://openfoam.org/download/source/software-for-compilation/
RUN apt install -y build-essential flex bison git-core cmake zlib1g-dev libboost-system-dev libboost-thread-dev libopenmpi-dev openmpi-bin gnuplot libreadline-dev libncurses-dev libxt-dev

# install GNU Debugger (gdb)
RUN apt install -y gdb

# install text editor
RUN apt install -y neovim

# user configuration
RUN useradd -m -u ${dockeruserid} ${dockerusername}
USER ${dockerusername}
RUN cp /etc/profile /home/${dockerusername}/.profile
RUN cp /etc/bash.bashrc /home/${dockerusername}/.bashrc

# build openfoam debug mode 
RUN mkdir -p /home/${dockerusername}/OpenFOAM
WORKDIR /home/${dockerusername}/OpenFOAM
RUN git clone https://github.com/OpenFOAM/OpenFOAM-8
RUN git clone https://github.com/OpenFOAM/ThirdParty-8
RUN sed -i -e "s/WM_COMPILE_OPTION=Opt/WM_COMPILE_OPTION=Debug/g" /home/${dockerusername}/OpenFOAM/OpenFOAM-8/etc/bashrc
RUN echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> /home/${dockerusername}/.bashrc
RUN echo "source /home/${dockerusername}/OpenFOAM/OpenFOAM-8/etc/bashrc" >> /home/${dockerusername}/.bashrc
RUN bash -c -i "/home/${dockerusername}/OpenFOAM/OpenFOAM-8/Allwmake -j"

# run tutorial
RUN bash -c -i "mkdir -p \$FOAM_RUN"
COPY --chown=${dockerusername}  tutorial /home/${dockerusername}/OpenFOAM/${dockerusername}-8/run/tutorial
WORKDIR /home/${dockerusername}/OpenFOAM/${dockerusername}-8/run/tutorial
RUN chmod +x ./Allrun
RUN bash -c -i "./Allrun"
CMD ["gdb", "laplaciamFoam"]