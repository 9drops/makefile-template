all:
	@echo "make..."
	make -C api
	make -C src
	make -C tools
clean:
	@echo "make clean..."
	make clean -C api
	make clean -C src
	make clean -C tools
re:
	make clean
	make all
exe:
	make -C src exe
release:
	@echo "make release..."
	@./release.sh
	@echo "done"
