# terraform-recipes
TerraformのレシピやTips等を集約したリポジトリ

詳細な説明は後で記載する。

## 実行方法（AWS）

実行対象のディレクトリに移動します。

`cd providers/aws/`

`providers/aws/terraform.tfvars` を設置します。

```
access_key                   = "YOUR_ACCESS_KEY"
secret_key                   = "YOUR_SECRET_KEY"
workplace_cidr_blocks        = ["200.200.200.200/32"]
ssh_public_key_path          = "~/.ssh/your_key_name.pem.pub"
rds_master_username          = "YOUR_RDS_MASTER_USER_NAME"
rds_master_password          = "YOUR_RDS_MASTER_USER_PASSWORD"
rds_local_domain_base_name   = "terraform-recipes"
rds_local_master_domain_name = "sample-db-master"
rds_local_slave_domain_name  = "sample-db-slave"
main_domain_name             = "sample.com"
webapi_domain_name           = "api.sample.com"
```

`access_key`, `secret_key` は非常に強力な権限を持ったIAMアクセスキーです。

よってpublicなGitRepositoryには絶対に公開しないよう注意して下さい。

### SSH接続を許可するIPアドレス範囲を設定

`workplace_cidr_blocks` にはあなたのオフィスのIPアドレス範囲を入力して下さい。

例えばあなたのオフィスのIPが `200.200.200.200` 固定であれば `200.200.200.200/32` となります。

これはリスト構造なので複数設定する事が可能です。

### SSH接続用の鍵を作成

`ssh_public_key_path` にはOpenSSH形式の公開鍵のパスを設定します。

本プロジェクトのSSH接続は全て bastionサーバを経由します。

bastionサーバには `workplace_cidr_blocks` で許可した場所からのみ接続が可能となります。

その為、SSH接続用のキーペアを作成する必要があります。

`ssh-keygen` コマンドを使ってキーペアを作成しましょう。

下記にコマンドの例を記載しておきます。

`ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f your_key_name.pem`

下記のように表示されれば成功です。

```
+---[RSA 4096]----+
|       Eo+o .=.. |
|       . o+.B . .|
|        o.=X.=..o|
|       . *oo*o*o.|
|        S o.=+.o |
|         o.. oo  |
|          .o . o |
|         .= . o +|
|        .o o   .+|
+----[SHA256]-----+
```

`~/.ssh` に鍵が出力されています。

`providers/aws/terraform.tfvars` に以下の記述を追加して下さい。

先程のコマンドの例だと `~/.ssh/your_key_name.pem.pub` が作成されているハズなので、下記のようになるかと思います。

```
ssh_public_key_path   = "~/.ssh/your_key_name.pem.pub"
```

### RDSのMasterUserとMasterPasswordを設定する

`rds_master_username` と `rds_master_password` を設定して下さい。

`rds_master_password` は十分に強固な値を設定して下さい。

### RDS用のローカルドメイン名 `rds_local_domain_base_name` を設定する

RDSのAmazon Aurora Clusterは作成の度にClusterエンドポイントを作成します。

アプリケーションから接続する際にこの挙動は少々不便です。

よって本プロジェクトではAmazon Aurora Clusterに接続する為にRoute53でPrivate Hosted Zoneを設定しています。

`rds_local_domain_base_name` にはあなたの好きなドメイン名を入れて下さい。

例えば `terraform-recipes` を入れると以下のようになります。

- terraform-recipes.dev（開発環境）
- terraform-recipes.stg（ステージング環境）
- terraform-recipes.prd（本番環境）

### RDSの書き込み用Clusterエンドポイント

`rds_local_master_domain_name` に設定する値です。

例えば `sample-db-master` を設定し、workspaceが `stg` の場合は以下のMySQLコマンドで接続が可能になります。

```
mysql -h sample-db-master.terraform-recipes.stg -u {rds_master_username} -p
```

### RDSの読み込み用Clusterエンドポイント

`rds_local_slave_domain_name` に設定する値です。

例えば `sample-db-slave` を設定し、workspaceが `stg` の場合は以下のMySQLコマンドで接続が可能になります。

```
mysql -h sample-db-slave.terraform-recipes.stg -u {rds_master_username} -p
```

### `webapi` の `ami` を変更する

`providers/aws/variable.tf` の中にある `variable.webapi` に設定されているamiをあなたが利用する物に変更して下さい。

### `main_domain_name` にメインとなるドメイン名を指定

Hosted Zoneにメインとなるドメイン名を設定してください。

WebAPIを模倣したサービスはHTTPSで通信を行うので、AWS Certificate Managerで証明書を追加してください。

証明書は *.{main_domain_name} で取得してください。

メインのドメイン名が `sample.com` であれば `*.sample.com` で証明書を取得してください。

### `webapi_domain_name` にWebAPIのドメイン名を指定

例えば `api.sample.com` を設定すると以下のようになります。

- `dev-api.sample.com`（開発環境）
- `stg-api.sample.com`（ステージング環境）
- `qa-api.sample.com`（QA環境）
- `prd-api.sample.com`（本番環境）

### workspaceの設定

`workspace` によって実行環境を切り替えます。

`providers/aws/` 配下で以下のコマンドを実行します。

`terraform workspace list`

実行結果は下記のようになります。

```
  default
* dev
```

これは現在の `workspace` が `dev` である事を表しています。

`workspace` を新規作成するには以下のように実行します。

`qa`, `dev`, `stg`, `prd` 全ての環境で利用する場合は以下のコマンドを全て実行して下さい。

- `terraform workspace new qa`
- `terraform workspace new dev`
- `terraform workspace new stg`
- `terraform workspace new prd`

`workspace` の切り替えは `terraform workspace select stg` のように実行します。

詳しくは公式ドキュメントの [workspace](https://www.terraform.io/docs/commands/workspace/index.html) を参照して下さい。

## よく利用する各種コマンド

### `terraform plan`

実行計画を確認するコマンドです。

開発環境等ではそれほど気にならないかもしれませんが、本番環境で予期しないリソースの再作成等が行われてしまうと大きな事故になってしまうのでこのコマンドで実行計画を確認しましょう。

（参考）[plan](https://www.terraform.io/docs/commands/plan.html)

### `terraform apply`

実際にCloudサービス上に適応します。

（参考）[apply](https://www.terraform.io/docs/commands/apply.html)

### `terraform fmt`

`.tf` ファイルを整形するコマンドです。

コミット前に必ずコマンドを実行しましょう。

`.git/hooks` に仕込んでおくとベストです。

（参考）[fmt](https://www.terraform.io/docs/commands/fmt.html)
