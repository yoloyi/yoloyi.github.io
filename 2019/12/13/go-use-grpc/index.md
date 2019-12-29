# Go语言 简单实用 GRP


# Golang Grpc 例子

[GitHub源码地址](https://github.com/yoloyi/go-exercise-example) 
## 如何运行 helloworld 例子
### helloworld
1、`$ git clone git@github.com:yoloyi/go-exercise-example.git`

2、`$ cd /go-exercise-example/grpc`

3、`$ go install`

4、`$ go run helloworld/cmd/service/main.go`

5、`$ go run helloworld/cmd/client/main.go world`



## 例子学习

> protoc 是 Protocol Buffers 的一个工具，负责生成协议的序列化、反序列化相应语言的代码


1、下载 protoc
```bash
https://github.com/protocolbuffers/protobuf/releases
```
选择对应的本机的环境，下载相应的 `protoc`

2、把bin/protoc 移动到 PATH 目录下

```bash
mv bin/protoc /usr/local/bin
```

3、检查 `protoc` 是否正确移动
```bash
which protoc
```

## Golang 

1、安装 grpc 

```bash
go get -u google.golang.org/grpc
```

2、安装 protoc 插件 protoc-gen-go

```
go get -u github.com/golang/protobuf/protoc-gen-go
```
3、检查 `GOBIN` 是否设置，以及 `GOBIN` 是否加入到 PATH 里面


## 如何使用 `protoc`

```bash
Usage: protoc [OPTION] PROTO_FILES
Parse PROTO_FILES and generate output based on the options given:
  -IPATH, --proto_path=PATH   Specify the directory in which to search for
                              imports.  May be specified multiple times;
                              directories will be searched in order.  If not
                              given, the current working directory is used.
                              If not found in any of the these directories,
                              the --descriptor_set_in descriptors will be
                              checked for required proto file.
  --version                   Show version info and exit.
  -h, --help                  Show this text and exit.
  --encode=MESSAGE_TYPE       Read a text-format message of the given type
                              from standard input and write it in binary
                              to standard output.  The message type must
                              be defined in PROTO_FILES or their imports.
  --decode=MESSAGE_TYPE       Read a binary message of the given type from
                              standard input and write it in text format
                              to standard output.  The message type must
                              be defined in PROTO_FILES or their imports.
  --decode_raw                Read an arbitrary protocol message from
                              standard input and write the raw tag/value
                              pairs in text format to standard output.  No
                              PROTO_FILES should be given when using this
                              flag.
  --descriptor_set_in=FILES   Specifies a delimited list of FILES
                              each containing a FileDescriptorSet (a
                              protocol buffer defined in descriptor.proto).
                              The FileDescriptor for each of the PROTO_FILES
                              provided will be loaded from these
                              FileDescriptorSets. If a FileDescriptor
                              appears multiple times, the first occurrence
                              will be used.
  -oFILE,                     Writes a FileDescriptorSet (a protocol buffer,
    --descriptor_set_out=FILE defined in descriptor.proto) containing all of
                              the input files to FILE.
  --include_imports           When using --descriptor_set_out, also include
                              all dependencies of the input files in the
                              set, so that the set is self-contained.
  --include_source_info       When using --descriptor_set_out, do not strip
                              SourceCodeInfo from the FileDescriptorProto.
                              This results in vastly larger descriptors that
                              include information about the original
                              location of each decl in the source file as
                              well as surrounding comments.
  --dependency_out=FILE       Write a dependency output file in the format
                              expected by make. This writes the transitive
                              set of input file paths to FILE
  --error_format=FORMAT       Set the format in which to print errors.
                              FORMAT may be 'gcc' (the default) or 'msvs'
                              (Microsoft Visual Studio format).
  --print_free_field_numbers  Print the free field numbers of the messages
                              defined in the given proto files. Groups share
                              the same field number space with the parent 
                              message. Extension ranges are counted as 
                              occupied fields numbers.

  --plugin=EXECUTABLE         Specifies a plugin executable to use.
                              Normally, protoc searches the PATH for
                              plugins, but you may specify additional
                              executables not in the path using this flag.
                              Additionally, EXECUTABLE may be of the form
                              NAME=PATH, in which case the given plugin name
                              is mapped to the given executable even if
                              the executable's own name differs.
  --cpp_out=OUT_DIR           Generate C++ header and source.
  --csharp_out=OUT_DIR        Generate C# source file.
  --java_out=OUT_DIR          Generate Java source file.
  --js_out=OUT_DIR            Generate JavaScript source.
  --objc_out=OUT_DIR          Generate Objective C header and source.
  --php_out=OUT_DIR           Generate PHP source file.
  --python_out=OUT_DIR        Generate Python source file.
  --ruby_out=OUT_DIR          Generate Ruby source file.
  @<filename>                 Read options and filenames from file. If a
                              relative file path is specified, the file
                              will be searched in the working directory.
                              The --proto_path option will not affect how
                              this argument file is searched. Content of
                              the file will be expanded in the position of
                              @<filename> as in the argument list. Note
                              that shell expansion is not applied to the
                              content of the file (i.e., you cannot use
                              quotes, wildcards, escapes, commands, etc.).
                              Each line corresponds to a single argument,
                              even if it contains spaces.

```

```bash
protoc --go_out=. {PROTO_DIR} 
```

使用例子

```bash
protoc -I proto --go_out=plugins=grpc:./helloworld/proto helloworld.proto
// -I 类似于 WORK_DIR，工作目录，proto 文件 去哪个文件里面找
// --go_out 这个是 protoc-gen-go 的扩展，原本 protoc 里面是没有 go 的代码生成，我们需要安装这个插件
// 后面接文件名字
```
## HelloWorld Grpc

1、新建 helloworld.proto

```proto
// proto 版本，有 2，3两个版本。必须写
syntax = "proto3"; 

package helloworld;
// 注册 grpc 的方法

service Greeter { 
    rpc SayHello (HelloRequest) returns (HelloReply);
}
// 请求参数
message HelloRequest {
    string name = 1;
}

// 返回参数
message HelloReply { 
    string message = 1;
}
```

2、使用命令 `protoc -I helloworld/proto --go_out=plugins=grpc:./helloworld/proto helloworld.proto` 自动生成 `.pb.go` 代码

3、编写 `Service` 端

```go

package main

import (
	"context"
	"fmt"
	"google.golang.org/grpc"
	"log"
	"net"
	pb "grpc/helloworld/proto"
)

const port = ":50051"

// 组合一个 server
type service struct {
	pb.UnimplementedGreeterServer
}

// grpc 重写的方法
// 如果不重写，会出现 error
func (s *service) SayHello(ctx context.Context, in *pb.HelloRequest) (*pb.HelloReply, error) {
	str := fmt.Sprintf("Hello %s", in.GetName())
	log.Println(str)
	return &pb.HelloReply{Message: str}, nil
}

func main() {
	fmt.Println("-------------------")
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalln(err)
	}

	s := grpc.NewServer()

	// 注册一个 grpc
	pb.RegisterGreeterServer(s, &service{})
	fmt.Println("Hello world GRpc start")
	// 等待阻塞
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve：%v", err)
	}

}


```

3、编写 `Client` 端

```go

package main

import (
	"fmt"
	"golang.org/x/net/context"
	"google.golang.org/grpc"
	"log"
	"os"
	pb "grpc/helloworld/proto"
	"time"
)

const (
	address     string = "localhost:50051"
	defaultName string = "world"
)

func main() {
	conn, err := grpc.Dial(address, grpc.WithInsecure()) // 判断 grpc service 是否活着

	// grpc.WithInsecure() 禁用传递安全型，
	if err != nil {
		log.Fatalln(err)
	}
	defer conn.Close()
	c := pb.NewGreeterClient(conn) // 创建一个 client，这里的client 是 protoc 生成的
	name := defaultName
	if len(os.Args) > 1 {
		name = os.Args[1]
	}
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	r, err := c.SayHello(ctx, &pb.HelloRequest{
		Name: name,
	}) // 调用Service 的 say hello 方法
	if err != nil {
		log.Fatalln(err)
	}
	fmt.Println("Get Rpc request message", r.GetMessage())
}
```

4、运行

首先我们要运行 service 使得 service 常驻。然后运行我们的 client 客户端就可以看到相应的返回结果。

```bash

$ go run helloworld/cmd/service/main.go

//out: -------------------
// Hello world GRpc start

```

起一个新的窗口
```bash
$ go run helloworld/cmd/client/main.go world

//out: Get Rpc request message Hello world

```
