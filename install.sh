#!/bin/bash

echo ""
echo "----------------"
echo "protop installer"
echo "----------------
"

protop_say()
{
    echo "[protop]  $1"
}

#build a clean distribution
gradle=./gradlew
protop_say "\`gradle clean\`"
$gradle clean -q

protop_say "\`gradle build\`"
$gradle build -Pdev -q

# move distribution
dir=~/.protop
tmp=$dir/tmp

protop_say "Moving build artifacts to temporary directory"
mkdir -p $tmp
rm -rf $tmp/*
dist=$tmp/dist.tgz
cp ./build/distributions/*.tgz $dist
cd $tmp

# unpack
protop_say "Unpacking artifacts"
tar -C . -zxf $dist

protop_say "Deleting previous installation"
rm -rf $dir/bin
mkdir $dir/bin
rm -rf $dir/lib
mkdir $dir/lib

protop_say "Moving binaries to their new home"
mv $tmp/*/bin/* $dir/bin/

# and jars
mv $tmp/*/lib/* $dir/lib/

# cleanup
cd $dir && rm -rf $tmp

if [[ ":$PATH:" == *":$HOME/.protop/bin:"* ]]; then
    protop_say "\`~/.protop/bin\` already in PATH"
    protop_say "Succeeded!
"
    protop
else
    protop_say "Your path is missing \`~/.protop/bin\`; you will need to add it:"
    protop_say "  - Add \`export PATH=\"\$PATH:\$HOME/.protop/bin\"\` to your \`~/.bashrc\` or \`~/.zshrc\` etc."
    protop_say "  - Then try \`protop\` or \`protop help\` to get started!"
fi
