# Qilin-Contract 智能合约服务平台

## 一、设计概述

智能合约服务平台是链服生态中智能合约的管理平台，提供与智能合约交互与计费的基础服务，对外是智能合约的应用商店，客户在商店中按需购买业务合约模板的资源许可证，就可以调用相应的智能合约。

### 业务流程


- 计费

![计费业务流程](../../images/qilin/contract/billing-flow.png)
计费系统需要由上游的 `app系统和用户系统` 提供`请求数据、计费规则和用户信息、资源包等信息`作为输入;
计费系统将账单记录作为输出（存储在db），提供`消费查询功能`给外部系统使用;
### 功能概述
系统主要功能包括：
- 
使⽤者包括：
- 

- 计费服务

使⽤者包括：

- 直接使用平台应用的企业用户
- 进行系统对接的企业系统

### ⾮功能约束
……系统未来预计⼀年⽤户量达到……， ⽇订单量达到……， ⽇PV达到……， 图⽚数量达到 ……。
1. 查询性能⽬标：平均响应时间<300ms，95%响应时间<500ms，单机TPS>100； 2. 下单性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

3. ……性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

4. 系统核⼼功能可⽤性⽬标：>99.97%；

5. 系统安全性⽬标：系统可拦截…… 、……、……攻击， 密码数据散列加密， 客户端数据 HTTPS加密，外部系统间通信对称加密；

6. 数据持久化⽬标：>99.99999%。

## 二、详细设计
### 系统架构

### 应用模块

### 资源包模块
### 计费模块

采用流处理计费，伪实时的产生计费数据.

目前为会以分钟为时间周期记录每个租户在每个应用的账单（包含一分钟内消费和总消费），同时消耗用户资源包或扣除余额.
#### 系统架构

![计费系统架构](../../images/qilin/contract/billing.png)

```text
1. 外部系统提供消费信息（event）
    1.1 提供event的方式有两种:
    所有平台应用都会在执行消费操作时（比如 创建存证）发送消费信息到平台消息队列;
    用户可以将以任何形式收集到的消费信息通过计费服务提供的 restful api传递到 meter 进行计量;
2. 负责获取所有应用产生的 消费信息（event），对 消费信息 进行过滤、格式化，统计计量值发送给 billing
3. 负责计算费用；meter 发送来的计量值 + （用户购买的资源包 + 计费策略）= 费用
```



### 创建应用服务和价格
1. seed 存证应用服务 (包含：基本信息和价格信息)

### 配置应用服务规格
seed admin 创建规格（ App aggr CreateAppLicenseSpec ）无需开发
1. 查询相关的应用服务基本信息和行为信息 （ App service GetAppPriceInfo ）
2. 根据计费点创建规格包 （ App service CreateAppLicenseSpec 无需开发 ）

// admin 修改规格（ aggr UpdateAppLicenseSpec ）

// admin 删除规格（ aggr DeleteAppLicenseSpec ）

// tenant 查看规格 ( aggr GetAppLicenseSpec ）

// tenant 查看规格列表 ( aggr ListAppLicenseSpec ）

// ### 规格包变更
// todo：什么时候变更 

### 为租户发放license
admin 发放license ( app aggr CreateAppLicense ）
1. 查询租户信息 （ iam service ListTenants:已经存在的 ）
2. 查询应用服务规格 ( app service ListAppLicenseSpec ）
3. 为租户创建license ( app service CreateAppLicense ）

### 其他aibo需要
1. ListLicenses
2. ListApps

### app应用版本升级
todo: 1. 应用价格升级 2. 应用规格包升级 3. 应用license升级

