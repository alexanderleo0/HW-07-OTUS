MODULE="Modules/Networking"

openapi-generator generate -i "NewsAPI.yml" -g swift5 -o "api-mobile" --additional-properties=responseAs=AsyncAwait

rm -r $MODULE""*

cp -R "api-mobile/OpenAPIClient/Classes/OpenAPIs/". $MODULE

rm -r "api-mobile"
