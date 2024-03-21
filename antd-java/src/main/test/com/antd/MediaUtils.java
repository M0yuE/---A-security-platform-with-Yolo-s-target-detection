package com.antd;


import org.bytedeco.ffmpeg.avcodec.AVPacket;
import org.bytedeco.ffmpeg.global.avcodec;
import org.bytedeco.ffmpeg.global.avutil;
import org.bytedeco.javacv.FFmpegFrameGrabber;
import org.bytedeco.javacv.FFmpegFrameRecorder;
import org.bytedeco.javacv.FrameGrabber;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.stereotype.Component;

import javax.xml.soap.SOAPException;
import java.io.IOException;
import java.net.ConnectException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Executor;

import static org.bytedeco.ffmpeg.global.avcodec.av_packet_unref;

/**
 * @program: javaOnvif
 * @description: 获取rtsp地址
 * @author: zf
 * @create: 2020-09-08 10:50
 **/
@Component
public class MediaUtils {

    @Autowired
    ThreadPoolTaskExecutor taskExecutor;
    /**
     * 视频帧率
     */
    public static final int FRAME_RATE = 25;
    /**
     * 视频宽度
     */
    public static final int FRAME_WIDTH = 1280;
    /**
     * 视频高度
     */
    public static final int FRAME_HEIGHT = 720;
    /**
     * 流编码格式
     */
    public static final int VIDEO_CODEC = avcodec.AV_CODEC_ID_H264;
    /**
     * 编码延时 zerolatency(零延迟)
     */
    public static final String TUNE = "zerolatency";
    /**
     * 编码速度 ultrafast(极快)
     */
    public static final String PRESET = "ultrafast";
    /**
     * 录制的视频格式 flv(rtmp格式) h264(udp格式) mpegts(未压缩的udp) rawvideo
     */
    public static final String FORMAT = "h264";
    /**
     * 比特率
     */
    public static final int VIDEO_BITRATE = 200000;

    private static FFmpegFrameGrabber grabber = null;
    private static FFmpegFrameRecorder recorder = null;


    /**
     * 构造视频抓取器
     * @param rtsp 拉流地址
     * @return
     */
    public static FFmpegFrameGrabber createGrabber(String rtsp) {
        // 获取视频源
        FFmpegFrameGrabber grabber = new FFmpegFrameGrabber(rtsp);
        //grabber.setOption("rtsp_transport","tcp");
        //设置帧率
        grabber.setFrameRate(FRAME_RATE);
        //设置获取的视频宽度
        grabber.setImageWidth(FRAME_WIDTH);
        //设置获取的视频高度
        grabber.setImageHeight(FRAME_HEIGHT);
        //设置视频bit率
        grabber.setVideoBitrate(2000000);
        return grabber;
    }

    /**
     * 选择视频源
     * @param src
     * @author eguid
     * @throws FrameGrabber.Exception
     */
    public MediaUtils from(String src) throws FrameGrabber.Exception {
        long start = System.currentTimeMillis();
        // 采集/抓取器
        grabber = createGrabber(src);
        // 开始之后ffmpeg会采集视频信息
        grabber.start();
        grabber.flush();
        String form = src.substring(src.indexOf("@") + 1);
        return this;
    }

}
