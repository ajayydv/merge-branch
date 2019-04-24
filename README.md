# merge-branch
Utility scripts to compare commits from two branch based on a regex. 

## Run comparision
scripts/gitcompare.sh <branch1> <branch2>

### Output files
missing-jiras.csv  : Missing jiras based on regex. Format (<regex output>,<commit hash>,<commit subject>) 
reverted-jiras.csv : Jiras with "Reverted" match in subject.
  
## Commit missing hash
### Run commits while aborting on conflicts.
scripts/commitMissingHash.sh missing-jiras.csv
### Run commits while ignoring commits with conflicts.
scripts/commitMissingHashIgnoringConflicts.sh missing-jiras.csv  

