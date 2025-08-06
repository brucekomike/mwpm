# $0 <token type>
# mainly csrf and login
function get-token(){
API_URL="api.php"
RESULT=$(curl -fsSL -X POST \
 -d action=query \
 -d meta=tokens \
 -d type="$1" \
 -d format=json  \
 -c cookie.txt \
 -b cookie.txt \
 "${MW_URL}${API_URL}")
#RESULT=${RESULT/*token\":\"}
#TOKEN=${RESULT%\\\"*}
TOKEN=$(jq -r ".query.tokens[\"${1}token\"]" <<< "$RESULT")
echo "$TOKEN"
}

function mw-login(){
  API_URL="api.php"
  curl -fsSL -X POST \
  --data-urlencode action=login \
  -d lgname="$MW_USER" \
  -d lgpassword="$MW_PASS" \
  --data-urlencode lgtoken=$(get-token login) \
  -d format=json  \
  -c cookie.txt \
  -b cookie.txt \
  "${MW_URL}${API_URL}"
}

# $0 <page-names>
# return the full json result
# xml is in .query.export."*"
function export-xml(){
  API_URL="api.php?action=query&format=json"
  curl -fsSL -X POST \
  -d "titles=$1" \
  -d "export" \
  -c cookie.txt \
  -b cookie.txt \
  "${MW_URL}${API_URL}"
}

# $0 <page-name>
function inter-import(){
  page_name="$1"
  API_URL="api.php?action=import&format=json"
  curl -fsSL -X POST \
  -d "summary=$BOT_INFO $MW_PREF" \
  -d interwikisource=$MW_PREF \
  -d "interwikipage=$1" \
  -d "assignknownusers=1" \
  -d "templates=1" \
  --data-urlencode "token=$(get-token csrf)" \
  -c cookie.txt \
  -b cookie.txt \
  "${MW_URL}${API_URL}"
}

function xml-import(){
  page_name="$1"
  API_URL="api.php?action=import&format=json"
  curl -fsSL -X POST \
  -d "summary=$BOT_INFO $MW_PREF" \
  -d "assignknownusers=1" \
  -d "templates=1" \
  --data-urlencode "token=$(get-token csrf)" \
  -c cookie.txt \
  -b cookie.txt \
  "${MW_URL}${API_URL}"
}

# $0 <file> <command>
# every line is in the $trimmed_line variable
function batch-process(){
while IFS= read -r line; do
    trimmed_line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    if [[ -z "$trimmed_line" ]]; then
        continue
    fi
    if [[ "$trimmed_line" =~ ^# ]]; then
        continue
    fi
    eval $2
done < "$1"
}