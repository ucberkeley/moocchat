from websocket import create_connection
import json
import sys

def construct_response(learner_number, input):
	message = json.loads(input)
	message["text"] = "Learner " + str(learner_number) + ": " + 	message["text"]
	return message

#https://pypi.python.org/pypi/websocket-client/
websockets = []
number = 500
groupSize = 500
first_taskid = 0

while number > 0:
	websockets = []
	message_sent = {}
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

	#create a lot of web sockets
	for taskid in range(first_taskid, last_taskid):
		url = "wss://moocchat-john.herokuapp.com/" + group + "," + str(taskid)
		ws = create_connection(url)
		websockets.append(ws)

	#send data from ws1
	data = json.dumps({"text": "testLoading", "taskid": first_taskid, "type": "message"})
	websockets[0].send(data)
	message_sent[str(first_taskid)] = construct_response(1, data)

	#receive and close number of web sockets
	for ws in websockets:
		result = json.loads(ws.recv())
		expected = message_sent[str(first_taskid)]
		if expected != result:
			print "Failed: different meessage! Expected: " + expected + "| Got: " + result
			sys.exit(1)
		ws.close()
	first_taskid = last_taskid
	number = number - size
	print "Finish: " + str(size) + " websockets"

sys.exit(0)



