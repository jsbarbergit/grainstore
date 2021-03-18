#!/usr/bin/env bash
BUCKET=grainstore-ui.jsbarber.net
pushd app/grainstore-ui
npm run build
sed -i 's/Web site created using create-react-app/Grainstore UI/g' build/index.html
sed -i 's/Web site created using create-react-app/Grainstore UI/g' build/404.html
aws s3 sync build/ s3://${BUCKET}/ --acl private
result = $?
popd

exit $result