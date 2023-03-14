#This python script watches for the changes in file LATEST.LOG and backup the definition
#by calling the backup.sh
import time 
import os
from watchdog.observers import Observer 
from watchdog.events import FileSystemEventHandler 

class OnMyWatch: 
	# Set the directory to watch 
	watchDirectory = "/var/lib/rabbitmq/"

	def __init__(self): 
		self.observer = Observer() 
	def run(self): 
		event_handler = Handler() 
		#recursively watch files in watchDirectory
		self.observer.schedule(event_handler, self.watchDirectory, recursive = True) 
		self.observer.start() 
		try: 
			while True: 
				time.sleep(5) 
		except: 
			self.observer.stop() 
			print("Observer Stopped") 
		self.observer.join() 


class Handler(FileSystemEventHandler): 
	exec_string = f'/usr/share/app/src/backup.sh'

	def on_any_event(self,event): 
		file_name=event.src_path.split('/')[-1]
		if event.is_directory: 
			return None
		elif event.event_type == 'modified' and file_name ==  'LATEST.LOG': 
			#executes the backup script in shell on change of LATEST.LOG file
			os.system(self.exec_string)
			
if __name__ == '__main__': 
	watch = OnMyWatch() 
	watch.run() 

