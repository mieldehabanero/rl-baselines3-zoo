ARG PARENT_IMAGE
ARG USE_GPU
FROM $PARENT_IMAGE
ARG PYTORCH_DEPS=cpuonly
ARG PYTHON_VERSION=3.9
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --fix-missing --no-install-recommends \
        build-essential \
        cmake \
        git \
        curl \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        libglib2.0-0 \
        ffmpeg \
        freeglut3-dev \
        swig \
        xvfb \
        libxrandr2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Anaconda and dependencies
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh

RUN /opt/conda/bin/conda install -y python=$PYTHON_VERSION numpy pyyaml scipy ipython mkl mkl-include

RUN /opt/conda/bin/conda install -y pytorch $PYTORCH_DEPS -c pytorch -c nvidia && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

ENV CODE_DIR /root/code
ENV VENV /root/venv
COPY requirements.txt /tmp/

RUN mkdir -p ${CODE_DIR}/rl_zoo && \
    pip install -r /tmp/requirements.txt && \
    pip uninstall -y opencv-python && \
    pip install \
        opencv-python-headless \
        "highway-env==1.5.0" && \
    pip install --upgrade requests && \
    rm -rf $HOME/.cache/pip

ENV PATH=$VENV/bin:$PATH

COPY docker/entrypoint.sh /tmp/
RUN chmod +x /tmp/entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]

CMD /bin/bash
