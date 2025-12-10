#!/bin/bash

login() {
    set +x

    PASSWORD="$1"
    PAYLOAD="{\"email\": \"moderador@email.com\", \"senha\": \"${PASSWORD}\"}"
    echo "Used PASSWORD: ${PASSWORD} ::: PAYLOAD: ${PAYLOAD}"

    curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "${BASE_ENDPOINT}"/auth
    echo ""
    echo "********************"
    echo ""
    wget -q -O - http://localhost:8081/actuator/prometheus | grep -E "(auth_user_error_total\{|auth_user_success_total\{)"

}

auth() {
    set +x

    if [ "$1" == "NO_AUTH" ];
    then
        AUTH_HEADER=""
    elif [ "$1" == "INVALID_AUTH" ];
    then
        AUTH_HEADER="Authorization: INVALID $API_AUTHORIZATION_TOKEN WRONG"
    elif [ "$1" == "IGNORE_AUTH" ];
    then
        AUTH_HEADER="Authorization: IGNORED $API_AUTHORIZATION_TOKEN"
    elif [ "$1" == "ERR_AUTH" ];
    then
        AUTH_HEADER="Authorization: Api-Key MY_CUSTOM_FAKE_TOKEN"
    else
        AUTH_HEADER="Authorization: Api-Key $API_AUTHORIZATION_TOKEN"
    fi
    URL="$BASE_ENDPOINT/protected_test_custom_auth/"
    echo "$URL -- $AUTH_HEADER"

    curl -i -X GET $URL -H "$AUTH_HEADER"
}

BASE_ENDPOINT="http://localhost:8081"

case $1 in
    "success") login 123456;;
    "errors") login 1234567;;
    "multiple")
        for (( i = 1; i <= $2; i++ ));
        do
            if (( RANDOM % 2 == 0 ));
            then
                echo "login SUCCESS"
                login 123456
                sleep 0.1
            else
                echo "login ERROR"
                login 1234567
                sleep 0.1
            fi
            echo ""
            echo "----- NEXT INTERATION -----"
            echo ""
        done
        echo "===== FINISHED MULTIPLE ====="
        ;;
    "auth") auth $2;;
    *) echo "USAGE: [login | auth | help]. $1 *NOT* found!!"
esac
