```python
>>> import codecs, grpc, os
>>> # Generate the following 2 modules by compiling the {{ rpcdir }}/{{ method.fileName }} with the grpcio-tools.
>>> import {{ method.stubFileName }}_pb2 as {{ method.packageName }}, {{ method.stubFileName }}_pb2_grpc as {{ method.stubFileName }}stub{% if method.service != 'Unlocker' %}
>>> macaroon = codecs.encode(open('/path/to/admin.macaroon', 'rb').read(), 'hex'){% endif %}
>>> os.environ['GRPC_SSL_CIPHER_SUITES'] = 'HIGH+ECDSA'
>>> cert = open('/path/to/tls.cert', 'rb').read()
>>> ssl_creds = grpc.ssl_channel_credentials(cert)
>>> channel = grpc.secure_channel('{{ sssocip }}:{{ grpcport }}', ssl_creds)
>>> stub = {{ method.stubFileName }}stub.{{ method.service }}Stub(channel){% if method.streamingRequest %}
{% include 'python/streaming_request.html' %}{% else %}
{% include 'python/simple_request.html' %}{% endif %}{% if method.streamingResponse %}
{% include 'python/streaming_response.html' %}{% else %}
{% include 'python/simple_response.html' %}{% endif %}
{ {% for param in method.responseMessage.params %}
    "{{ param.name }}": <{{ param.type }}>,{% endfor %}
}
```
