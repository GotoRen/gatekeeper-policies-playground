# gatekeeper-policies-playground

## Run Locally

1. Rego でポリシとテストを記述

2. Rego で定義したポリシをテストする

```shell
$ opa test -v ./policies
```

3. Rego から `ConstraintTemplate` を生成する

```shell
$ konstraint create policies
```

4. `gatekeeper/$policy_name/template`に `ConstraintTemplate` を配置する

```
$ ./hack/mv-templates.sh
```

5. `Constraint` でポリシの適用範囲を定義

6. `testdata` に検証するサンプルマニフェストを用意

7. `Suite` で `ConstraintTemplate` をテストを実行

```shell
$ gator verify -v ./gatekeeper/...
```
