# Qilin-Evidence 存证服务平台

## 存证功能核心流程

```
1. platform admin 创建一个普通用户（iam aggr CreateUser）

2. platform admin 创建一个租户企业，并将刚才创建的普通用户设为 tenant admin（iam aggr CreateTenant）

3. tenant admin 进入租户空间，在基本信息中进行实名认证（iam aggr CreateTenantMeKYC）

    3.1. 调用识蛛四要素做信息确认（spider client）

4. tenant admin 使用创建存证功能（evid aggr CreateEvidence）

    4.1. 创建存证事务（evid service）

    4.2. 创建存证（evid service）

    4.3. 获取 tenant admin 默认钱包（wallet service GetWalletMe）

    4.4. 调用交易服务发送交易，得到交易id（transaction service）

        4.4.1. 创建交易任务，返回交易id（transaction service）
    
        4.4.2. 后台发送交易任务（transaction cron SendTransaction）
    
            4.4.2.1. Build交易

            4.4.2.2. 交易签名（wallet service Sign）

            4.4.2.3. 发送交易

        4.4.3. 后台确认交易任务（transaction cron ConfirmTransaction）

5. 后台使用交易id查询交易状态（evid cron ConfirmEvidence）

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

