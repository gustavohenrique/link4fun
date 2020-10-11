deploy:
	rsync -r $(PWD)/lua $(PWD)/site link4fun:/home/ubuntu/link4fun/
	ssh link4fun "sudo systemctl reload openresty"

docker:
	docker build . -t=gustavohenrique/link4fun:alpine
	docker rm -f link4fun 2>/dev/null
	docker run -d --name link4fun -p 8000:80 gustavohenrique/link4fun:alpine
