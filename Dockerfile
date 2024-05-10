# Use a builder image to build the JAR
FROM openjdk:17 as builder
WORKDIR /workspace
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrend.jar 

# Use a smaller, final image to run the app
FROM openjdk:17-jre-slim

# Create a group and user
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot

# Change to non-root user
USER nonroot

COPY --from=builder /workspace/ttrend.jar ttrend.jar
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]