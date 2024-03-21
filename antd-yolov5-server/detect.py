import argparse
import time
import cv2
import torch
from flask import Flask, Response
from numpy import random
import numpy as np

from models.experimental import attempt_load
from utils.general import check_img_size, check_requirements, check_imshow, non_max_suppression, apply_classifier, \
    scale_coords, xyxy2xywh, strip_optimizer, set_logging, increment_path
from utils.plots import plot_one_box
from utils.torch_utils import select_device, load_classifier, time_synchronized
from utils.datasets import letterbox


data_screen_url = "127.0.0.1"


def generate():
    weights, imgsz = opt.weights, opt.img_size
    set_logging()
    device = select_device(opt.device)

    half = device.type != 'cpu'  # 只有使用GPU时才可以使用半精度浮点数进行计算，所以不等于cpu时才为True
    # Load model
    model = attempt_load(weights, map_location=device)  # load FP32 model
    if half:
        model.half()  # to FP16

    video_cap = cv2.VideoCapture(0)

    while True:
        ret,frame = video_cap.read() # 用于摄像头或视频文件中，捕获帧信息; ret表示捕获成败(T/F),frame是捕获到的一帧，无则为空
        if ret is False:
            break
        processed_frame = detect_frame(frame,model,imgsz,device,half) # 送入处理函数 处理后发送给flask
        _, buffer = cv2.imencode('.jpg', processed_frame)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

    video_cap.release()

# def initModel():

def detect_frame(frame , model ,imgsz,device,half, save_img=False): # 处理opencv获取的一帧图片，然后返回给

    stride = int(model.stride.max())  # model stride
    imgsz = check_img_size(imgsz, s=stride)  # check img_size


    # Second-stage classifier
    classify = False
    if classify:
        modelc = load_classifier(name='resnet101', n=2)  # initialize
        modelc.load_state_dict(torch.load('weights/resnet101.pt', map_location=device)['model']).to(device).eval()

    # Get names and colors
    names = model.module.names if hasattr(model, 'module') else model.names
    colors = [[random.randint(0, 255) for _ in range(3)] for _ in names]

    # Run inference
    if device.type != 'cpu':
        model(torch.zeros(1, 3, imgsz, imgsz).to(device).type_as(next(model.parameters())))  # run once
    t0 = time.time()

    # 处理img
    # 用letterbox函数调整帧的大小以适应YOLO模型的输入尺寸。
    # 这会确保输入尺寸与模型的期望输入尺寸相同，同时保持图像的纵横比。
    # 根据需要，letterbox函数会在调整后的图像周围添加填充。
    img = letterbox(frame, new_shape=imgsz)[0]
    # Convert
    # 翻转图像通道，将BGR转换为RGB。OpenCV使用BGR颜色格式，而YOLO期望的输入是RGB格式。这里的"::-1"起到颠倒数组顺序的作用。
    # 转置数组，将其从(height, width, channels)的形状转换为(channels, height, width)的形状，以匹配模型期望的输入格式。
    # 使用np.ascontiguousarray确保底层数据在内存中是连续的，这有助于提高计算性能。
    img = img[:, :, ::-1].transpose(2, 0, 1)
    img = np.ascontiguousarray(img)
    # 将NumPy数组转换为PyTorch张量，并将其移动到gpu上。
    img = torch.from_numpy(img).to(device)
    img = img.half() if half else img.float() #gpu 半精度
    # 归一化：将像素值除以255，将其范围从[0,255]缩放到[0,1]。
    img /= 255.0
    # 如果张量的维数为3，则使用unsqueeze(0)在批次维度上添加额外的尺寸，以将其转换为4D张量。
    # 模型期望以批次的形式输入图像，因此我们需要模拟四维张量的形状，即使我们只处理一帧（即单个图像）。
    if img.ndimension() == 3:
        img = img.unsqueeze(0)

    # Inference
    pred = model(img, augment=opt.augment)[0]

    pred = non_max_suppression(pred, opt.conf_thres, opt.iou_thres, classes=opt.classes, agnostic=opt.agnostic_nms)
    im0 = frame.copy()
    det = pred[0]  # 只处理一个帧


    if len(det):
        # Rescale boxes from img_size to im0 size
        det[:, :4] = scale_coords(img.shape[2:], det[:, :4], im0.shape).round()

        for *xyxy, conf, cls in reversed(det):
            label = f'{names[int(cls)]} {conf:.2f}'
            plot_one_box(xyxy, im0, label=label, color=colors[int(cls)], line_thickness=3)

    return im0

app = Flask(__name__)

@app.route('/live')
def retVideo():
    return Response(generate(),mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--weights', nargs='+', type=str, default='yolov5s.pt', help='model.pt path(s)')
    # default='0' && datasets.py中第279行两个str(url)是摄像头，default='{path}' && url 是图片或者视频
    parser.add_argument('--source', type=str, default='0', help='source')
    parser.add_argument('--img-size', type=int, default=640, help='inference size (pixels)')
    parser.add_argument('--conf-thres', type=float, default=0.15, help='object confidence threshold') #置信度
    parser.add_argument('--iou-thres', type=float, default=0.45, help='IOU threshold for NMS')
    parser.add_argument('--device', default='', help='cuda device, i.e. 0 or 0,1,2,3 or cpu')
    parser.add_argument('--view-img', action='store_true', help='display results')
    parser.add_argument('--save-txt', action='store_true', help='save results to *.txt')
    parser.add_argument('--save-conf', action='store_true', help='save confidences in --save-txt labels')
    parser.add_argument('--nosave', action='store_true', help='do not save images/videos')
    parser.add_argument('--classes', nargs='+', type=int, help='filter by class: --class 0, or --class 0 2 3')
    parser.add_argument('--agnostic-nms', action='store_true', help='class-agnostic NMS')
    parser.add_argument('--augment', action='store_true', help='augmented inference')
    parser.add_argument('--update', action='store_true', help='update all models')
    parser.add_argument('--project', default='runs/detect', help='save results to project/name')
    parser.add_argument('--name', default='exp', help='save results to project/name')
    parser.add_argument('--exist-ok', action='store_true', help='existing project/name ok, do not increment')
    opt = parser.parse_args()
    print(opt)
    check_requirements(exclude=('pycocotools', 'thop'))

    app.run(host = data_screen_url,port=12888)



#F:\deeplearning\anaconda\anaconda\envs\pytorch