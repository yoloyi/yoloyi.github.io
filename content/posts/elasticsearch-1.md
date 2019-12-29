---
title: "ElasticSearch Api 使用"
date: 2019-12-13T00:00:00+08:00
draft: false
description: ""
show_in_homepage: true
show_description: true
license: ''

tags: ["ElasticSearch"]
categories: ["ElasticSearch"]

featured_image: ''
featured_image_preview: ''

comment: true
toc: true
autoCollapseToc: true
math: false
---


# 使用 ElasticSearch Api

ElasticSearch API 遵守 [Restful](http://www.ruanyifeng.com/blog/2014/05/restful_api.html) 标准

| 请求方式 | 解释 |
| --- | --- |
| GET | 查询数据 |
| POST | 新增数据 |
| PUT | 修改数据 |
| DELETE | 删除数据 |

## 1、新增数据

```bash
curl -X POST "localhost:9200/customer/_doc?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe"
}'
```
`pretty` 参数作用是美化返回参数

*返回结果*
```javascript
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "J1c2PW8BlcDBxKe0QGUz", // 这个 ID 会变化。ES UUID
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 9,
  "_primary_term" : 1
}
```

## 2、查询一条数据 

```bash
curl -X GET "localhost:9200/customer/_doc/J1c2PW8BlcDBxKe0QGUz?pretty"
```
*返回结果*
```bash
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "J1c2PW8BlcDBxKe0QGUz",
  "_version" : 2,
  "_seq_no" : 10,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "John Doe"
  }
}
```

## 3、修改数据

```bash
$ curl -X PUT "localhost:9200/customer/_doc/J1c2PW8BlcDBxKe0QGUz?pretty" -H 'Content-Type: application/json' -d'
{
  "name": "John Doe"
}
'
```

*返回参数*
```javascript
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 2,
    "failed" : 0
  },
  "_seq_no" : 26,
  "_primary_term" : 4
}
```

使用 2 中查询一次试试

`PUT 有一个巧妙的操作，当这个 ID 不存在的时候，他会创建一条新的，result 为created，当 ID 存在则为修改 updated。但是 PUT 要指定 ID 或者指定其他的`

## 4、删除数据

```bash
$ curl -X DELETE "localhost:9200/customer/_doc/1?pretty"
```
*返回参数*
```javascript
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 9,
  "result" : "deleted",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 11,
  "_primary_term" : 1
}
```
删除成功


## 5、批量插入

```bash
$ curl -H "Content-Type: application/json" -X POST "localhost:9200/bank/_bulk?pretty&refresh" -d '
{"index":{"_id":"1"}}
{"name": "John Doe" }
{"index":{"_id":"2"}}
{"name": "Jane Doe" }'
```

也可以批量删除 和批量更新一起使用

```bash
curl -H 'Content-type:application/json' -X POST 'localhost:9200/bank/_bulk?pretty&refresh' -d '
{ "update": { "_id": "1" }}
{"doc": { "name": "John Doe becomes Doe" }}
{ "delete": { "_id": "2"}}'
```

refresh 创建一个文档并立即刷新索引

这里有一个很有意思关于 ES 的事情

ES的索引数据是写入到磁盘上的。但这个过程是分阶段实现的，因为IO的操作是比较费时的。

1、先写到内存中，此时不可搜索

2、默认经过 1s 之后会被写入 lucene 的底层文件。segment 中 ，此时可以搜索到

3、refresh 之后才会写入磁盘
