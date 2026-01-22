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

# $0 <wiki-url> <username> <password>
function mw-login(){
  API_URL="api.php"
  curl -fsSL -X POST \
  --data-urlencode action=login \
  -d lgname="$2" \
  -d lgpassword="$3" \
  --data-urlencode lgtoken=$(get-token login) \
  -d format=json  \
  -c cookie.txt \
  -b cookie.txt \
  "${1}${API_URL}"
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

function plain-import(){
  page_name="$1"
  content_file="$2"
  page_content="$(cat $content_file)"
  echo "+++ writting page $page_name +++"
  API_URL="api.php?action=edit&format=json"
  curl -fsSL -X POST \
  -d "summary=$BOT_INFO $MW_PREF" \
  -d "title=$page_name" \
  --data-urlencode "text=${page_content}" \
  -d "bot=true" \
  --data-urlencode "token=$(get-token csrf)" \
  -c cookie.txt \
  -b cookie.txt \
  "${MW_URL}${API_URL}"
  echo
}


function xml-import(){
  xml_file="$1"
  API_URL="api.php?action=import&format=json"
  curl -fsSL -X POST \
  -F "xml=@${xml_file}" \
  -F "summary=$BOT_INFO $MW_PREF" \
  -F "assignknownusers=1" \
  -F "interwikiprefix=imported" \
  -F "token=$(get-token csrf)" \
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
  "${SRC_URL}${API_URL}"
}

# $0 <page-name>
function export-plain(){
  page_name="$1"
  API_URL="api.php?action=parse&page=${page_name}&prop=wikitext&format=json"
  RESULT=$(curl -fsSL -X GET \
  -c cookie.txt \
  -b cookie.txt \
  "${SRC_URL}${API_URL}")
  RESULT=$(jq -r ".parse.wikitext.\"*\"" <<< "$RESULT")
  echo "$RESULT"
}
