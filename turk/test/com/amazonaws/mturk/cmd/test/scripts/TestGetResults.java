/*
 * Copyright 2012 Amazon Technologies, Inc.
 * 
 * Licensed under the Amazon Software License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * 
 * http://aws.amazon.com/asl
 * 
 * This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
 * OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and
 * limitations under the License.
 */ 



package com.amazonaws.mturk.cmd.test.scripts;

import com.amazonaws.mturk.cmd.test.util.ScriptRunner.ScriptResult;

import junit.textui.TestRunner;

public class TestGetResults extends TestBase {

    private static String outputFile = "testGetResults.tmp";
    
    public static void main(String[] args) {
        TestRunner.run(TestGetResults.class);
    }

    public TestGetResults(String arg0) {
        super(arg0);
    }

    public void testHappyCase() throws Exception {
        String successFile = getSuccessFile();
        ScriptResult result = runScript("getResults", "--successfile", successFile, "--outputfile", outputFile);
        assertEquals(0, result.getExitValue());
        expectNoError(result);
        deleteFile(outputFile);
        deleteFile(getSuccessFile());
    }
    
    public void testWrongSuccessFile() throws Exception {
        ScriptResult result = runScript("getResults", "--successfile", "wrongfile", "--outputfile", outputFile);
        assertTrue(result.getExitValue() != 0);
    }
    
    public void testNoOutputFile() throws Exception {
        String successFile = getSuccessFile();
        ScriptResult result = runScript("getResults", "--successfile", successFile);
        assertTrue(result.getExitValue() != 0);
        checkFile(outputFile, false);
        deleteFile(getSuccessFile());
    }
    
    public void testNoSuccessFile() throws Exception {
        ScriptResult result = runScript("getResults", "--outputfile", outputFile);
        assertTrue(result.getExitValue() != 0);
        checkFile(outputFile, false);
    }
}
