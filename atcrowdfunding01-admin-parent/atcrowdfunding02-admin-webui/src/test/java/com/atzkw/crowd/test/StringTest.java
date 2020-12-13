package com.atzkw.crowd.test;

import com.atzkw.crowd.util.CrowdUtil;
import org.junit.Test;

public class StringTest {

    @Test
    public void testMd5(){
        String source = "12345";
        String encoded = CrowdUtil.md5(source);
        System.out.println(encoded);
    }
}
