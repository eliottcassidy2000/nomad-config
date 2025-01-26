job "hello-world" {
  datacenters = ["dc1"]

  group "web" {
    count = 1

    network {
      mode = "bridge"
    }

    task "hello-world" {
      driver = "docker"

      config {
        image = "python:3.9-slim"
        command = "python3"
        args = ["-m", "http.server", "8088"]
      }

      resources {
        cpu    = 100 # MHz
        memory = 128 # MB
        network {
          port "http" {
            static = 8088
          }
        }
      }

      template {
        data = <<EOF
from http.server import BaseHTTPRequestHandler, HTTPServer

class HelloHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(b"Hello, world!")

if __name__ == "__main__":
    server = HTTPServer(("", 8088), HelloHandler)
    print("Starting server on port 8088")
    server.serve_forever()
EOF
        destination = "local/hello.py"
      }

      config {
        entrypoint = ["python3"]
        args       = ["/local/hello.py"]
      }
    }
  }
}