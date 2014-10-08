from websocket import create_connection
import json
import sys
#https://pypi.python.org/pypi/websocket-client/
websockets = []
number = 20
groupSize = 10
first_taskid = 0

while number > 0:
	websockets = []
	size = 0
	if number % groupSize == 0:
		size = groupSize
	else:
		size = number % groupSize
	last_taskid = first_taskid + size

	#construct group
	group = str(first_taskid)
	for taskid in range(first_taskid + 1, last_taskid):
		group = group + "," + str(taskid)
	print "group: " + group
	#First web socket
	data1 = {"text": "testLoading", "taskid": first_taskid, "type": "message"}
	url1 = "wss://moocchat-john.herokuapp.com/" + group + "," + str(first_taskid)
	ws1 = create_connection(url1)
	websockets.append(ws1)
	ws1.send(json.dumps(data1))

	#create a lot of web sockets
	for taskid in range(first_taskid, last_taskid):
		url = "wss://moocchat-john.herokuapp.com/" + group + "," + str(taskid)
		ws = create_connection(url)
		websockets.append(ws)
	#send data from ws1
	#ws1.send(json.dumps(data1))
	first_taskid = last_taskid
	number = number - size
	for ws in websockets:
		#result = ws.recv()
		#print "Received '%s'" % result
		ws.close()
#receive and close number of web sockets
#for ws in websockets:
	#result = ws.recv()
	#print "Received '%s'" % result
	#ws.close()

print "Done, finish: " + str(number) + " websockets"
sys.exit(0)