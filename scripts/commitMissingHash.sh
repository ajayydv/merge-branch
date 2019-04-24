#! /bin/bash
if ((1==$#)); then
  file1=$1
  regex=',[a-zA-Z0-9]*,'
  failed=0
  success=0
  total=0
 while IFS= read -r line
  do
  ((total++))
   if [[ $line =~ $regex ]]; then  
    hash=${BASH_REMATCH[0]}
    hash=${hash//','/}
    git cherry-pick $hash
    if [ $? -eq 0 ]; then
     echo "$hash cherry-picked."
     echo $hash >> cherryPicked.txt
     ((success++))
    else
     echo "$hash cherry-picked failed.Aborting."
     echo $hash >> cherryPickedFailed.txt
     exit 1 
     ((failed++))
    fi
   fi
  done < "$file1"
  echo "Total commits: $total, success:$success, failed:$failed"
else
 echo 'File containting git commits is required parameter'
fi
