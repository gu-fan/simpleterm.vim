echo 1
echo 2
echo 3
echo 4
echo 5

ps aux | grep vim

NUM1=2
NUM2=2
if [ $NUM1 -eq $NUM2 ]; then
	echo "Both Values are equal"
else 
	echo "Values are NOT equal"
fi 

# use Scd to change dir
cat ./data.json
