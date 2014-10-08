from websocket import create_connection
import json

taskID = 1
data = {"text": "testLoading", "taskid": str(taskID), "type": "message"}
ws = create_connection("wss://moocchat-john.herokuapp.com/1,1")
ws.send(json.dumps(data))
result = ws.recv()
print "Received '%s'" % result
ws.close()

