#!/bin/bash
heroku logs -t | grep -v get_current_timest | grep -v moocchat_global_no | grep -v 'Parameters: {"callback"=>"jsonCallback", "_"=>"[[:digit:]]\+"}' | grep -v '#memory_total' | grep -v '#load_avg' | grep -v 'Completed 200 OK in 0.[[:digit:]]ms (Views: 0.[[:digit:]]ms | ActiveRecord: 0.0ms)'
