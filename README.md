# internyet\_proxy
#### "Takes care of mTLS, you do the rest"


## Introduction
Slap this proxy in front of your web server and let it handles HTTPS and
client certificate authentication. Provides the client's/participant's
alias in the HTTP header "X-Internyet-Client-Alias" - could be useful,
albeit a bit fragile.
  
For building instructions, have a look at the Dockerfile.  
  
Based on [certainly](https://github.com/Doctor-love/certainly), but
slightly adapted for internyet.party. If you're not at the party,
it makes little sense using it.


## Example usage
```
$ sudo setcap cap_net_bind_service=ep internyet_proxy
$ ./internyet_proxy \
	-target-url 'http://127.0.0.1:1984' \
	-server-address ':443' \
	-server-cert '/home/haxor/x509/server.crt' \
	-server-key '/home/haxor/x509/server.ke7' \
	-client-ca '/home/haxor/x509/ca.crt' \
	-add-hsts
```

```
$ cat configuration.sh

export INPR_ADD_HSTS=true
export INPR_SERVER_ADDRESS=:8443
export INPR_SERVER_CERT=/home/haxor/x509/server.crt
[...]

$ source configuration.sh
$ internyet_proxy -env
```

```
$ docker build -t internyet_proxy:latest .
$ docker run --rm --publish 443:8443 \
	--env-file /etc/internyet_proxy/conf.env \
	--volume /etc/internyet_proxy/x509:/data:ro \
	internyet_proxy:latest 
```
