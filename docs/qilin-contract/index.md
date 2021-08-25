# Qilin-Contract 智能合约服务平台

## 一、设计概述

智能合约服务平台是链服生态中智能合约的管理平台，提供与智能合约交互与计费的基础服务，对外是智能合约的应用商店，客户在商店中按需购买业务合约模板的资源许可证，就可以调用相应的智能合约。

### 功能概述
系统主要功能包括：
- 
使⽤者包括：
- 
### ⾮功能约束
……系统未来预计⼀年⽤户量达到……， ⽇订单量达到……， ⽇PV达到……， 图⽚数量达到 ……。
1. 查询性能⽬标：平均响应时间<300ms，95%响应时间<500ms，单机TPS>100； 2. 下单性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

3. ……性能⽬标：平均响应时间<800ms，95%响应时间<1000ms，单机TPS>30；

4. 系统核⼼功能可⽤性⽬标：>99.97%；

5. 系统安全性⽬标：系统可拦截…… 、……、……攻击， 密码数据散列加密， 客户端数据 HTTPS加密，外部系统间通信对称加密；

6. 数据持久化⽬标：>99.99999%。

## 二、详细设计
### 系统架构

1. 创建应用服务规格
2. 配置应用服务规格
3. 为租户生成资源包
4. app定价

### 创建应用服务流程

### 配置应用服务规格
admin 创建规格（ aggr CreateAppLicenseSpec ）
1. 验证admin合法性 （iam service ListTenantsKYC）
2. 查询相关的应用
3. 创建规格
admin 修改规格（ aggr UpdateAppLicenseSpec ）

admin 删除规格（ aggr DeleteAppLicenseSpec ）

tenant 查看规格 ( aggr GetAppLicenseSpec ）

tenant 查看规格列表 ( aggr ListAppLicenseSpec ）


### 为租户生成资源包
admin 创建资源包 ( aggr CreateAppLicense ）
1. 验证admin合法性 （iam service ListTenantsKYC）
2. 查询租户信息 （iam service ListTenantsKYC）
3. 查询应用服务规格 ( aggr GetAppLicenseSpec ）
4. 为租户创建资源包 ( aggr GetAppLicenseSpec ）

### app定价
admin 设置app价格 ( aggr SetAppPrice ）
1. 验证admin合法性 （iam service ListTenantsKYC）
2. 设置app价格（ service SetAppPrice ）

