# aTech Log Server

This simple service will run a centralised log server which can receive messages over UDP from
applications and store them in a file.

## Requirements

* You must have Ruby install on your host (1.8.7 or 1.9.3 are currently supported)
* An internet connection

## Installing & running the log server

```bash
git clone https://github.com/atech/log-server.git /opt/log-server
ln -s /opt/log-server/upstart.conf /etc/init/log-server.conf
start log-server
```

All logs by default are stored in `/opt/log-server/logs/app_name/log_name.log`. 

## Sending a log message to the server

The following code outlines how to send a message to the log server. You should replace `1.2.3.4` with
the IP address of your installed log server. 

```ruby
app_name  = 'sirportly'
log_name  = 'workers'
message   = "Hello there! This is a test of my log server..."
socket    = UDPSocket.new
data      = [app_name.bytesize, app_name, log_name.bytesize, log_name, message.bytesize, message, 0].pack('nA*nA*nA*n')
socket.send(data, 0, '1.2.3.4', 4455)
```
