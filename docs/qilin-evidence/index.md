# Qilin-Evidence 可信存证服务平台

## 一、设计概述

可信存证服务平台是链服生态中由域乎官方提供的可信存证服务，底层使用的是域乎可信存证联盟链，是直接提供给外部机构使用的业务产品，承担着公司创收的⽬标任务。

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

## 二、详细设计

系统上线时预计部署在公司标准K8S集群中，包含2个deployment服务，1个job服务，占用5～7个pod资源，RDS-MYSQL中占用1个数据库，RDS-REDIS中占用1个数据库，部署2个存证⼦系统，和链服生态系统中的账户服务、钱包服务、交易服务交互，和外部第三⽅（识蛛）的可信时间戳服务交互。

### 系统架构

![存证系统架构图](../../images/qilin/evidence/structure.png)

```
1. platform admin 创建一个普通用户（iam aggr CreateUser）

2. platform admin 创建一个租户企业，并将刚才创建的普通用户设为 tenant admin（iam aggr CreateTenant）

3. tenant admin 进入租户空间，在基本信息中进行实名认证（iam aggr CreateTenantMeKYC）

4. tenant admin 使用创建存证功能（evid aggr CreateEvidence）

5. 后端 cron job 进行区块链交易状态的确认（evid cron ConfirmEvidence）

6. tenant admin 可以查看到存证记录（evid aggr ListEvidence）

7. 普通用户核验存证记录（evid aggr VerifyEvidence）
```

### 创建存证场景系统流程

![存证系统流程](../../images/qilin/evidence/evid-bpmn.png)

tenant admin 使用创建存证功能（evid aggr CreateEvidence）

```
4.1. 获取 tenant admin 默认钱包（wallet service GetWalletMe）

4.2. 获取 tenant admin 企业认证信息（iam service ListTenantsKYC）

4.3. 创建存证事务，附带上企业认证信息，注：4.4存证创建失败，则存证事务作为脏数据存储在数据库中（evid service）

    4.3.1.（二阶段）后续增加识蛛的实名认证，并获取认证的时间戳

4.4. 创建存证，状态（builded）（evid service）

4.5. 调用交易服务发送交易，传入 outTradeId 作为幂等号（transaction service CreateTransaction）

    4.5.1. 创建交易任务，由于存证 outTradeId，所以可以 retry（transaction service CreateTransaction）

    4.5.2. 后台发送交易任务（transaction cron SendTransaction）

        4.5.2.1. Build交易

        4.5.2.2. 交易签名（wallet service Sign）

        4.5.2.3. 发送交易

    4.5.3. 后台确认交易任务（transaction cron ConfirmTransaction）

        4.5.3.1. 后台确认完成后，修改 Record 交易状态。

        4.5.3.2.（后续考虑的性能优化方案）将 outTradeId 已经被确认的消息发送到消息队列，让调用方更实时的获取到交易结果数据。
```

### 存证状态确认场景系统流程

![存证确认流程图](../../images/qilin/evidence/cron.png)

后端 cron job 进行区块链交易状态的确认（evid cron ConfirmEvidence）

```
5.1. 查询交易状态（transaction service）

    5.1.1. 存证状态更新（发送中->忽略更新、成功->succeed、失败->failed）。

    5.1.2. 如果查询到的状态为「未找到」，则需要判断数据库中存证创建时间距离当下时间，是否已经超过两分钟，如果超过两分钟则将存证状态更新为 failed，否则忽略更新。
```

## 三、子系统1设计（存证聚合子系统）

⼦系统1作为数据存证平台，所有外部请求的服务编排者，与内外部服务交互及数据聚合，最终将数据返回给请求方，其中只包含1个业务聚合组件。

## 四、子系统2设计（存证基础子系统）

⼦系统2主要的职责是提供中心化的数据存证服务，其中主要包含了4组件。

### 子系统组件结构关系

![组件结构关系](../../images/qilin/evidence/Component.png)

⼦系统2包含4个组件： 

- 组件1（Service）的功能主要是提供业务逻辑处理， 需要依赖组件3、4完成数据持久化的工作， 是⼦系统2的核⼼组件。

- 组件2（Cron）的功能主要是提供定时任务处理， 需要依赖组件3、4完成数据持久化的工作， 同时还会依赖其他服务service client，来调用其他服务的业务逻辑。

- 组件3（Model）的功能主要是提供贫血模式的业务数据模型， 不依赖其他组件。

- 组件4（Data）的功能主要是数据的获取和持久化，其内部分装各种持久化方式，如：mysql、redis、local_cache。

### 创建存证事务功能组件流程

![存证事务](../../images/qilin/evidence/trans.png)

### 创建存证功能组件流程

![存证功能组件流程](../../images/qilin/evidence/operation-flow.png)

### 组件1类图

![service类图](../../images/qilin/evidence/service.png)

EvidenceService interface

```go
type EvidenceServiceClient interface {
	CreateEVIDTrans(ctx context.Context, in *CreateEVIDTransRequest, opts ...grpc.CallOption) (*CreateEVIDTransResponse, error)
	CreateDigestEvidence(ctx context.Context, in *CreateDigestEvidenceRequest, opts ...grpc.CallOption) (*CreateDigestEvidenceResponse, error)
	CreateFileEvidence(ctx context.Context, in *CreateFileEvidenceRequest, opts ...grpc.CallOption) (*CreateFileEvidenceResponse, error)
	CreateTextEvidence(ctx context.Context, in *CreateTextEvidenceRequest, opts ...grpc.CallOption) (*CreateTextEvidenceResponse, error)
	GetEvidence(ctx context.Context, in *GetEvidenceRequest, opts ...grpc.CallOption) (*GetEvidenceResponse, error)
	ListEvidences(ctx context.Context, in *ListEvidencesRequest, opts ...grpc.CallOption) (*ListEvidencesResponse, error)
	CreateVerify(ctx context.Context, in *CreateVerifyRequest, opts ...grpc.CallOption) (*empty.Empty, error)
}
```

### 组件2类图

![cron类图](../../images/qilin/evidence/cron-uml.png)

### 组件3类图

![model类图](../../images/qilin/evidence/model.png)

Evidence model

```go
type Evidence struct {
	EvidenceId  string    `gorm:"column:evidence_id;primary_key"`
	CreateTime  time.Time `gorm:"column:create_time;default:CURRENT_TIMESTAMP;NOT NULL"`
	EvidtransId string    `gorm:"column:evidtrans_id;NOT NULL"`
	WalletId    string    `gorm:"column:wallet_id;NOT NULL"`
	Title       string    `gorm:"column:title;NOT NULL"`
	EvidType    string    `gorm:"column:evid_type;NOT NULL"` // text,digest,file
	Digest      string    `gorm:"column:digest"`
	Txhash      *string   `gorm:"column:txhash;unique"`
	Status      string    `gorm:"column:status;NOT NULL"` // builded,succeed,failed
	PushTime    time.Time `gorm:"column:push_time"`
	Tsr         int       `gorm:"column:tsr;NOT NULL"`
	Owner       string    `gorm:"column:owner"`
	GroupId     string    `gorm:"column:group_id"`
	TenantId    string    `gorm:"column:tenant_id"`
	VerifyCount int       `gorm:"column:verify_count;default:0;NOT NULL"`
	Extra       string    `gorm:"column:extra"`
}

type EvidenceContent struct {
	EvidenceId string `gorm:"column:evidence_id;primary_key"`
	RawText    string `gorm:"column:raw_text"`
	FilePath   string `gorm:"column:file_path"`
}
```

Evidtrans model

```go
type Evidtrans struct {
	EvidtransId    string    `gorm:"column:evidtrans_id;primary_key"`
	CreateTime     time.Time `gorm:"column:create_time;default:CURRENT_TIMESTAMP;NOT NULL"`
	OrgName        string    `gorm:"column:org_name;NOT NULL"`
	OrgCode        string    `gorm:"column:org_code;NOT NULL"`
	LegalRepName   string    `gorm:"column:legal_rep_name;NOT NULL"`
	LegalRepIdCard string    `gorm:"column:legal_rep_id_card;NOT NULL"`
	Status         string    `gorm:"column:status;NOT NULL"` // builded,succeed,failed
	Owner          string    `gorm:"column:owner"`
	GroupId        string    `gorm:"column:group_id"`
	TenantId       string    `gorm:"column:tenant_id"`
	Extra          string    `gorm:"column:extra"`
}

type EvidenceTransBinding struct {
	BindId      string    `gorm:"column:bind_id;primary_key"`
	EvidenceId  string    `gorm:"column:evidence_id;NOT NULL"`
	EvidtransId string    `gorm:"column:evidtrans_id;NOT NULL"`
	CreateTime  time.Time `gorm:"column:create_time;default:CURRENT_TIMESTAMP;NOT NULL"`
}
```

### 组件4类图

![EvidenceData interface](../../images/qilin/evidence/dataInterface.png)

EvidenceData interface

```go
type EvidenceInterface interface {
	CreateEvidence(*evidence.Evidence) error
	UpdateEvidence(*evidence.Evidence, *db.Filter) error
	SearchEvidence(*db.Filter) ([]*evidence.Evidence, error)
	GetEvidence(evidenceId string) (*evidence.Evidence, error)
	GetEvidenceByTxHash(txHash string) (*evidence.Evidence, error)
	SearchEvidencePaged(filter *db.Filter, limit uint32, offset uint32) ([]*evidence.Evidence, error)

	CreateEvidTrans(*evidence.Evidtrans) error

	CreateEvidContent(*evidence.EvidenceContent) error
	GetEvidContent(evidenceId string) (*evidence.EvidenceContent, error)

	CreateEvidTransBind(*evidence.EvidenceTransBinding) error

	CreateVerify(*evidence.EvidenceVerifyRecord) error
}
```

## 五、聚合层接口文档

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
```
curl -X POST "http://119.3.106.151:10100/v1/app/evidences" -H "accept: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjAwODUsImlhdCI6MTYyNzYxMjg4NSwianRpIjoicXd6bHczeTgyMDduN2wiLCJzdWIiOiJ1aWQtdGVuYW50In0.eNEuMd4A9IWC4tnFOHXIpgknde-Kgt3P_Hpipj9DtGl6kcXj_lhD07En1lXR-AQH1h5faAm9wNrBY50HvlV9Cw" -H "Content-Type: application/json" -d "{ \"tenant_id\": \"tid-yuhu1\", \"title\": \"evidence\", \"content\": \"ZXZpZGVuY2U=\", \"evidence_type\": \"text\", \"tsr\": true}"
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
|3|tenant_id|uint32|是|用户的租户id|  

响应参数 

|编号|名称|类型|描述|  
|-----|-----|-----|-----|  
|1|evidences|array|存证数组|  
|1.1|evidence_id|string|存证编号|  
|1.2|txhash|string|存证交易哈希|  
|1.3|status|string|存证状态，交易已发送：builded, 成功：succeed，失败：failed|  
|1.4|title|string|存证标题，若为文件存证则为文件名|  
|1.5|push_time|timestamp|存证上链时间|  

请求示例：
```
curl -X GET "http://119.3.106.151:10100/v1/app/evidences?limit=10&offset=0&tenant_id=tid-yuhu1" -H "accept: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjAwODUsImlhdCI6MTYyNzYxMjg4NSwianRpIjoicXd6bHczeTgyMDduN2wiLCJzdWIiOiJ1aWQtdGVuYW50In0.eNEuMd4A9IWC4tnFOHXIpgknde-Kgt3P_Hpipj9DtGl6kcXj_lhD07En1lXR-AQH1h5faAm9wNrBY50HvlV9Cw"
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
      "push_time": "2021-07-27T08:09:07Z"
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

请求示例：
```
curl -X POST "http://119.3.106.151:10100/v1/app/evidences:verify" -H "accept: application/json" -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9.eyJleHAiOjE2Mjc2MjA2MzQsImlhdCI6MTYyNzYxMzQzNCwianRpIjoiNDR6cDN4MDE0cG45bnoiLCJzdWIiOiJ1aWQtdGVuYW50In0.QLuUBa6oZQ1GjtzT4iXWc20CkRdG2AUTfeDfoM9mr8A--BIFRjHS11aRWynNAwr7O5bXNcg02GYMIHEWsyitVw" -H "Content-Type: application/json" -d "{ \"txhash\": \"0x58f421bfc90ee6f2b9a3cfe54824dbb7d5b16df59cd972033147936cf86154f7\", \"content\": \"dGVzdC1ldmlkZW5jZQ==\", \"evidence_type\": \"text\"}"
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
  "push_time": "2021-07-27T08:09:07Z"
}
```

## 六、服务层接口文档

### 1.创建事务

接口描述：

接口地址：qilin.basic.evidence.v1.CreateEVIDTrans

### 2.创建摘要存证

接口描述：摘要形式存证，可以用于电子文本、文件数据摘要的存证。包含存证元数据、摘要数据。

接口地址：qilin.basic.evidence.v1.CreateDigestEvidence

### 3.创建原文本存证

接口描述：文本形式存证，可以用户电子文本数据的存证。包含存证元数据，存证文本。

接口地址：qilin.basic.evidence.v1.CreateTextEvidence

### 4.创建原文件存证

接口描述：文件形式存证，可以用户电子文件数据的存证。包含存证元数据，存证文件。

接口地址：qilin.basic.evidence.v1.CreateFileEvidence

### 5.获取摘要存证

接口描述：获取存证摘要数据。

接口地址：

### 6.获取原文本存证

接口描述：获取存文本要数据。

接口地址：

### 7.获取原文件存证

接口描述：获取存证文件数据。

接口地址：

### 8.获取区块链存证信息

接口描述：获取区块链交易数据。

接口地址：

### 9.创建核验令牌

接口描述：

接口地址：

### 10.存证摘要核验

接口描述：核验文本要数据。

接口地址：qilin.basic.evidence.v1.GetEvidence

### 11.存证原文本核验

接口描述：核验存文本要数据。

接口地址：qilin.basic.evidence.v1.GetEvidence

### 12.存证原文件核验

接口描述：核验存证文件数据。

接口地址：qilin.basic.evidence.v1.GetEvidence
