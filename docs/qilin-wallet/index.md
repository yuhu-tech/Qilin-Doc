# Qilin-Wallet 钱包服务

## 一、设计概述

钱包服务提供链服生态中密钥托管、代理签名的基础服务，不是独立的业务产品，是链服平台中交易服务所依赖的一项服务，此服务对数据的安全性要求很高。

### 功能概述

系统主要功能包括：

- 密钥托管钱包创建
- 非密钥托管钱包创建
- 非密钥托管钱包导入
- 密钥托管钱包代理签名

使⽤者包括：

- 链服生态内所有涉及到区块链的业务平台
- 链服内部的交易服务
- 需要托管钱包的外部系统

### ⾮功能约束

……系统未来预计⼀年⽤户量达到……， ⽇订单量达到……， ⽇PV达到……， 图⽚数量达到 ……。

1. 查询性能⽬标：平均响应时间<300ms，95%响应时间<500ms，单机TPS>100； 2. 下单性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

3. ……性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

4. 系统核⼼功能可⽤性⽬标：>99.97%；

5. 系统安全性⽬标：系统可拦截…… 、……、……攻击， 密码数据散列加密， 客户端数据 HTTPS加密，外部系统间通信对称加密；

6. 数据持久化⽬标：>99.99999%。


## 二、聚合层接口文档

### 1. 创建钱包

接口描述：创建钱包

接口地址：http://119.3.106.151:10100/v1/app/wallets/create

请求类型：POST

请求参数：

|编号|名称|类型|是否必须|描述|  
|-----|-----|-----|-----|-----|  
|1|sign_user_id|string|是|钱包所有者（一般使用调用方业务系统中的用户id）|  
|2|tenant_id|string|是|用户的租户id|  
|3|chain_instance_id|string|是|链实例id|  

响应参数：

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|sign_user_id|string|钱包所有者|  
|2|wallet_id|string|钱包id|  
|3|address|string|钱包地址|  
|4|chain_instance_id|string|链实例id|  

请求示例：

```bash
curl -X POST "http://119.3.106.151:10100/v1/app/wallets/create" \
  -H "accept: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc5MDM0NjMsImlhdCI6MTYyNzg5NjI2MywianRpIjoiMXJybDc5Mm5xMG5wNDMiLCJzdWIiOiJ1aWQtdGVuYW50In0.tAZCBRhRJGWeYqriBnptg2lLOHceF48jefb_LK1GMIUdTT5ZK83lGUqMNKxscWNHr-k0K9qAepQIZbP-hS3VKA" \
  -H "Content-Type: application/json" \
  -d "{ \"sign_user_id\": \"test_user\", \"tenant_id\": \"tid-yuhu1\", \"chain_instance_id\": \"1\"}"
```

```json
{
  "sign_user_id": "test_user",
  "tenant_id": "tid-yuhu1",
  "chain_instance_id": "1"
}
```

响应示例：
```json
{
  "sign_user_id": "test_user",
  "wallet_id": "wid-xpyNMwgJZ2OB",
  "address": "0xF1830638B3670ddb00C58881100B87C54A275747",
  "chain_instance_id": "1"
}
```

### 2. 导入私钥创建钱包

接口描述：导入私钥创建钱包

接口地址：http://119.3.106.151:10100/v1/app/wallets/import

请求类型：POST 

请求参数：

|编号|名称|类型|是否必须|描述|
|-----|-----|-----|-----|-----|
|1|sign_user_id|string|是|钱包所有者|  
|2|tenant_id|string|是|用户的租户id|  
|3|pk|string|是|私钥|
|4|chain_instance_id|string|是|链实例id|  

响应参数：

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|sign_user_id|string|钱包所有者|  
|2|wallet_id|string|钱包id|  
|3|address|string|钱包地址|  
|4|chain_instance_id|string|链实例id|  


请求示例：
```bash
curl -X POST "http://119.3.106.151:10100/v1/app/wallets/import" \
  -H "accept: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc5MDM0NjMsImlhdCI6MTYyNzg5NjI2MywianRpIjoiMXJybDc5Mm5xMG5wNDMiLCJzdWIiOiJ1aWQtdGVuYW50In0.tAZCBRhRJGWeYqriBnptg2lLOHceF48jefb_LK1GMIUdTT5ZK83lGUqMNKxscWNHr-k0K9qAepQIZbP-hS3VKA" \
  -H "Content-Type: application/json" \
  -d "{ \"sign_user_id\": \"test-user\", \"tenant_id\": \"tid-yuhu1\", \"pk\": \"b158a6a4b55f475940773f99c1dc04bd61aafd0c51c9cc18de429602d4f0f174\", \"chain_instance_id\": \"1\"}"
```

```json
{
  "sign_user_id": "test-user",
  "tenant_id": "tid-yuhu1",
  "pk": "b158a6a4b55f475940773f99c1dc04bd61aafd0c51c9cc18de429602d4f0f174",
  "chain_instance_id": "1"
}
```

响应示例：
```json
{
  "sign_user_id": "test-user",
  "wallet_id": "wid-oKO3Q1nwp2zJ",
  "address": "0x9131C3B95171AD9027dC15ca7A8f2B36B78366ad",
  "chain_instance_id": "1"
}
```
