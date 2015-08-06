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



package com.amazonaws.mturk.cmd.test;

import java.io.FileNotFoundException;
import com.amazonaws.mturk.cmd.CreateQualificationType;
import junit.textui.TestRunner;

public class TestCreateQualificationType extends TestBase {

    private static CreateQualificationType lh = null;
    
    static {
      lh = new CreateQualificationType();
      lh.setSandBoxMode();
    }

    public static void main( String[] args ) {
        TestRunner.run( TestCreateQualificationType.class );
    }

    public TestCreateQualificationType( String arg0 ) {
        super( arg0 );
    }

    public void testWrongTestFile() throws FileNotFoundException {

        boolean result = lh.createQualificationType( "wrongfile", answerKeyFile, qualPropsFile, false );
        assertFalse( "Should have failed", result );

        expectError( "Couldn't find one of the necessary files" );
    }

    public void testWrongAnswerFile() throws FileNotFoundException {

        boolean result = lh.createQualificationType( qualificationTestFile, "wrongfile", qualPropsFile, false);
        assertFalse( "Should have failed", result );

        expectError( "Couldn't find one of the necessary files" );
    }

    public void testWrongPropertiesFile() throws FileNotFoundException {

        boolean result = lh.createQualificationType( qualificationTestFile, answerKeyFile, "wrongfile", false );
        assertFalse( "Should have failed", result );

        expectError( "Couldn't find one of the necessary files" );
    }
}
