package com.antd.modules.security.connect;

import java.math.BigInteger;

public class BinaryConversionUtils {

    public static final String bytesToHexString(byte[] bArray) {
        StringBuffer sb = new StringBuffer(bArray.length);
        String sTemp;
        for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2)
                sb.append(0);
            sb.append(sTemp.toUpperCase());
        }
        return sb.toString();
    }
    public static byte[] hexStrToBinaryStr(String hexString) {
        hexString = hexString.replaceAll(" ", "");
        int len = hexString.length();
        int index = 0;
        byte[] bytes = new byte[len / 2];
        while (index < len) {
            String sub = hexString.substring(index, index + 2);
            bytes[index / 2] = (byte) Integer.parseInt(sub, 16);
            index += 2;
        }
        return bytes;
    }

    public static String  hexStrToMarkDecimal(String hexStr){
        int bm=Integer.parseInt(hexStr,16);
        return  -Integer.parseInt(Integer.toBinaryString(~(bm-1)).substring(16),2)+"";
    }

    public static void main(String[] args) {
        String str ="FF9B";

        System.out.println(hexStrToMarkDecimal(str));

        System.out.println("有符号： "+parseHex4("FF9B "));
    }

    public static String parseHex4(String num) {
        if (num.length() != 4) {
            throw new NumberFormatException("Wrong length: " + num.length() + ", must be 4.");
        }
        int ret = Integer.parseInt(num, 16);
        ret = ((ret & 0x8000) > 0) ? (ret - 0x10000) : (ret);
        return  String.valueOf(ret) ;
    }

    /**
     * 十六进制转负数

     * (4个字节的)
     */
    public static BigInteger parseHex8(String num) {
        if (num.length() != 8) {
            throw new NumberFormatException("Wrong length: " + num.length() + ", must be 4.");
        }
        BigInteger in = new BigInteger(num,16);
        return  in;
    }
}
