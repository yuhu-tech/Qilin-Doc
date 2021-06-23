# Qilin-Evidence 存证服务平台

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

