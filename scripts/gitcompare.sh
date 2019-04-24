#! /bin/bash
if ((2==$#)); then
  a=$1
  b=$2
  alog=$(echo $a | tr '/' '-').log
  blog=$(echo $b | tr '/' '-').log
  git log --oneline --pretty=format:%H,%s --date-order --date-order --reverse  $a > $alog
  git log --oneline --pretty=format:%H,%s --date-order --date-order --reverse  $b > $blog
  regex='(HADOOP|HDFS)-[[:digit:]]*'
  jira=""

  while IFS= read -r line
  do
   echo "$line"
   if [[ $line =~ $regex ]]; then  jira=${BASH_REMATCH}; fi
   if [ "$jira" != "" ]; then 
    echo "jira= $jira"
    if ! grep -q $jira "$alog"; then
     if grep -q "Revert.*$jira" "$blog"; then
      echo "$jira,$line" >> reverted-jiras.csv
     else
      echo "$jira,$line" >> missing-jiras.csv
     fi
    fi
   fi
  jira=""
  done < "$blog"
else
 echo 'Missing required parameters:Ex ./gitcompare.sh <branch-1> <branch-2>'
fi
