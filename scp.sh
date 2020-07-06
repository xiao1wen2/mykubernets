#!/bin/bash
#此脚本是配合scp.exp脚本文件自动完成自动化批量传输文件
for i in `cat ip_list`
do 
 expect scp.exp $i
done
