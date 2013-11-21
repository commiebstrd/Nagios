#!/bin/bash

while getopts "h:help:wl:warning-low:wh:warning-high:cl:critical-low:ch:critical-high" OPTION; do
        case $OPTION in
                wl|warning-low)
                        WL=$OPTARG
                        ;;
                cl|critical-low)
                        CL=$OPTARG
                        ;;
                wh|warning-high)
                        WH=$OPTARG
                        ;;
                ch|critical-high)
                        CH=$OPTARG
                        ;;
        esac
done


PRICE=$(wget -O - --no-check-certificate https://coinbase.com/ 2> /dev/null | grep 'Current Buy Price:' | sed 's/\s*<a href=\"\/charts\">\s*Current Buy Price:\s\$//' | sed 's/<\/a>//')

#not working yet
#If CL set and $price lower than CL
# if [[ -n "$CL" ]]; then
        # if [[ $CL -gt $PRICE ]]; then
                # echo "Critical low price - Current Price: $"$PRICE" | Price="$PRICE
                # exit 2
        # fi
#else if wl set and $price lower than WL
# elif [[ -n "$WL" ]]; then
        # if [[ $WL -gt $PRICE ]]; then
                # echo "Warning Low Price - Current Price: $"$PRICE" | Price="$PRICE
                # exit 1
        # fi
#else if CH set and $price is higher tahn CH
# elif [[ -n "$CH" ]]; then
        # if [[ $CH -lt $PRICE ]]; then
                # echo "Critical high price - Current Price: $"$PRICE" | Price="$PRICE
                # exit 2
        # fi
#else if WH set and $price is higher than WH
# elif [[ -n "$WH" ]]; then
        # if [[ $WH -lt $PRICE ]]; then
                # echo "Warning high price - Current Price: $"$PRICE" | Price="$PRICE
        # fi
#else must be within ranges or no range set
# else
        echo "Current Price: $"$PRICE" | Price="$PRICE
        exit 0
#fi
