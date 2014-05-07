cafe:
	jekyll build
	ghp-import _site -b gitcafe-pages -r cafe -p

clean:
	sh export.sh

pub:
	make cafe
	git ci -am'make:add or update post'
	git push origin master

