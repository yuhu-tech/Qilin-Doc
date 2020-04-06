# 使用Qilin开发区块链应用

## OpenApi接入说明
１．参数签名
签名生成的通用步骤如下：
第一步，将本服务提供给用户的"app_key"，当下的时间戳"timestamp"，以及某个接口的所有入参作为集合M。
第二步，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
第三步，在stringA最后拼接上key（key为平台提供的api_secret）得到stringSignTemp字符串，并对stringSignTemp进行MD5运算，再将得到的字符串所有字符转换为大写，得到sign值signValue。
特别注意以下重要规则：
◆ 参数名ASCII码从小到大排序（字典序）；
◆ 如果参数的值为空不参与签名；
◆ 参数名区分大小写；
◆ 若value本身仍然是一个接口体，这主要将value序列化成一个字符串（需要保证该序列化的顺序与自己调用时参数的顺序一致），再把整个字符串作为value参与签名
◆ timestamp需要为RFC3339的格式
举例：
假设某接口的入参如下：
```
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
第一步：整理后集合M
```
app_key: 123456789
timestamp: 2020-01-02T15:04:05+08:00
skip: 1
first: 2
params: {"contract_address":"0x0","tx_hash":"0x0","to":"0x0"}
```
第二步：将集合M字典序，拼成字符串stringA
```
app_key=123456789&first=2&params={"contract_address":"0x0","tx_hash":"0x0","to":"0x0"}&skip=2&timestamp=2020-01-02T15:04:05+08:00
```
第三步：在stringA最后拼接上key，并对进行MD5运算，再将得到的字符串所有字符转换为大写，得到sign值signValue
```
str: app_key=123456789&first=2&params={"contract_address":"0x0","tx_hash":"0x0","to":"0x0"}&skip=2&timestamp=2020-01-02T15:04:05+08:00&key=abcdefg
sign: ToUpper(MD5(str))
```
最终发送请求时，将app_key, timestamp, 以及sign作为url的参数一起发送即可
