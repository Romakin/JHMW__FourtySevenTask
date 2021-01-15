#!/bin/sh

rm -rf ./../integrationTest
rm -rf ./integrationTest

cp -r ./../FourtySevenTask ./../integrationTest
mv -v ./../integrationTest ./../FourtySevenTask
cd integrationTest
echo $PWD
rm ./scripts/BuildTestContainersMacOS.sh

cp ./src/test/java/com/example/demo/DemoApplicationTests.java ./src/test/java/com/example/demo/DemoApplicationTests.java_BACKUP
sed -i '' -e '3,13d;16,47d' ./src/test/java/com/example/demo/DemoApplicationTests.java


echo "<Building first container in regular mode..>"

cp ./pom.xml ./pom.xml_BACKUP
sed -i '' -e '38,43d;53,81d' ./pom.xml
echo "prepare properties"
cp ./src/main/resources/application.properties ./src/main/resources/application.properties_BACKUP
sed -i '' -e "1s/.*/netology.profile.dev=true/" \
    -e "2s/.*/server.port=8080/" ./src/main/resources/application.properties

./mvnw clean package
echo "prepare Dockerfile"
cp ./scripts/Dockerfile ./scripts/Dockerfile_BACKUP
sed -i '' -e '2s/.*/EXPOSE 8080/1' \
    -e '3s/\*jarName\*/demo-1\.0-SNAPSHOT/1' ./scripts/Dockerfile

mv ./target/demo-1.0-SNAPSHOT.jar ./scripts
cd scripts
if [[ "$(docker images -q devapp:latest 2> /dev/null)" != "" ]]; then
  docker rmi devapp:latest
fi
docker build -t devapp .
cd ..
rm ./scripts/demo-1.0-SNAPSHOT.jar

echo "</Container with name 'devapp' ready!>"

echo "<Building second container in dev mode..>"

sed -i '' -e "1s/.*/netology.profile.dev=false/" \
  -e "2s/.*/server.port=8081/" ./src/main/resources/application.properties

./mvnw clean package

sed -i '' -e '2s/.*/EXPOSE 8081/1' ./scripts/Dockerfile

mv ./target/demo-1.0-SNAPSHOT.jar ./scripts
cd scripts
if [[ "$(docker images -q prodapp:latest 2> /dev/null)" != "" ]]; then
  docker rmi prodapp:latest
fi
docker build -t prodapp .
cd ..
rm ./scripts/demo-1.0-SNAPSHOT.jar

echo "</Container with name 'prodapp' ready!>"

echo "Prepare Backups.."
rm -f ./pom.xml
mv ./pom.xml_BACKUP ./pom.xml
rm -f ./src/main/resources/application.properties
mv ./src/main/resources/application.properties_BACKUP ./src/main/resources/application.properties
rm -f ./scripts/Dockerfile
mv ./scripts/Dockerfile_BACKUP ./scripts/Dockerfile
rm -f ./src/test/java/com/example/demo/DemoApplicationTests.java
mv ./src/test/java/com/example/demo/DemoApplicationTests.java_BACKUP ./src/test/java/com/example/demo/DemoApplicationTests.java
echo "All done!"