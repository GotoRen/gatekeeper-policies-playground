# gatekeeper-policies-playground

## Gatekeeper インストール

```shell
$ cd ./gatekeeper-system/playground
$ kustomize build . --enable-helm | kubectl apply -f -
```

## ポリシの作成

1. Rego でポリシとテストを記述

> `./policies/yet-another-gatekeeper-policy`

2. Rego で定義したポリシをテストする

```shell
$ make test/policy ## $ opa test -v ./policies
```

3. Rego から `ConstraintTemplate` を生成する
4. `gatekeeper/$policy_name/template`に `ConstraintTemplate` を配置する

```shell
$ make build/template ## $ konstraint create policies && ./hack/mv-templates.sh
```

5. `Constraint` でポリシの適用範囲を定義

> `./gatekeeper/yet-another-gatekeeper-policy/constraint/constraint.yaml`

6. `testdata` に検証するサンプルマニフェストを用意

> `./gatekeeper/yet-another-gatekeeper-policy/constraint/testdata`

7. `Suite` でテスト対象となるポリシスタック（Constraint, Template, 対象マニフェスト）を定義

> `./gatekeeper/yet-another-gatekeeper-policy/suite.yaml`

8. `Suite` で `ConstraintTemplate` をテストを実行

```shell
### gator verify で一括検証する場合
$ make test/gatekeeper ## $ gator verify -v ./gatekeeper/...

### gator test で単一のマニフェストを検証する場合
$ cat ./gatekeeper/yet-another-gatekeeper-policy/constraint/testdata/my-manifest.yaml | gator test \
    -f gatekeeper/yet-another-gatekeeper-policy/constraint/constraint.yaml \
    -f gatekeeper/yet-another-gatekeeper-policy/template/template.yaml
```

## ポリシの適用

1. ConstraintTemplate をインストール

```sh
$ kubectl apply -f ./gatekeeper/yet-another-gatekeeper-policy/template/template.yaml
```

2. Constraint をインストール

```sh
$ kubectl apply -f ./gatekeeper/yet-another-gatekeeper-policy/constraint/constraint.yaml
```

## 検証

- 例：`privileged-container`

```shell
### 検証の名前空間を作成
$ kubectl apply -f ./gatekeeper/privileged-container/constraint/testdata/restricted-namespace.yaml

### 違反リソースをデプロイ
$ kubectl apply -f ./gatekeeper/privileged-container/constraint/testdata/denied-pod.yaml
Error from server (Forbidden): error when creating "./gatekeeper/privileged-container/constraint/testdata/denied-pod.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [deny-privileged-container] privileged-container: apiVersion: v1, kind: Pod, name: denied-pod, container: denied-container; container runs as privileged
```
