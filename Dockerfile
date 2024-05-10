FROM openjdk:17 as builder
WORKDIR /workspace
ADD jarstaging/com/valaxy/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrend.jar 


FROM openjdk:17-jre-slim
COPY --from=builder /workspace/ttrend.jar ttrend.jar
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]

