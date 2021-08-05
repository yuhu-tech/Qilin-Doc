# 使用 Qilin 开发区块链应用

## 一、Open API 接入说明

### 概述
本手册将介绍如何使用`AK/SK`签名认证方式通过API网关调用`QILIN API`，并提供签名流程与实现逻辑;

目前只提供了 golang 调用事例，后续会提供 Java、Go、Python 等多种不同语言的签名SDK和调用示例。

### 获取 AK/SK
目前采用用企业合作，直接提供方式；后续将提供获取AK/SK的API

## 二、AK/SK 签名认证算法详解

### AK/SK 签名认证流程

客户端涉及的AK/SK签名以及请求发送的流程概述如下：

1. [构造规范请求](#构造规范的请求);
将待发送的请求内容按照与 `QILIN API` 后台约定的规则组装，确保客户端签名和后台认证时使用的请求内容一致。

1. [生成待签字符串](#生成待签字符串);
利用 `规范请求` 和 `其他信息` 生成待签字符串

3. [生成PrivateKey](#生成privatekey);
利用 `AK/SK` 和 `其他信息` 生成 PrivateKey

4. [计算签名](#计算签名);
利用 `待签字符串` 和 `PrivateKey` 计算签名

5. 将生成的 `签名` 作为请求消息头[添加到HTTP请求中](#添加签名到请求头)

说明：
主要用于帮助用户自行完成API请求的签名，后续提供的sdk将与本章节逻辑一致

### 讲解案例
接下来我们以如下 `POST` 请求为例子开始说明整个流程

**AK/SK:**
```
AK: 0uOQ9R01VCgRldX0couHypaCfOaATbU47787
SK: 4bkgnDuAllo0gxKZfTRprZl0j4CGb18EJ2j0
```

**请求数据:**
```
header:
    Authorization: YUHU1-HMAC-SHA256 Credential=0uOQ9R01VCgRldX0couHypaCfOaATbU47787/20210804/cn-shanghai-1/iam/yuhu1_request,Signature=签名
    x-yuhu-date: 20210804T141238Z

method: POST

url: http://consoletest.yuhu.tech/api/v1/app/evidences?b=sidebar&a=1

body:
{
    "skip": 1,
    "first": 2,
    "params": {
        "contract_address": "0x0",
        "tx_hash": "0x0",
        "to": "0x0"
    }
}
```

### 构造规范的请求

1. 规范消息头

消息头必须包含 `x-yuhu-date` 以及 `Authorization`，用于校验签名

| header        | 格式                                                   |
| ------------- | ------------------------------------------------------ |
| Authorization | YUHU1-HMAC-SHA256 Credential=ak/⽇期/区域/服务/结束标志,Signature=签名 |
| x-yuhu-date   | ISO8601标准(YYYYMMDDTHHMMSSZ)                          |

⚠️ `Authorization` 里的⽇期格式为 `YYYYMMDD`

例如
```
Authorization: YUHU1-HMAC-SHA256 Credential=0uOQ9R01VCgRldX0couHypaCfOaATbU47787/20210804/cn-shanghai-1/iam/yuhu1_request,Signature=eb8f0f7b050cda8c12045eb6565a42bfb22da6a956aceed7a1ff6bee28946ebf
x-yuhu-date: 20210804T141238Z
```

### 生成待签名符串
1. 获取 `Payload`

把URl和请求体中的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2...）拼接成字符串   `Payload`

特别注意以下重要规则：
- 参数名ASCII码从小到大排序（字典序）.
- 如果参数的值为空不参与签名.
- 参数名区分大小写.
- 若value本身仍然是一个结构体，将value序列化成一个字符串，需要保证该序列化的顺序（参数名ASCII码从小到大排序），再把整个字符串作为value参与签名.

按照[讲解案例](#讲解案例)中的数据，应获取 Payload 如下：
```go
payload=`{"skip":1,"first":2,"params":{"contract_address":"0x0","tx_hash":"0x0","to":"0x0"}}`
```

2. 生成待签数据

利用上一步获取的 `Payload` 与 `签名算法、签名时间` 一同生成待签名字符串
```
toSignedString=HMAC(HMAC(Algorithm,RequestDateTime),Payload)
```
上述伪码中各个参数含义如下：
- Algorithm

  签名算法，对于 SHA256 使用 `YUHU1-HMAC-SHA256`
- RequestDateTime

  请求时间，即请求头中的 `x-yuhu-date` (ISO8601标准 YYYYMMDDTHHMMSSZ)
- Payload

  请求数据，即上一步通过URL和Body获取的字符串

⚠️ 如果 Algorithm 采用 `YUHU1-HMAC-SHA256`， 那么 HMAC 也要使用 SHA256算法

按照[讲解案例](#讲解案例)中的数据，那么生成待签数据应为：
```
[123 146 29 7 166 122 37 73 121 220 154 166 84 154 207 249 124 223 195 102 244 205 4 222 205 77 248 109 22 27 78 178]
```

### 生成PrivateKey
通过 `请求头` 和 `SK` 获取 private_key
```
private_key=HMAC(HMAC(HMAC(HMAC(AlgorithmHeader + SK,Date),Area),Service),EndFlag)
```
上述伪码中各个参数含义如下：
- AlgorithmHeader

  对应 `YUHU1-HMAC-SHA256` 中的 `YUHU1`
- SK

  用户AK对应的签名私钥
- Date

  对应请求头 [Authorization](#构造规范的请求) 中的 `日期`（YYYYMMDD）
- Area

  对应请求头 [Authorization](#构造规范的请求) 中的 `区域`
- Service

  对应请求头 [Authorization](#构造规范的请求) 中的 `服务`
- EndFlag

  对应请求头 [Authorization](#构造规范的请求) 中的 `结束标志`

HMAC要求与[生成待签字符串](#生成待签字符串)中一致

按照[讲解案例](#讲解案例)中的数据(SK=4bkgnDuAllo0gxKZfTRprZl0j4CGb18EJ2j0)，那么生成的PrivateKey为：
```
[28 79 24 51 56 24 48 124 136 41 211 198 57 172 6 51 170 101 90 79 157 146 10 254 187 150 177 201 173 133 91 49]
```

### 计算签名

利用 `待签数据` 和 `PrivateKey` 进行签名

伪码如下：
```
signature = HexEncode(HMAC(private_key, to_be_sign_data))
```
将HMAC得到的签名，转为十六进制

按照[讲解案例](#讲解案例)中的数据， 最后签名应该为：
```
eb8f0f7b050cda8c12045eb6565a42bfb22da6a956aceed7a1ff6bee28946ebf
```

### 添加签名到请求头
将计算出来的 `signature` 添加到请求头 `Authorization` 的最后，使用 ',' 分割

按照[讲解案例](#讲解案例)中的数据，添加 `signature` 后，请求头为：

```
Authorization: YUHU1-HMAC-SHA256 Credential=0uOQ9R01VCgRldX0couHypaCfOaATbU47787/20210804/cn-shanghai-1/iam/yuhu1_request,Signature=eb8f0f7b050cda8c12045eb6565a42bfb22da6a956aceed7a1ff6bee28946ebf
```