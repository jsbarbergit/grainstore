pushd app/grainstore-ui
npm run build
popd
git subtree push --prefix app/grainstore-ui/build/ origin gh-pages