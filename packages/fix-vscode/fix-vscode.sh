#!/usr/bin/env nix-shell 
#!nix-shell -i bash -p patchelf

find ~/.vscode-server  -print0 -name node -type f \
	| xargs patchelf \
		--set-interpreter "$(patchelf --print-interpreter "$(which patchelf)")" \
		--set-rpath "$(dirname "$(ldd "$(which patchelf)" | grep stdc++ | cut -d' ' -f3)")"

find ~/.vscode-server  -print0 -name rg -type f \
	| xargs patchelf \
		--set-interpreter "$(patchelf --print-interpreter "$(which patchelf)")" \
		--set-rpath "$(dirname "$(ldd "$(which patchelf)" | grep stdc++ | cut -d' ' -f3)")"
