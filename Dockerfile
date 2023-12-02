ARG PYTORCH="1.9.0"
ARG CUDA="11.1"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

ENV TORCH_CUDA_ARCH_LIST="6.0 6.1 7.0 7.5 8.0 8.6+PTX" \
    TORCH_NVCC_FLAGS="-Xfatbin -compress-all" \
    CMAKE_PREFIX_PATH="$(dirname $(which conda))/../" \
    FORCE_CUDA="1"

# Avoid Public GPG key error
# https://github.com/NVIDIA/nvidia-docker/issues/1631
RUN rm /etc/apt/sources.list.d/cuda.list \
    && rm /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-key del 7fa2af80 \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# (Optional, use Mirror to speed up downloads)
# RUN sed -i 's/http:\/\/archive.ubuntu.com\/ubuntu\//http:\/\/mirrors.aliyun.com\/ubuntu\//g' /etc/apt/sources.list && \
#    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Install the required packages
RUN apt-get update \
    && apt-get install -y ffmpeg libsm6 libxext6 git ninja-build libglib2.0-0 libsm6 libxrender-dev libxext6 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install einops
# RUN pip install waymo-open-dataset-tf-2-6-0
RUN pip install setuptools==59.5.0
RUN pip install flash-attn==0.2.2

# Install MMEngine, MMCV and MMDetection
# RUN pip install openmim && \
#     mim install "mmengine" "mmcv>=2.0.0rc4" "mmdet>=3.0.0"  -i http://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com


RUN pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu111/torch1.9.0/index.html
RUN pip install mmdet==2.28.2
RUN pip install mmsegmentation==0.30.0

# Install MMDetection3D
# 
RUN mkdir -p /home/ubuntu/bev/StreamPETR

COPY mmdetection3d /home/ubuntu/bev/StreamPETR/mmdetection3d 
RUN cd /home/ubuntu/bev/StreamPETR/mmdetection3d \
    && pip install --no-cache-dir -e .

RUN pip install yapf==0.40.1

# FROM mmdetection3d:v0.0.1

# WORKDIR /home/ubuntu/bev/StreamPETR

RUN mkdir -p /home/ubuntu/bev/StreamPETR/data
RUN mkdir -p /root/.cache/torch/hub/checkpoints/
COPY resnet50-0676ba61.pth /root/.cache/torch/hub/checkpoints/resnet50-0676ba61.pth
COPY nusc_tracking /home/ubuntu/bev/StreamPETR/nusc_tracking
COPY projects /home/ubuntu/bev/StreamPETR/projects
# COPY tools /home/ubuntu/bev/StreamPETR/tools
COPY README.md /home/ubuntu/bev/StreamPETR/README.md
COPY .git /home/ubuntu/bev/StreamPETR/.git
WORKDIR /home/ubuntu/bev/StreamPETR
RUN mkdir -p /home/ubuntu/bev/StreamPETR/work_dirs
RUN mkdir -p /home/ubuntu/bev/StreamPETR/test
RUN mkdir -p /home/ubuntu/bev/StreamPETR/result_vis
RUN mkdir -p /home/ubuntu/bev/StreamPETR/models
RUN mkdir -p /home/ubuntu/bev/StreamPETR/script




