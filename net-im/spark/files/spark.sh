#!/bin/bash

BASE=/usr/share/spark

#Installing emotions
if [[ ! -d ~/.Spark/xtra/emoticons ]] ; then
    mkdir -p ~/.Spark/xtra/emoticons
    cd ~/.Spark/xtra/emoticons/
    for em in ${BASE}/xtra/emoticons/*.zip ; do
        unzip -qq ${em}
    done

fi

#Installing plugins
if [[ ! -d ~/.Spark/plugins ]] ; then
    mkdir -p ~/.Spark/plugins
    cp ${BASE}/plugins/*.jar ~/.Spark/plugins/
fi

#Preparing sounds
if [[ ! -d ~/.Spark/resources ]] ; then
    mkdir -p ~/.Spark/resources
    ln -s ${BASE}/resources/sounds ~/.Spark/resources/sounds
fi


#Running application
cd ${BASE}/lib/
"${JAVA_HOME}/bin/java" -jar startup.jar