if [ "$#" -ne 1 ]
then
  echo "Usage: $0 <file_name>"
else
  if [ ! -f $1 ]
  then
    echo "File not found!"
    echo "Usage: $0 <file_name>"
  else
    file_name=$1

    echo 'cleaning up old temp directory...'
    echo `rm -r temp/`

    echo 'creating new temp directory...'
    echo `mkdir temp`

    echo 'spliting file into smaller chunks...'
    split_command="cd temp; split -l 10000 ../$file_name ''; cd .."
    echo $split_command
    eval $split_command
    
    echo 'starting server...'
    FILE_NAME=$1 rackup -p 4000 config.ru
  fi
fi
