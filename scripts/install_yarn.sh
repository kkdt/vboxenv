#!/bin/bash

echo "Install yarn"
curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
sudo yum -y install yarn

echo "Install packages"
yarn global add @angular/cli
yarn global add http-server
yarn global add connect
yarn global add serve-static
yarn global add react-native-cli
yarn global add expo-cli
