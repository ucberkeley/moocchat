from websocket import create_connection
import json
import sys
import timeit
#https://pypi.python.org/pypi/websocket-client/
#best = 538

def construct_response(learner_number, input):
	message = json.loads(input)
	message["text"] = "Learner " + str(learner_number) + ": " + 	message["text"]
	return message

def print_store_stat():
	print "Finish a total of: " + str(total_completed) + " websockets"
	print "Took a total of: " + str(sum(runtimes))
	statFile.write("Finish a total of: " + str(total_completed) + " websockets" + "\n")
	statFile.write("Took a total of: " + str(sum(runtimes)) + "\n")

def print_store(record):
	print str(record)
	statFile.write(record + "\n")

number = 5000
groupSize = 200
first_taskid = 0

total_completed = 0
runtimes = []
statFile = open("testLoading.txt", "w")
while number > 0:
	websockets = []
	message_sent = {}
	size = 0
	start = timeit.default_timer()
	if number % groupSize == 0:
		size = groupSize
	else:
		size = number % groupSize
	last_taskid = first_taskid + size

	#construct group
	group = str(first_taskid)
	for taskid in range(first_taskid + 1, last_taskid):
		group = group + "," + str(taskid)

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
			print_store("Failed: different meessage! Expected: " + expected + "| Got: " + result)
			print_store_stat()
			sys.exit(1)
		ws.close()
		total_completed = total_completed + 1	

	#wrap up for next loop
	first_taskid = last_taskid
	number = number - size
	stop = timeit.default_timer()
	runtime = stop - start
	runtimes.append(runtime)
	print_store("group of taskid: " + str(group) + "\n")
	print_store("map of message_sent: " + str(message_sent) + "\n")
	print_store("Finish: " + str(size) + " websockets")
	print_store("Took: " + str(runtime) + "\n\n\n")


print_store_stat()
sys.exit(0)



