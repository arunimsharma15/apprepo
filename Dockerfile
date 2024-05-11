FROM openjdk:17
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot
USER nonroot
ADD jarstaging/com/valaxy/demo-workshop/2.1.3/demo-workshop-2.1.3.jar ttrend.jar 
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]