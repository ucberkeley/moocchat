from websocket import create_connection
import json
import sys
import timeit
import datetime
#https://pypi.python.org/pypi/websocket-client/
#best = 538

number = 300
size = 300

def getDateTime():
	current = str(datetime.datetime.now())	
	return current.replace(" ", "_")

def construct_response(learner_number, input):
	message = json.loads(input)
	message["text"] = "Learner " + str(learner_number) + ": " + 	message["text"]
	return message



def print_store_total():
	print "Finish a total of: " + str(total_completed) + " websockets"
	print "Took a total of: " + str(sum(runtimes))
	statFile.write("Finish a total of: " + str(total_completed) + " websockets" + "\n")
	statFile.write("Took a total of: " + str(sum(runtimes)) + "\n")

def print_store(record):
	print str(record)
	statFile.write(record + "\n")



def formGroup(first_taskid, last_taskid):
	group = str(first_taskid)
	for taskid in range(first_taskid + 1, last_taskid):
		group = group + "," + str(taskid)
	print_store("group of taskid: " + str(group) + "\n")
	return group

def createAllWS(group, first_taskid, last_taskid):
	websockets = []
	for taskid in range(first_taskid, last_taskid):
		url = "wss://moocchat-john-single.herokuapp.com/" + group + "," + str(taskid)
		ws = create_connection(url)
		websockets.append(ws)
	return websockets

def verifyReceive(websockets, expected):
	global total_completed
	for ws in websockets:
		result = json.loads(ws.recv())
		if expected != result:
			print_store("Failed: different meessage! Expected: " + str(expected) + "| Got: " + result)
			print_store_total()
			sys.exit(1)
		total_completed = total_completed + 1

def closeAllWS():
	for group in groups:
		for ws in group:
			ws.close()

def performGroup(groupSize, first_taskid):
	start = timeit.default_timer()
	last_taskid = first_taskid + groupSize
	group = formGroup(first_taskid, last_taskid)	
	websockets = createAllWS(group, first_taskid, last_taskid)
	groups.append(websockets)
	#send data from ws1
	data = json.dumps({"text": "testLoading", "taskid": first_taskid, "type": "message"})
	websockets[0].send(data)
	print_store("message_sent: " + str(data))
	expected = construct_response(1, data)	# 1 is learner index
	print_store("expected to receive: " + str(expected))
	#receive number of web sockets
	verifyReceive(websockets, expected)
	stop = timeit.default_timer()
	runtime = stop - start
	runtimes.append(runtime)
	print_store("Finish: " + str(groupSize) + " websockets\n")
	print_store("Took: " + str(runtime) + "\n")

groups = []
first_taskid = 0

total_completed = 0
runtimes = []
statFile = open("loadResult" + str(getDateTime()) + ".txt", "w")

while number > 0:
	groupSize = 0
	if number % size == 0:
		groupSize = size
	else:
		groupSize = number % size
	performGroup(groupSize, first_taskid)
	#wrap up for next loop
	first_taskid = first_taskid + groupSize
	number = number - size

closeAllWS()
print_store_total()
sys.exit(0)



