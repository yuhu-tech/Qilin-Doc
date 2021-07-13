# Qilin-Evidence 存证服务平台

## 存证功能核心流程

```
1. platform admin 创建一个普通用户（iam aggr CreateUser）

2. platform admin 创建一个租户企业，并将刚才创建的普通用户设为 tenant admin（iam aggr CreateTenant）

3. tenant admin 进入租户空间，在基本信息中进行实名认证（iam aggr CreateTenantMeKYC）

    3.1. 调用识蛛四要素做信息确认（spider client）

4. tenant admin 使用创建存证功能（evid aggr CreateEvidence）

    4.1. 获取 tenant admin 默认钱包（wallet service ListWallets）

    4.2. 获取 tenant admin 企业认证信息（iam service ListTenantsKYC）

    4.3. 创建存证事务，附带上企业认证信息，注：4.4存证创建失败，则存证事务作为脏数据存储在数据库中（evid service）

        4.3.1. （二阶段）后续增加识蛛的实名认证，并获取认证的时间戳

    4.4. 创建存证，状态（builded）（evid service）

    4.5. 调用交易服务发送交易，传入outTradeId作为幂等号（transaction service CreateTransaction）

        4.5.1. 创建交易任务，由于存证outTradeId，所以可以retry（transaction service CreateTransaction）
    
        4.5.2. 后台发送交易任务（transaction cron SendTransaction）
    
            4.5.2.1. Build交易

            4.5.2.2. 交易签名（wallet service Sign）

            4.5.2.3. 发送交易

        4.5.3. 后台确认交易任务（transaction cron ConfirmTransaction）

            4.5.3.1. 后台确认完成后，调用存证确认接口将成功、失败状态通过outTradeId返回给存证服务（evid server ConfirmEvidStatus）

5. 后台使用之前传入的outTradeId查询（兜底补偿）交易状态，存证创建服务内容创建2分钟后再开始补偿确认（evid cron ConfirmEvidence）

    5.1. 查询交易状态（transaction service）

        5.1.1. 返回查询状态（未找到->failed、发送中、成功->succeed、失败->failed），更新存证状态（succeed、failed）

6. tenant admin 可以查看到存证记录（evid aggr ListEvidence）

7. 普通用户核验存证记录（evid aggr VerifyEvidence）
```

## API接口文档

### 1.创建事务

接口描述：

接口地址：http://localhost:10100/v1/app/evid/trans/create

### 2.创建摘要存证

接口描述：摘要形式存证，可以用于电子文本、文件数据摘要的存证。包含存证元数据、摘要数据。

接口地址：http://localhost:10100/v1/app/evid/digest/create

### 3.创建原文本存证

接口描述：文本形式存证，可以用户电子文本数据的存证。包含存证元数据，存证文本。

接口地址：http://localhost:10100/v1/app/evid/text/create

### 4.创建原文件存证

接口描述：文件形式存证，可以用户电子文件数据的存证。包含存证元数据，存证文件。

接口地址：http://localhost:10100/v1/app/evid/file/create

### 5.获取摘要存证

接口描述：获取存证摘要数据。

接口地址：http://localhost:10100/v1/app/evid/digest/get

### 6.获取原文本存证

接口描述：获取存文本要数据。

接口地址：http://localhost:10100/v1/app/evid/text/get

### 7.获取原文件存证

接口描述：获取存证文件数据。

接口地址：http://localhost:10100/v1/app/evid/file/get

### 8.获取区块链存证信息

接口描述：获取区块链交易数据。

接口地址：http://localhost:10100/v1/app/evid/blockchain/get

### 9.创建核验令牌

接口描述：

接口地址：http://localhost:10100/v1/app/evid/verifytoken

### 10.存证摘要核验

接口描述：核验文本要数据。

接口地址：http://localhost:10100/v1/app/evid/digest/verify

### 11.存证原文本核验

接口描述：核验存文本要数据。

接口地址：http://localhost:10100/v1/app/evid/text/verify

### 12.存证原文件核验

接口描述：核验存证文件数据。

接口地址：http://localhost:10100/v1/app/evid/file/verify

