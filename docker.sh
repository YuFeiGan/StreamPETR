docker run -i --rm --gpus "all" --ipc=host  \
    -v /home/ubuntu/bev/StreamPETR/data:/home/ubuntu/bev/StreamPETR/data \
    -v /home/ubuntu/bev/StreamPETR/work_dirs:/home/ubuntu/bev/StreamPETR/work_dirs \
    -v /home/ubuntu/bev/StreamPETR/test:/home/ubuntu/bev/StreamPETR/test \
    -v /home/ubuntu/bev/StreamPETR/result_vis:/home/ubuntu/bev/StreamPETR/result_vis \
    -v /home/ubuntu/bev/StreamPETR/models:/home/ubuntu/bev/StreamPETR/models \
    -v /home/ubuntu/bev/StreamPETR/script:/home/ubuntu/bev/StreamPETR/script \
    -v /home/ubuntu/bev/StreamPETR/tools:/home/ubuntu/bev/StreamPETR/tools \
    streampetr:v0.0.1  \
    sh script/run.sh
    # python tools/visualize.py > res3 &
    # python tools/visualize.py > res3 &
    #  > res2 &
    # python tools/train.py projects/configs/StreamPETR/stream_petr_r50_flash_704_bs2_seq_24e.py --work-dir work_dirs/stream_petr_r50_flash_704_bs2_seq_24e/ > res &
    # 
    