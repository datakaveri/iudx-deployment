import re
import argparse

from time import sleep
from json import dumps
from os import rename 

from kazoo.client import KazooClient
from kazoo.exceptions import NoNodeError


def cmd():
	parser = argparse.ArgumentParser(description='Vert.x SD')
	parser.add_argument(
		'--zoos',
		help='comma-separated list of ZooKeeper hosts',
		required=True
	)
	parser.add_argument(
		'--dst',
		help='destination file to store targets',
	)
	parser.add_argument(
		'--tick',
		help='time in seconds between updates',
		type=float,
		default=2
	)
	parser.add_argument(
		'--hazelcast',
		help='if Hazelcast is used with ZooKeeper',
		action='store_true'
	)
	parser.add_argument(
		'--verbose',
		help='be verbose',
		action='store_true'
	)

	args = parser.parse_args()

	if args.hazelcast:
		root = "/discovery/hazelcast"
		pattern = re.compile(rb'"address":"([^"]+)"')
	else:
		print("Not implemented")
		exit(1)
	tick_time = args.tick
	dst = args.dst
	dst_tmp = dst+'.tmp'

	def log(msg):
		if args.verbose:
			print(msg)

	zk = KazooClient(hosts=args.zoos)
	zk.start()

	prev_targets = None
	try:
		while True:
			targets = []
			cluster_ids = []
			try:
				cluster_ids = zk.get_children(root)
			except KeyboardInterrupt:
				raise KeyboardInterrupt
			except NoNodeError:
				log("Root znode not found")

			for cluster_id in cluster_ids:
				try:
					children = zk.get_children(f"{root}/{cluster_id}")
					cluster_targets = []
					for child in children:
						try:
							data, _ = zk.get(f"{root}/{cluster_id}/{child}")
							match = pattern.search(data)
							if match:
								address = match.group(1)
								cluster_targets.append(address.decode() + ":9000")
						except KeyboardInterrupt:
							raise KeyboardInterrupt
						except NoNodeError:
							log("Child znode not found")
					targets.append({"targets": cluster_targets,
                                            "labels": {"cluster": cluster_id}})
				except KeyboardInterrupt:
					raise KeyboardInterrupt
				except NoNodeError:
					log("A cluster znode not found")

			log(targets)
			if targets != prev_targets:
				with open(dst_tmp, 'w') as f:
					f.write(dumps(targets, indent=4))
				# Prometheus likes atomic operation on file
				rename(dst_tmp, dst)
				prev_targets = targets

			sleep(tick_time)

	except KeyboardInterrupt:
		pass
	finally:
		zk.stop()
		log("Exited vertx_sd")


if __name__ == "__main__":
	cmd()
