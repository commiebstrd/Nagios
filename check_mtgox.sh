#!/bin/bash

SITE=$(wget -O - --no-check-certificate https://data.mtgox.com/api/2/BTCUSD/money/ticker 2> /dev/null)
HIGHPRICE=$(echo $SITE | sed 's/.*\"high\":{\"value\":\"//' | sed 's/\"\,\"value_int.*//')
LOWPRICE=$(echo $SITE | sed 's/.*\"low\":{\"value\":\"//' | sed 's/\"\,\"value_int.*//')
VOLUME=$(echo $SITE | sed 's/.*\"vol\":{\"value\":\"//' | sed 's/\"\,\"value_int.*//')
AVGPRICE=$(echo $SITE | sed 's/.*\"avg\":{\"value\":\"//' | sed 's/\"\,\"value_int.*//')
LASTPRICE=$(echo $SITE | sed 's/.*\"last\":{\"value\":\"//' | sed 's/\"\,\"value_int.*//')

echo "Current Price: $"$LASTPRICE" | High_Price="$HIGHPRICE" Average_Price="$AVGPRICE" Low_Price="$LOWPRICE" Last_Price="$LASTPRICE" Volume="$VOLUME
exit 0
