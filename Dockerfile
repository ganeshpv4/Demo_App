FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/real-time.war /app/
EXPOSE 8090
CMD ["java","-jar","real-time.war"]
