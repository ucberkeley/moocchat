from websocket import create_connection
import json
import sys
#https://pypi.python.org/pypi/websocket-client/
data1 = {"text": "testLoading", "taskid": str(0), "type": "message"}
ws1 = create_connection("wss://moocchat-john.herokuapp.com/0,7,0")
ws2 = create_connection("wss://moocchat-john.herokuapp.com/0,7,7")
ws1.send(json.dumps(data1))
result1 = ws1.recv()
result2 = ws2.recv()

print "Received '%s'" % result1
print "Received '%s'" % result2
ws1.close()
#ws2.close()

sys.exit(0)