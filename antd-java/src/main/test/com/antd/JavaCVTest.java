package com.antd;

import java.io.File;
import java.io.IOException;

import org.bytedeco.javacpp.avcodec;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.Frame;
import org.bytedeco.javacv.FrameGrabber;
import org.bytedeco.javacv.FrameRecorder;

public class JavaCVTest extends Thread {

    public String streamURL;// 流地址 网上有自行百度
    public String filePath;// 文件路径
    public Integer id;// 案件id

    public void setStreamURL(String streamURL) {
        this.streamURL = streamURL;
    }
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
    @Override
    public void run() {
        System.out.println(streamURL);
        // 获取视频源
        FFmpegFrameGrabber grabber = null;
        try{
            grabber = FFmpegFrameGrabber.createDefault(streamURL);
        }catch (Exception e){
            e.printStackTrace();
        }
        grabber.setOption("timeout","50");
        double rate = grabber.getFrameRate();
        //FFmpegFrameRecorder recorder = null;
        FFmpegFrameRecorder recorderToRtmp = null;
        try {
            grabber.start();
            Frame frame = grabber.grabImage();
            if (frame != null) {
                File outFile = new File(filePath);
                if (!outFile.isFile()) {
                    try {
                        outFile.createNewFile();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
                // 流媒体输出地址，分辨率（长，高），是否录制音频（0:不录制/1:录制）
                //recorder = new FFmpegFrameRecorder(filePath, 1280, 720, 0);
                recorderToRtmp = new FFmpegFrameRecorder("rtmp://localhost:1935/live/test1",1280, 720, 0);
                //recorder.setVideoCodec(avcodec.AV_CODEC_ID_H264);// 直播流格式
                //recorder.setFormat("flv");// 录制的视频格式
                //recorder.setFrameRate(15);// 帧数
                //百度翻译的比特率，默认400000，但是我400000贼模糊，调成800000比较合适
                //recorder.setVideoBitrate(800000);


                recorderToRtmp.setVideoCodec(avcodec.AV_CODEC_ID_H264);// 直播流格式
                recorderToRtmp.setFormat("flv");// 录制的视频格式
                recorderToRtmp.setFrameRate(25);// 帧数
                //百度翻译的比特率，默认400000，但是我400000贼模糊，调成800000比较合适
                recorderToRtmp.setVideoBitrate(800000);
                //recorder.start();
                recorderToRtmp.start();
                while ((frame != null)) {
                    //recorder.record(frame);// 录制
                    recorderToRtmp.record(frame);// 录制
                    frame = grabber.grab();// 获取下一帧
                }
                //recorder.record(frame);
                recorderToRtmp.record(frame);
                // 停止录制
                //recorder.stop();
                recorderToRtmp.stop();
                grabber.stop();
            }
        } catch (FrameGrabber.Exception e) {
            e.printStackTrace();
        } catch (FrameRecorder.Exception e) {
            e.printStackTrace();
        } finally {
            if (null != grabber) {
                try {
                    grabber.stop();
                } catch (FrameGrabber.Exception e) {
                    e.printStackTrace();
                }
            }
            /*if (recorder != null) {
                try {
                    recorder.stop();
                } catch (FrameRecorder.Exception e) {
                    e.printStackTrace();
                }
            }*/
        }
    }
    public static void main(String[] args) {
        JavaCVTest thread = new JavaCVTest();
        thread.setFilePath("D:/testOne.flv");
        thread.setStreamURL("http://192.168.0.193:81/stream");
        thread.start();
        /*TaskInfo taskInfo = new TaskInfo("测试","http://192.168.0.193:81/stream","rtmp://localhost:1935/live/test1",25,null);
        FFmpegRunner fFmpegRunner = new FFmpegRunner(taskInfo);
        new Thread(fFmpegRunner).start();*/
    }
}