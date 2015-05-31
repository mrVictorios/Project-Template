#!/bin/sh

VERSION='1.0'
AUTHOR='Manuel Rogoll'
WORKINGDIR=$(pwd)
BASEDIR=$(dirname $0)
PROJECT_NAME=$2

init(){
    SOURCE="$BASEDIR/.."

    if [[ "$SOURCE" == *"vendor/bin"* ]]
        then
        SOURCE="$BASEDIR/../manrog/project-template"
    fi

    echo "Project Tempalte: $PROJECT_NAME"
    echo "initialize..."

    if [ ! -d "$WORKINGDIR/src" ]
        then
            cp -r "$SOURCE/src" "$WORKINGDIR"
    fi
    if [ ! -d "$WORKINGDIR/tests" ]
        then
            cp -r "$SOURCE/tests" "$WORKINGDIR"
    fi
    if [ ! -d "$WORKINGDIR/puppet" ]
        then
            cp -r "$SOURCE/puppet" "$WORKINGDIR"
    fi
    if [ ! -f "$WORKINGDIR/Vagrantfile" ]
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

    TPL="no"

    case "$answer" in
        'mysql')
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_mysql_tpl.pp"/g' "$WORKINGDIR/Vagrantfile"
            TPL="$answer"
            ;;
        'mongo')
            TPL="$answer"
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_mongodb_tpl.pp"/g' "$WORKINGDIR/Vagrantfile";;
        'user(manual configuration)')
            sed -i '' 's/puppet.manifest_file.*=.*".*"/puppet.manifest_file = "apache_php_user_specific_tpl.pp"/g' "$WORKINGDIR/Vagrantfile";;
    esac

    if [ "$TPL" == "no" ]
        then
            echo "finish"
            exit
    fi

    sed -i '' "s/vb.name.*=.*\".*\"/vb.name = \"$PROJECT_NAME\"/g" "$WORKINGDIR/Vagrantfile"

    echo "wich url you want to use?(www.example.local)"
    read answer

    if [ "$answer" != "" ]
        then

        TPL+='_tpl'
        SERVERNAME="$answer"

        sed -i '' "s/\$servername.*=.*'.*'/\$servername = '$SERVERNAME'/g" "$WORKINGDIR/puppet/manifests/apache_php_$TPL.pp"

        echo 'change host only ip?(default: 192.168.56.111)(y/N)'
        read answer

        if [ "$answer" == "y" ]
            then
                echo "new ip:"
                read answer

                sed -i '' "s/\"private_network\",.*ip:.*\".*\"/\"private_network\", ip: \"$answer\"/g" "$WORKINGDIR/Vagrantfile"
            else
                answer="192.168.56.111"
        fi

        echo "\n\n\nadd '$answer $SERVERNAME' to youre hosts file"

        echo 'Run "vagrant up"?(y/N)'
        read answer

        echo 'finish\n\n\n'

        if [ "$answer" == "y" ]
            then
                vagrant up
        fi

        else

            echo 'finish\n\n\n'
    fi


}

case $1 in
    'init')
        init
    ;;
    '-v')
        echo "Project-Template\nVersion: $VERSION\n Manuel Rogoll";;
esac
