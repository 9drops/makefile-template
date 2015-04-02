#! /bin/bash

md5list=./md5list.sh
src_lib=./lib
src_bin=./bin

res=`svn st|grep "M    "`
res2=`svn st|grep "!    "`
if [ "$res"x != x ] || [ "$res2"x != x ];then
	echo $res
	echo "svn状态不同步，请处理后再发布版本"
	exit 2
fi

svn up

version=`svn info|grep 修订版|awk 'BEGIN {FS="："} {if (NR==1) print $2}'`
if [ "$version"x = x ];then
	version=`svn info|grep Revision|awk 'BEGIN {FS=":"} {if (NR==1) print $2}'`
fi


if [ "$version"x = x ];then
	version=`date +%s`
fi

release_dir=./release.$version
mkdir $release_dir
cp -rf $src_lib $release_dir
cp -rf $src_bin $release_dir

find $release_dir -name .svn | xargs rm -rf

for i in $release_dir/bin/*; do
	res=`echo $i|grep auth`
	if [ "$res"x != x ];then
		rm -f $i
	fi
done

$md5list $release_dir $release_dir/release.md5.list.$version
tar -zcvf $release_dir.tar.gz $release_dir > /dev/null
rm -rf $release_dir > /dev/null 
echo "Released completed, Realse file:$release_dir.tar.gz"

exit 0
