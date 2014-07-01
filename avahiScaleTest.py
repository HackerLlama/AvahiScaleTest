#!/usr/bin/python

import docker
import os

dockerClient = docker.Client(base_url='unix://var/run/docker.sock',
                  			 version='1.12',
                  			 timeout=10)

for avahiContainerIndex in xrange(4):

	#loop starts here

	#Name single container 
	avahiContainerName = "avahiContainer%d" % avahiContainerIndex

	#Create start-able container
	avahiContainerId = dockerClient.create_container("hackerllama/avahi_container:v4",
								  command="/AvahiLite/bootAvahiContainer",
								  name=avahiContainerName)

	#Start container
	dockerClient.start(avahiContainerId)

	#Avahi uses multicast, but default networking in 
	#Docker does not currently support multicast
	#Use Pipework to install a second eth1 adapter, which supports multicast
	os.system("pipework br1 %s 192.168.37.%d/24" % (avahiContainerName, avahiContainerIndex+2))

#loop ends here


os.system("ip addr add 192.168.1/24 dev br1")

#container will wait for eth1 to come online before starting avahi daemon
