## Notes on websocket chatserver load testing

1. open moocchat/benchmark/chatserver/groups.py and modify number and size accordingly. number is total number of alive websockets at at the same time. size is size of a chat group.

2. cd into moocchat/benchmark/chatserver/result

3. run python ../groups.py

4. result of load testing will be stored in moocchat/benchmark/chatserver/result. Scroll to the bottom of this file to for "Finish a total of: " to see total number of websockets successfully kept alive at the same time.
