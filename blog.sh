#!/bin/sh
read -p "创建(N)/发布(P)/本地发布(S)博客:" type
#while (( $type != 'N' && $type != 'P'))
#do
#    read -p "创建(N)/发布(P)博客:" type
#done
path='/Users/mac/blog'
if [ $type = 'N' ]
then
    read -p "博客名称:" name
    echo `cd $path;hexo new $name`
    echo 'N'
elif [ $type = 'P' ]
then
	`cd $path;hexo clean; hexo g; hexo d`
    echo "finished!"
elif [ $type = 'S' ]
then 
	`cd $path;hexo s`
	echo "finished!"
else
	echo "see you again!"
fi
