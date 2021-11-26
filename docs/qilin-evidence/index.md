# Qilin-Evidence 可信存证服务平台

## 一、设计概述

可信存证服务平台是链服生态中由域乎官方提供的可信存证服务，底层使用的是域乎开放联盟链，是直接提供给外部机构使用的业务产品，承担着公司创收的⽬标任务。

### 业务流程

![存证业务流程](../../images/qilin/evidence/evid.png)

### 功能概述

系统主要功能包括：

- 文件（PDF等等）、文本（文字内容）、摘要（文件、文本的hash值）的上链存证

- 存证内容的核验

使⽤者包括：
- 直接使用存证服务的企业用户
- 进行系统对接的企业系统

### ⾮功能约束

……系统未来预计⼀年⽤户量达到……， ⽇订单量达到……， ⽇PV达到……， 图⽚数量达到 ……。

1. 查询性能⽬标：平均响应时间<300ms，95%响应时间<500ms，单机TPS>100； 2. 下单性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

3. ……性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

4. 系统核⼼功能可⽤性⽬标：>99.97%；

5. 系统安全性⽬标：系统可拦截…… 、……、……攻击， 密码数据散列加密， 客户端数据 HTTPS加密，外部系统间通信对称加密；

6. 数据持久化⽬标：>99.99999%。


## 二、聚合层接口文档

### 1.创建可信存证

接口描述：创建存证

接口地址：http://119.3.106.151:10100/v1/app/evidences

请求类型：POST 

请求参数：  

| 编号 | 名称 | 类型 | 是否必须 | 描述 |  
| --- | --- | --- | --- | --- |  
| 1   | tenant_id     | string | 是      | 用户的租户id |  
| 2   | title         | string | 是      | 若为文件存证，则此字段为文件名，否则为本次存证的标题 |  
| 3   | content       | byte   | 否      | 为文件存证或原文存证时必传，要求转为base64格式，摘要存证时不使用本参数 |  
| 4   | digest        | string | 否      | 摘要存证时必填 |  
| 5   | evidence_type | string | 是      | 存证类型，文件存证：file, 原文存证：text, 摘要存证：digest, 摘要存证：digest |  
| 6   | tsr           | bool   | 是      | 是否使用可信时间戳 |  

响应参数  

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|evidence_id|string|存证编号|  

请求实例：
```bash
curl -X POST "http://119.3.106.151:10100/v1/app/evidences" \
	-H "accept: application/json" \
	-H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjAwODUsImlhdCI6MTYyNzYxMjg4NSwianRpIjoicXd6bHczeTgyMDduN2wiLCJzdWIiOiJ1aWQtdGVuYW50In0.eNEuMd4A9IWC4tnFOHXIpgknde-Kgt3P_Hpipj9DtGl6kcXj_lhD07En1lXR-AQH1h5faAm9wNrBY50HvlV9Cw" \
	-H "Content-Type: application/json" \
	-d "{ \"tenant_id\": \"tid-yuhu1\", \"title\": \"evidence\", \"content\": \"ZXZpZGVuY2U=\", \"evidence_type\": \"text\", \"tsr\": true}"
```

```json
{
  "tenant_id": "tid-yuhu1",
  "title": "test-evidence",
  "content": "dGVzdC1ldmlkZW5jZQ==",
  "evidence_type": "text",
  "tsr": true
}
```

响应示例：
```json
{
  "evidence_id": "evid-testEvid"
}
```

### 2.获取存证列表

接口描述：获取我的存证列表

接口地址：http://119.3.106.151:10100/v1/app/evidences

请求类型：GET

请求参数：  

|编号|名称|类型|是否必须|描述|  
|-----|-----|-----|-----|-----|  
|1|limit|uint32|否|本次查询的限制数量，默认为10|  
|2|offset|uint32|否|本次查询的偏移量,默认为0|  
|3|sort_key|string|否|以什么字段排序,默认create_time|  
|4|reverse|bool|否|倒序还是正序|  
|5|tenant_id|uint32|是|用户的租户id|  
|6|evidence_ids|string|是|存证ids|  


响应参数 

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|evidences|array|存证数组|  
|1.1|evidence_id|string|存证编号|  
|1.2|txhash|string|存证交易哈希|  
|1.3|status|string|存证状态，交易已发送：builded, 成功：succeed，失败：failed|  
|1.4|title|string|存证标题，若为文件存证则为文件名|  
|1.5|push_time|timestamp|存证上链时间|
|1.6|digest|string|存证摘要|
|1.7|evid_type|string|存证类型|


请求示例：
```bash
curl -X GET "http://119.3.106.151:10100/v1/app/evidences?limit=10&offset=0&tenant_id=tid-yuhu1" \
	-H "accept: application/json" \
	-H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjAwODUsImlhdCI6MTYyNzYxMjg4NSwianRpIjoicXd6bHczeTgyMDduN2wiLCJzdWIiOiJ1aWQtdGVuYW50In0.eNEuMd4A9IWC4tnFOHXIpgknde-Kgt3P_Hpipj9DtGl6kcXj_lhD07En1lXR-AQH1h5faAm9wNrBY50HvlV9Cw"
```

响应示例：
```json
{
  "evidences": [
    {
      "evidence_id": "evid-testEvid",
      "txhash": "0x58f421bfc90ee6f2b9a3cfe54824dbb7d5b16df59cd972033147936cf86154f7",
      "status": "succeed",
      "title": "test-evidence",
      "push_time": "2021-07-27T08:09:07Z",
      "digest": "http://consoletest.yuhu.tech/data/evidence/12/5/12/evidence_rlV6yYx7JE8g",
	  "evid_type": "text"
    }
  ]
}
```

### 3.存证核验

接口描述：核验存证

接口地址：http://119.3.106.151:10100/v1/app/evidences:verify

请求类型：POST

请求参数：  

|编号|名称|类型|是否必须|描述|  
|-----|-----|-----|-----|-----|  
|1|txhash|string|是|存证的交易hash|  
|2|content|byte|否|存证内容，base64格式，为文件存证或原文存证时必传|  
|3|digest|string|否|存证摘要，为摘要存证时必传|  
|4|evidence_type|string|是|存证类型，文件存证：file, 原文存证：text, 摘要存证：digest|  

响应参数：  

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|verify_result|string|存证核验结果， 成功：succeed， 失败：failed|  
|2|push_time|timestamp|存证上链时间|  
|3|block_number|string|区块高度|
|4|block_hash|string|区块hash|
|5|txhash|string|交易hash|

请求示例：
```bash
curl -X POST "http://119.3.106.151:10100/v1/app/evidences:verify" \
	-H "accept: application/json" \
	-H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjA2MzQsImlhdCI6MTYyNzYxMzQzNCwianRpIjoiNDR6cDN4MDE0cG45bnoiLCJzdWIiOiJ1aWQtdGVuYW50In0.QLuUBa6oZQ1GjtzT4iXWc20CkRdG2AUTfeDfoM9mr8A--BIFRjHS11aRWynNAwr7O5bXNcg02GYMIHEWsyitVw" \
	-H "Content-Type: application/json" \
	-d "{ \"txhash\": \"0x58f421bfc90ee6f2b9a3cfe54824dbb7d5b16df59cd972033147936cf86154f7\", \"content\": \"dGVzdC1ldmlkZW5jZQ==\", \"evidence_type\": \"text\"}"
```

```json
{
  "txhash": "0x58f421bfc90ee6f2b9a3cfe54824dbb7d5b16df59cd972033147936cf86154f7",
  "content": "dGVzdC1ldmlkZW5jZQ==",
  "evidence_type": "text"
}
```

响应示例：
```json
{
  "verify_result": "succeed",
  "push_time": "2021-07-27T08:09:07Z",
  "block_number": "225",
  "block_hash": "0x5045f61eb8c99b4706df52c560a490abe4a9e9df0fc0a62d1af4cf030ecb1146",
  "txhash": "0x58f421bfc90ee6f2b9a3cfe54824dbb7d5b16df59cd972033147936cf86154f7"
}
```

### 4.新存证核验

接口描述：核验存证

接口地址：http://119.3.106.151:10100/v1/app/evidences:new_verify

请求类型：POST

请求参数：  

|编号|名称|类型|是否必须|描述|  
|-----|-----|-----|-----|-----|  
|1|brief_content|string|是|交易hash,存证id,存证摘要|  
|2|content|byte|否|存证内容，base64格式，为文件存证或原文存证时必传|  
|3|verify_type|string|是|存证类型，文件存证：file, 原文存证：text, 摘要存证：digest|  

响应参数：  

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|verify_result|string|存证核验结果， 成功：succeed， 失败：failed|  
|2|push_time|timestamp|存证上链时间|  
|3|block_number|string|区块高度|
|4|evidence_id|string|存证ID|
|5|block_hash|string|区块hash|
|6|txhash|string|交易hash|
|7|digest|string|存证摘要|


请求示例：
```bash
curl -X POST "http://119.3.106.151:10100/v1/app/evidences:new_verify" \
	-H "accept: application/json" \
	-H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjA2MzQsImlhdCI6MTYyNzYxMzQzNCwianRpIjoiNDR6cDN4MDE0cG45bnoiLCJzdWIiOiJ1aWQtdGVuYW50In0.QLuUBa6oZQ1GjtzT4iXWc20CkRdG2AUTfeDfoM9mr8A--BIFRjHS11aRWynNAwr7O5bXNcg02GYMIHEWsyitVw" \
	-H "Content-Type: application/json" \
	-d "{ \"brief_content\": \"0x6712f222ec02c7efec56bacd2358d84495e26691db3521c67f4c120dbe9dd4ca\", \"content\": \"\", \"verify_type\": \"text\"}"
```

```json
{
  "brief_content": "0x6712f222ec02c7efec56bacd2358d84495e26691db3521c67f4c120dbe9dd4ca",
  "content": "",
  "verify_type": "text"
}
```

响应示例：
```json
{
  "verify_result": "succeed",
  "push_time": "2021-09-27T06:10:30.429Z",
  "block_number": "1",
  "evidence_id": "11ea21d324c64b12a413d8ebcdc321be",
  "txhash": "0x6712f222ec02c7efec56bacd2358d84495e26691db3521c67f4c120dbe9dd4ca",
  "digest": "40e1f00a839aad430109e2536de4576ce8bcf80c17b0c9ee6bb2b329c451f56f",
  "block_hash": "0x5045f61eb8c99b4706df52c560a490abe4a9e9df0fc0a62d1af4cf030ecb1146"
}
```

