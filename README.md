# singularity-in-docker

## 動機

バイオインフォマティックスの解析環境を簡便に構築するためのDockerコンテナである。
大規模な解析には当然向かないが、解析環境の構築の検討作業を効率化するために作成した。


解析環境になるべく多くのツールを入れるという戦略ではツールが依存するライブラリのバージョンが衝突してしまうためうまく行かない場合がある。また、論文にある解析環境を再現するには各ツールのバージョンも合わせる必要があるのでさらに環境構築の難易度が増す。

目的の解析に対して必要最小限のツールをインストールした解析環境を、目的に応じて作成する戦略を取ったほうが簡単である。

この`singularity-in-docker`はこのような解析環境構築のための一つの方法である。ベースとなるdockerコンテナに、最小限のツールを追加する。追加の方法にも、tarballから入れる場合、バイナリパッケージを使う場合、condaなどのパッケージマネージャを使う場合などいろいろな方法があり試行錯誤が必要となることが多い。このコンテナを使うことで試行錯誤が簡単にできるようになる。うまく行かなかったらコンテナを捨ててやり直せば良い。類似の解析環境をいろいろ作成することも簡単である。


最小のツールだけをインストールすることにしたとしても、やはり依存ライブラリのバージョンが衝突することもある。この問題を解決する一つの方法がsingularityコンテナを使うことであり、特にbiocontainersが提供するsingularityのコンテナイメージファイルを使えば、どんなツールのどんなバージョンの組み合わせも問題なく実行できるようになる。

このsingularity-in-dockerは https://github.com/kaczmarj/singularity-in-docker を参考にしている。（そのREADME.mdには、singularityコンテナイメージはルート権限を持つLinuxサーバ上でしかビルドできないが、このビルド環境を簡便に提供するのが主目的と説明されている。) 元のDockerコンテナは（おそらくイメージファイルを小さく保つために）Alpine Linuxをベースに作られている。本コンテナではバイオインフォマティックスの解析環境として多く使われているUbuntu Linuxをベースにしている。

## インストール

```bash
git clone https://github.com/oogasawa/singularity-in-docker

docker build -t oogasawa/singindocker ./singularity-in-docker
```


## 起動方法


```bash
sudo docker run -it --privileged --name test_env02 \
  -v /home/oogasawa/data:/home/user01/data \
  -v /home/oogasawa/works:/home/user01/works \
  -v /home/oogasawa/public_html:/home/user01/public_html \
  oogasawa/singindocker:1.0.3 /bin/bash
```

同じ内容が`singindocker_start.sh`にかかれているので、それを使ってもよい。

起動したら、パスを通すなどの目的で`source init_env.sh`してもよい。


## 解析ツールのインストール


実際に解析ツールをインストールする手順などについては以下を参照。

https://github.com/oogasawa/docker_bio


## 
