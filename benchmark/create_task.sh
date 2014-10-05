#!/bash
httperf --server=moocchat-load.herokuapp.com --method=POST --uri=/tasks/Learner+1/1/1 --num-conns=100 --rate=20 --timeout=5
