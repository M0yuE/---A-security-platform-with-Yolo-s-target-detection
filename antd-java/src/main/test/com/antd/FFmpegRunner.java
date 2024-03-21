package com.antd;


import com.antd.JavaCVTest;
import com.antd.TaskInfo;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.FrameGrabber;
import org.bytedeco.javacv.FrameRecorder;
import org.bytedeco.javacv.OpenCVFrameConverter;

import java.io.Closeable;
import java.io.IOException;

public class FFmpegRunner implements Runnable, Closeable {

    private TaskInfo taskInfo;
    private String inPath;
    private String outPath;
    private volatile boolean isClose = false;
    FFmpegFrameGrabber grabber;
    FFmpegFrameRecorder recorder;

    public FFmpegRunner() {
    }
    public FFmpegRunner(final TaskInfo taskInfo) {
        this.taskInfo = taskInfo;
        this.inPath = taskInfo.getInPath();
        this.outPath = taskInfo.getOutPath();
    }

    @Override
    public void run() {
        isClose = Boolean.FALSE;
        try {

            forward(inPath, outPath);
        } catch (Exception e) {

            e.printStackTrace();
        } finally {
            try {
                recorder.stop();
                recorder.release();
                grabber.stop();
                grabber.release();
            } catch (FrameRecorder.Exception e) {
                e.printStackTrace();
            } catch (FrameGrabber.Exception e) {
                e.printStackTrace();
            }

            if (!isClose) {
                try {
                    //线程已关闭 状态更改
                    close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public void close() throws IOException {
        isClose = true;
    }

    public boolean isClose() {
        return isClose;
    }

    protected void forward(String rtspPath, String rtmpPath) throws FrameRecorder.Exception, FrameGrabber.Exception {
        // 使用rtsp的时候需要使用 FFmpegFrameGrabber，不能再用 FrameGrabber
        int width = 640, height = 480;
        boolean push_stream = true;
        grabber = FFmpegFrameGrabber.createDefault(rtspPath);
        //grabber.setOption("rtsp_transport", "tcp"); // 使用tcp的方式，不然会丢包很严重
//        grabber.setImageHeight(height);
//        grabber.setImageWidth(width);
        System.out.println("grabber start");
        try {
            grabber.start();
        } catch (FrameGrabber.Exception e) {
            e.printStackTrace();
        }
        //转换框架
        OpenCVFrameConverter.ToIplImage conveter = new OpenCVFrameConverter.ToIplImage();//转换
        Frame grabFrame = null;
        int audioChannel = 0;
        int audioCodec = 0;
        int videoCodec = 0;
        int pixFormat = 0;

        int inVideoBit = 0;
        int inAudioBit = 0;
        double rate = 0D;
        try {
            grabFrame = grabber.grab();
            audioChannel = grabber.getAudioChannels();
            audioCodec = grabber.getAudioCodec();
            rate = grabber.getFrameRate();
            videoCodec = grabber.getVideoCodec();
            pixFormat = grabber.getPixelFormat();
            Frame grabImage = grabber.grabImage();
            taskInfo.setInMediaType(grabber.getVideoCodec()+"");
            inVideoBit = grabber.getVideoBitrate();

            inAudioBit = grabber.getAudioBitrate();
            if (grabImage != null) {
                height = grabImage.imageHeight;
                width = grabImage.imageWidth;
            }
        } catch (FrameGrabber.Exception e) {
            e.printStackTrace();
        }

        System.out.println("视频原始宽高" + "width:" + width + " height:" + height);
        // 流媒体输出地址，分辨率（长，高），是否录制音频（0:不录制/1:录制）
        recorder = new FFmpegFrameRecorder(rtmpPath, width, height, 0);
        recorder.setVideoOption("tune", "zerolatency");
        recorder.setMaxDelay(500);
        recorder.setVideoOption("preset", "ultrafast");
        recorder.setGopSize(10);
        recorder.setInterleaved(false);
        //recorder.setVideoOption("crf","28");
        recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264); // 28
        recorder.setFormat("flv"); // rtmp的类型
        recorder.setFrameRate(rate);//视频帧
//        recorder.setGopSize(10);//gop
//        recorder.setPixelFormat(0);
        System.out.println("recorder start");
        recorder.start();
        taskInfo.setOutMediaType(recorder.getVideoCodec()+"");
        long startTimestamp = 0;
        while ((grabFrame = grabber.grab()) != null && !isClose) {
            taskInfo.setInBit(grabber.getVideoBitrate());

            taskInfo.setOutBit(recorder.getVideoBitrate());
            if (startTimestamp == 0) {
                startTimestamp = System.currentTimeMillis();
            }
            recorder.setTimestamp(1000 * (System.currentTimeMillis() - startTimestamp));

            if (grabFrame != null) {
                recorder.record(grabFrame);
            }

        }
    }
    public static void main(String[] args) {
        JavaCVTest thread = new JavaCVTest();
        thread.setFilePath("D:/testOne.flv");
        thread.setStreamURL("http://192.168.0.193:81/stream");
        //thread.start();
        TaskInfo taskInfo = new TaskInfo("测试","http://192.168.0.193:81/stream","rtmp://localhost:1935/live/test1",10,null);
        FFmpegRunner fFmpegRunner = new FFmpegRunner(taskInfo);
        new Thread(fFmpegRunner).start();
    }
}
