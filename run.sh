file_name=$1
echo `rm -r temp/`
echo `mkdir temp`
split_command="cd temp; split -l 10000 ../$file_name ''; cd .."
echo $split_command
eval $split_command
rackup config.ru
