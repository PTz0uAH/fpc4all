# Assorted Webassembly utility routine demos

For the Timer, HTTP and Websocket demos, you need also the corresponding host application
which will load the demo and provide the needed APIs.

They are contained in the Pas2JS demos under 
```
demos/wasienv/timer
```
for the timer host, the http host is located under
```
demos/wasienv/wasm-http 
```
and the websocket host is in
```
demos/wasienv/wasm-websocket
```

respectively.

For the websocket demo, additionally the websocket server program in
```
packages/fcl-web/examples/websocket/server
```
is needed, since this is the websocket server that the demo program will
connect to.

For the regexp demo, you need the corresponding pas2js host program
```
demos/wasienv/regexp
```