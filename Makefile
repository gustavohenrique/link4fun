deploy:
	rsync -r $(PWD) link4fun:/home/ubuntu
	ssh link4fun "sudo systemctl reload openresty"
