# Qilin-Wallet 钱包服务

## API接口文档

### 1.创建钱包
> 批量创建钱包已包含了这个功能，是否取消这个接口，统一调用批量创建

**接口描述**  
创建钱包

**接口地址**  
http://localhost:10100/v1/app/wallets/create

**调用方法**  
http GET

**请求参数**
参数表

|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|用户编号|signUserId|string|64|true|私钥用户的唯一编号，仅支持数字字母下划线|
|2|应用编号|appId|string|64|true|用户标识用户的应用编号|
|3|加密类型|encryptType|uint8||true|0：sha256|
|4|是否返回私钥|returnPrivateKey|bool||true|为true时返回私钥，否则不返回|

示例
```
http://localhost:10100/v1/app/wallets/create?signUserId={signUserId}&appID={appId}&encryptType={encryptType}&returnPrivateKey={returnPrivateKey}
```

**响应参数**
参数表

|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|返回码|code|string||true||
|2|提示信息|message|string||true||
|3|返回数据|data|Object||true||
|3.1|用户编号|signUserId|string||true||
|3.2|应用编号|appId|string||true||
|3.3|私钥信息|privateKey|string||true||
|3.4|账户地址|address|string||true||
|3.5|公钥|publicKey|string||true||
|3.6|描述|description|string||true||
|3.7|加密类型|encryptType|int||true||

示例
a. 正常返回
```json
{
    "code": 0,
    "message": "successful create wallet",
    "data": {
        "signUserId": "8040080e-d494-11eb-b8bc-0242ac130003",
        "appId": "001",
        "privateKey": "",
        "address": "0xff3f4036a1164d1ddbad5b3edf9022addb3e1961a54a922708a6c1ffc49e5489",
        "publicKey": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDTBucQ4G8hPpEluY60nTwDf8xi5Np9caPq5iRVNQjLK/OpZNWQ2w...",
        "description": "",
        "encryptType": 0,
    }
}
```

b. 异常返回
```json
{
    "code": "1",
    "message": "error occur",
    "data": null,
}
```

### 2.批量创建钱包

**接口描述**  
批量创建钱包

**接口地址**  
http://localhost:10100/v1/app/wallets/bulk_create

**调用方法**
http POST

**请求参数**
参数表
|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|请求列表|reqArray|array|100|true||
|1.1|用户编号|signUserId|string|64|true|私钥用户的唯一编号，仅支持数字字母下划线|
|1.2|应用编号|appId|string|64|true|用户标识用户的应用编号|
|1.3|加密类型|encryptType|uint8||true|0：sha256|
|1.4|是否返回私钥|returnPrivateKey|bool||true|为true时返回私钥，否则不返回|
|2|列表长度|length|uint||true||


示例
```
http://localhost:10100/v1/app/wallets/bulk_create
```

```json
{
    "reqArray": [
        {
            "signUserId": "b92d7882-6d23-46ca-865c-4f488eaca4d5",
            "appId": "001",
            "encryptType": 0,
            "returnPrivateKey": true,
        },
        {
            "signUserId": "93868c62-566c-45e1-a2ef-b0d112e642fe",
            "appId": "002",
            "encryptType": 1,
            "returnPrivateKey": false,
        },
    ],
    "length": 2,
}
```

**响应参数**
参数表

|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|返回列表|rspArray|array|100|true||
|1.1|返回码|code|string||true||
|1.2|提示信息|message|string||true||
|1.3|返回数据|data|Object||true||
|1.3.1|用户编号|signUserId|string||true||
|1.3.2|应用编号|appId|string||true||
|1.3.3|私钥信息|privateKey|string||true||
|1.3.4|账户地址|address|string||true||
|1.3.5|公钥|publicKey|string||true||
|1.3.6|加密类型|encryptType|int||true||
|2|列表长度|length|uint||true||
|3|正常返回数目|normal|uint||true||

示例
a. 正常返回
```json
{
    "rspArray": [
        {
            "code": 0,
            "message": "successful create wallet",
            "data": {
                "signUserId": "8040080e-d494-11eb-b8bc-0242ac130003",
                "appId": "001",
                "privateKey": "",
                "address": "0xff3f4036a1164d1ddbad5b3edf9022addb3e1961a54a922708a6c1ffc49e5489",
                "publicKey": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDTBucQ4G8hPpEluY60nTwDf8xi5Np9caPq5iRVNQjLK/OpZNWQ2w...",
                "encryptType": 0,
            },
        },
        {
            "code": 0,
            "message": "successful create wallet",
            "data": {
                "signUserId": "8040080e-d494-11eb-b8bc-0242ac130003",
                "appId": "001",
                "privateKey": "",
                "address": "0xff3f4036a1164d1ddbad5b3edf9022addb3e1961a54a922708a6c1ffc49e5489",
                "publicKey": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDTBucQ4G8hPpEluY60nTwDf8xi5Np9caPq5iRVNQjLK/OpZNWQ2w...",
                "encryptType": 0,
            },
        },
    ],
    "length": 2,
    "normal": 2,
}
```

b. 异常返回
```json
{
    "rspArray": [
        {
            "code": 1,
            "message": "error occur",
            "data": null,
        },
        {
            "code": 1,
            "message": "error occur",
            "data": null,
        },
    ],
    "length": 2,
    "normal": 0,
}
```

c. 部分异常返回
```json
{
    "rspArray": [
        {
            "code": 0,
            "message": "successful create wallet",
            "data": {
                "signUserId": "8040080e-d494-11eb-b8bc-0242ac130003",
                "appId": "001",
                "privateKey": "",
                "address": "0xff3f4036a1164d1ddbad5b3edf9022addb3e1961a54a922708a6c1ffc49e5489",
                "publicKey": "AAAAB3NzaC1yc2EAAAADAQABAAABAQDTBucQ4G8hPpEluY60nTwDf8xi5Np9caPq5iRVNQjLK/OpZNWQ2w...",
                "encryptType": 0,
            },
        },
        {
            "code": 1,
            "message": "err occur",
            "data": null
        },
    ],
    "length": 2,
    "normal": 1,
}
```



### 3.(批量)导入私钥创建钱包

**接口描述**  
导入私钥创建钱包

**接口地址**  
http://localhost:10100/v1/app/wallets/import

**调用方法**
http POST

**请求参数**
参数表
|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|请求列表|reqArray|array|100|true||
|1.1|用户编号|userId|string|64|true||
|1.2|应用编号|appId|string|64|true||
|1.3|私钥|privateKey|string||true||
|1.4|加密类型|encryptType|uint||true||
|2|列表长度|length|uint||true||

示例

```
http://localhost:10100/v1/app/wallets/import
```

```json
{
    "reqArray": [
        {
            "userId": "36db711d-95c1-48c0-81a7-66ffc3616673",
            "appId": "001",
            "privateKey": "MIIEpAIBAAKCAQEA0wbnEOBvIT6RJbmOtJ08A3/MYuTafXGj6uYkVTUIyyvzqWTV",
            "encryptType": 0,
        },
        {
            "userId": "af05d1e0-94a1-48f2-b22f-1e4366ebef93",
            "appID": "001",
            "privateKey": "RY1hKpVjJmJSIuo9jHVsV+Cmb6FlkfKjOWVFqr3KRYivN6LucofNsaMn/gHpPHfM",
            "encryptType": 1,
        },
    ],
    "length": 2,
}
```

**响应参数**
参数表
|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|返回数据列表|rspArray|array|100|true||
|1.1|返回码|code|string||true||
|1.2|提示信息|message|string||true||
|1.3|用户编号|userId|string|64|true||
|1.4|应用编号|appId|string|64|true||
|1.5|钱包地址|address|string||true||
|2|返回列表长度|length|uint||true||
|3|正常返回数目|normal|uint||true||

示例
a. 正常返回

```json
{
    "rspArray": [
        {
            "code": 0,
            "message": "success",
            "userId": "36db711d-95c1-48c0-81a7-66ffc3616673",
            "appId": "001",
            "address": "0x53929380b99c35b8502a80c8d8cedb0d884a666ffe351276c27630ac528f204f",
        },
        {
            "code": 0,
            "message": "success",
            "userId": "af05d1e0-94a1-48f2-b22f-1e4366ebef93",
            "appId": "001",
            "address": "0x6b01fce4dbeaeeb9a6c439a1828b1b8cc1d1618b5fc0035c6308b57080acd8f8",
        },
    ],
    "length": 2,
    "normal": 2,
}
```

b. 异常返回
```json
{
    "rspArray": [
        {
            "code": 1,
            "message": "error",
            "userId": "36db711d-95c1-48c0-81a7-66ffc3616673",
            "appId": "001",
            "address": null,
        },
        {
            "code": 1,
            "message": "error",
            "userId": "af05d1e0-94a1-48f2-b22f-1e4366ebef93",
            "appId": "001",
            "address": null,
        },
    ],
    "length": 2,
    "normal": 0,
}
```

c. 部分异常返回
```json
{
    "rspArray": [
        {
            "code": 0,
            "message": "success",
            "userId": "36db711d-95c1-48c0-81a7-66ffc3616673",
            "appId": "001",
            "address": "0x53929380b99c35b8502a80c8d8cedb0d884a666ffe351276c27630ac528f204f",
        },
        {
            "code": 1,
            "message": "error",
            "userId": "af05d1e0-94a1-48f2-b22f-1e4366ebef93",
            "appId": "001",
            "address": null,
        },
    ],
    "length": 2,
    "normal": 1,
}

```
### 4.签名
> 批量？

**接口描述**
对给定的数据进行签名

**接口地址**  
http://localhost:10100/v1/app/wallets/sign

**调用方法**
http GET

**请求参数**

参数表
|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|用户编号|userId|string|64|true||
|2|请求数据|toEncodeData|string||true|待签名数据的16进制字符|

示例
```
http://localhost:10100/v1/app/wallets/sign
```

```json
{
    "userId": "a113b596-1856-4935-9d18-92f9eaa44f7b",
    "toEncodeData": "40c1102420ff1801339f209ceae5ca490e7fe68254b6757847323c1d6b5314b7e29934a14584b6ab3300df8b8bd966838e387a100288daa2fe81a70371d9443c",
}
```

**响应参数**

参数表
|序号|参数名（zh_CN）|参数名|类型|最大长度|必填|说明|
|-----|-----|-----|-----|-----|-----|-----|
|1|返回码|code|string||true||
|2|提示信息|message|string||false||
|3|返回数据|data|Object||true||
|3.1|签名数据|encodeData|string||true||


示例

a. 正常返回
```json
{
    "code": 0,
    "message": "successfully signed",
    "data": {
        "encodeData": "pfb4Vr62UekRkGxZJ7jeffThxczRoLCA8JbMiiREPAVDQ3LcfPFArlWsdZlrekULgVRTBCCXQ8LiIb77ZB6ENB4MHkk2EyXZ5RPIhH03X730HRkkkQx2PAKj4Vx",
    },
}
```

b. 异常返回
```json
{
    "code": 1,
    "message": "fail signed",
    "data": null,
}
```




