
#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 -i or $0 -u"
    exit 1
fi

param=$1

# 根据参数值执行不同的操作
if [ "$param" = "-i" ]; then
    ocamlfind ocamlopt -linkpkg -package yojson JsonStructure.ml -o json
    rm JsonStructure.cmi JsonStructure.o JsonStructure.cmx
    ./json
elif [ "$param" = "-u" ]; then
    ./json
else 
    echo "Bad input! Usage: $0 -i or $0 -u"
    exit 1
fi