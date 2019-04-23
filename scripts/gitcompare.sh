#! /bin/bash
if ((2==$#)); then
  a=$1
  b=$2
  alog=$(echo $a | tr '/' '-').log
  blog=$(echo $b | tr '/' '-').log
  git log --oneline --pretty=format:%H,%s $a > $alog
  git log --oneline --pretty=format:%H,%s $b > $blog
  regex='(HADOOP|HDFS|YARN|HDDS|MAPREDUCE)-[[:digit:]]*'
  
  while IFS= read -r line
  do
   echo "$line"
   if [[ $line =~ $regex ]]; then  jira=${BASH_REMATCH}; fi
   echo "jira= $jira"
  
   if ! grep -q $jira "$alog"; then
    
    if grep -q "Revert.*$jira" "$blog"; then
     echo "$jira,$line" >> reverted-jiras.csv
    else
     echo "$jira,$line" >> missing-jiras.csv
    fi
   fi
  done < "$blog"
else
 echo 'Missing required parameters:Ex ./gitcompare.sh <branch-1> <branch-2>'
fi
