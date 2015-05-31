#!/bin/sh

VERSION='1.0'
AUTHOR='Manuel Rogoll'
WORKINGDIR=$(pwd)
BASEDIR=$(dirname $0)
PROJECT_NAME=$2

echo "$WORKINGDIR"

init(){
    SOURCE="$BASEDIR/.."

    echo "Project Tempalte: $PROJECT_NAME"
    echo "initialize..."

    if [ ! -d "src" ]
        then
            cp "$SOURCE/src" "$WORKINGDIR"
    fi
    if [ ! -d "tests" ]
        then
            cp "$SOURCE/tests" "$WORKINGDIR"
    fi
    if [ ! -d "puppet" ]
        then
            cp "$SOURCE/puppet" "$WORKINGDIR"
    fi
    if [ ! -f "Vagrantfile" ]
        then
            cp "$SOURCE/Vagrantfile" "$WORKINGDIR"
    fi


    echo 'create .gitignore ?(y/N)'
    read answer

    if [ "$answer" == "y" ]
        then
            cp "$SOURCE/.gitignore" "$WORKINGDIR"
    fi

    echo 'Wich Template you want use?(mysql/mongo/user)'
    read answer

    case "$answer" in
        'mysql')
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_mysql_tpl.pp"/g' "$WORKINGDIR/Vagrantfile";;
        'mongo')
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_mongodb_tpl.pp"/g' "$WORKINGDIR/Vagrantfile";;
        'user')
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_user_specific_tpl.pp"/g' "$WORKINGDIR/Vagrantfile";;
    esac

    sed -i '' "s/vb.name.*=.*\".*\"/vb.name = \"$PROJECT_NAME\"/g" "$WORKINGDIR/Vagrantfile"

    echo 'Run "vagrant up"?(y/N)'
    read answer

    echo 'finish\n\n\n'


    if [ "$answer" == "y" ]
        then
            vagrant up
    fi
}

case $1 in
    'init')
        init
    ;;
    '-v')
        echo "Project-Template\nVersion: $VERSION\n Manuel Rogoll";;
esac
