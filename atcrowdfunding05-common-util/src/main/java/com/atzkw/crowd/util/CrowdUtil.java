package com.atzkw.crowd.util;

import com.atzkw.crowd.constant.CrowdConstant;

import javax.servlet.http.HttpServletRequest;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Logger;

public class CrowdUtil {
    public static boolean judgeRequestType(HttpServletRequest request) {

        String acceptHeader = request.getHeader("Accept");
        String xrequestHeader = request.getHeader("X-Requested-With");
        return (acceptHeader != null && acceptHeader.contains("application/json"))
                ||
                (xrequestHeader != null && xrequestHeader.equals("XMLHttpRequest"));
    }

    public static String md5(String source) {
//        1.判断是否有效
        if (source == null || source.length() == 0) {
            throw new RuntimeException(CrowdConstant.MESSAGE_STRING_INVALIDATE);
        }
        //获取MessageDigest对象
        String algorithm = "md5";
        try {
            MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
            //获取对应的字节数组
            byte[] input = source.getBytes();
            //执行加密
            byte[] output = messageDigest.digest(input);
            //创建BigInteger对象
            int signum = 1;
            BigInteger bigInteger = new BigInteger(signum, output);
            //按照16进制将其转为字符串
            int radix = 16;
            String encoded = bigInteger.toString(radix).toUpperCase();
            return encoded;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }
}
