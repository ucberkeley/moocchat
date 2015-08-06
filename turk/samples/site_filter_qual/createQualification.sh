#!/usr/bin/env sh
#
# Copyright 2012 Amazon Technologies, Inc.
# 
# Licensed under the Amazon Software License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at:
# 
# http://aws.amazon.com/asl
# 
# This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and
# limitations under the License.
 

cd ../..
cd bin
./createQualificationType.sh $@ -sandbox -question ../samples/site_filter_qual/site_filter_qual.question -properties ../samples/site_filter_qual/site_filter_qual.properties -answer ../samples/site_filter_qual/site_filter_qual.answer
cd ..
cd samples/site_filter_qual
