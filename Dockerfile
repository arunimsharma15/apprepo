FROM openjdk:17
ARG version
RUN groupadd -r nonroot && useradd -r -g nonroot nonroot
USER nonroot
ADD jarstaging/com/valaxy/demo-workshop/${version}/demo-workshop-${version}.jar ttrend.jar 
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]