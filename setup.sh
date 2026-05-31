#!/bin/bash
echo "Starting Vagrant VM..."
vagrant up --provider=virtualbox
echo "Status:"
vagrant status
echo "To connect: vagrant ssh"
echo "To stop: vagrant halt"
