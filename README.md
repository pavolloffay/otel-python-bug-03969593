# OpenTelemetry Python instrumentation bug

Reproducer for https://github.com/open-telemetry/opentelemetry-python-contrib/issues/3059

## Steps to reproduce locally

### Run collector
```bash
docker run --rm -it -v $(pwd)/:/tmp:Z --net=host ghcr.io/open-telemetry/opentelemetry-collector-releases/opentelemetry-collector:0.114.0 --config=/tmp/local-collector.yaml
...
Emulate Docker CLI using podman. Create /etc/containers/nodocker to quiet msg.
2024-12-02T13:02:45.798Z	info	service@v0.114.0/service.go:166	Setting up own telemetry...
2024-12-02T13:02:45.798Z	warn	service@v0.114.0/service.go:221	service::telemetry::metrics::address is being deprecated in favor of service::telemetry::metrics::readers
2024-12-02T13:02:45.798Z	info	telemetry/metrics.go:70	Serving metrics	{"address": "0.0.0.0:8888", "metrics level": "Normal"}
2024-12-02T13:02:45.798Z	info	builders/builders.go:26	Development component. May change in the future.	{"kind": "exporter", "data_type": "traces", "name": "debug"}
2024-12-02T13:02:45.799Z	info	service@v0.114.0/service.go:238	Starting otelcol...	{"Version": "0.114.0", "NumCPU": 16}
2024-12-02T13:02:45.799Z	info	extensions/extensions.go:39	Starting extensions...
2024-12-02T13:02:45.800Z	info	otlpreceiver@v0.114.0/otlp.go:112	Starting GRPC server	{"kind": "receiver", "name": "otlp", "data_type": "traces", "endpoint": "localhost:4317"}
2024-12-02T13:02:45.800Z	info	otlpreceiver@v0.114.0/otlp.go:169	Starting HTTP server	{"kind": "receiver", "name": "otlp", "data_type": "traces", "endpoint": "localhost:4318"}
2024-12-02T13:02:45.800Z	info	service@v0.114.0/service.go:261	Everything is ready. Begin running and processing data.
```

### Run the application
```bash
pip install opentelemetry-distro opentelemetry-exporter-otlp
~/.local/bin/opentelemetry-bootstrap -a install
~/.local/bin/opentelemetry-instrument  --service_name python-example  --exporter_otlp_endpoint localhost:4317 --traces_exporter console,otlp --metrics_exporter console python helloworld.py
...
Starting httpd server on port 8080
127.0.0.1 - - [02/Dec/2024 13:59:40] "GET / HTTP/1.1" 200 -
127.0.0.1 - - [02/Dec/2024 13:59:40] "GET / HTTP/1.1" 200 -
```


Open browser and navigate to http://localhost:8080. A trace does not appear in the collector logs nor error is logged in the application.