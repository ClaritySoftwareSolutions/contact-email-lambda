# Generate a version number based on a date timestamp so that it's unique
TIMESTAMP=$(date +%Y%m%d%H%M%S)

rm -fr ./dist && \

cd ./lambda/ && \
# Run the npm commands to transpile the TypeScript to JavaScript
npm i && \
npm run build && \
npm prune --production && \

cd ../dist && \

zip -r lambda_function_"$TIMESTAMP".zip ../lambda/node_modules . && \

cd ../terraform/src && \
terraform plan -input=false -var lambdaVersion="$TIMESTAMP" -out=./tfplan && \
terraform apply -input=false ./tfplan

