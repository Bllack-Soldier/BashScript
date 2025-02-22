#!/bin/bash
trap '' INT
shadow=/opt/passhash
recover_shadow=/opt/recovery_passhash
read_hash=$(cat $shadow)
read_recovery_hash=$(cat $recover_shadow)
make_hashed_pass()
{
	echo "$1" | sha256sum | awk '{print $1}'
}

prompt_pass()
{
	read -s -p "Enter Second Password: " password
	
	echo "$(make_hashed_pass "$password")"
	
}

prompt_recovery_pass()
{
        read -s -p "Enter Recovery Password: " rpassword

        echo "$(make_hashed_pass "$rpassword")"

}

attempts=3

while [ $attempts -gt 0 ];
do	
	entered_pass=$(prompt_pass)
	if [ "$read_hash" == "$entered_pass" ];
	then
		echo "Welcome $USER"
		exec /bin/bash
	else
		((attempts--))
		echo "you have $attempts attempt(s) left. "
		sleep 1
	fi
done
recovery_attempts=2
while [ $recovery_attempts -gt 0 ];
do
	echo "You Entered To recovery Mode.Please Enter Your Recovery Password"
        entered_pass=$(prompt_recovery_pass)
        if [ "$read_recovery_hash" == "$entered_pass" ];
        then
                echo "Welcome $USER make sure to change your 2f password!"
                exec /bin/bash
        else
                ((recovery_attempts--))
                echo "you have $recovery_attempts recovery attempt(s) left. "
                sleep 1
        fi
done
echo "your all attempts failed. Access Denied"
sleep 2d
trap '' INT