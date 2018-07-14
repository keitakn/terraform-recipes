# terraform-recipes
TerraformのレシピやTips等を集約したリポジトリ

詳細な説明は後で記載する。

## 実行方法（AWS）

実行対象のディレクトリに移動します。

`cd providers/aws/`

`providers/aws/terraform.tfvars` を設置します。

```
access_key = "YOUR_ACCESS_KEY"
secret_key = "YOUR_SECRET_KEY"
```

これは非常に強力な権限を持ったIAMアクセスキーです。

よってpublicなGitRepositoryには絶対に公開しないよう注意して下さい。

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

`dev`, `stg` , `prd` 全ての環境で利用する場合は以下のコマンドを全て実行して下さい。

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
