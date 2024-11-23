# 開発環境の構築

## WSLのインストール

power shellを管理者として起動し、下記コマンドを実行

```powershell
wsl --install
```
名前とパスワードを適当に設定  

username  
johnny

password  
Johnney18782  

インストールが完了したら、PCを再起動してubuntuを開く  

## dockerの準備
これを参考にdockerをインストールする  
https://docs.docker.com/engine/install/ubuntu/

### dockerのAPTリポジトリの追加

```
# APTリポジトリとは   
Debian系のLinuxでソフトウェアのインストールや管理、アンインストールに用いられるパッケージ管理コマンド。（RedHat系Linuxのyum、dnfに相当する）
UbuntuはDebianをベースとして派生したLinuxディストリビューションであるため、同様にaptコマンドを利用
```

標準のAPTリポジトリにdockerはないため、dockerの置いてあるリポジトリを追加する必要がある
```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

完了したらリポジトリを更新
```bash
sudo apt update
```

### パッケージをインストール
```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### dockerの動作確認
```
sudo docker run hello-world
```
### ユーザーに管理者権限をつける
dockerはデフォルトの状態だとsudoをつけないと動かないのでユーザーをdockerグループにいれることでユーザー権限で実行できるようにする。
```bash
sudo adduser {ユーザー名} docker
```

## gitのインストール
```bash
sudo apt install git
```

## コンテナの立ち上げ
```bash
sudo -E docker compose up
```

## vscodeからアクセスする
vscodeのリモートエクスプローラーでubuntuの右矢印から接続 

# docker上でpython環境の構築

ローカルpcの内のディレクトリをコンテナ内にマウントする
```bash
docker container run -it --rm --mount type=bind,source=$(wslpath -a 'C:/Users/johnn/Desktop/workspace'),target=/workspace python:3.11.1 /bin/bash
```

```bash
docker container run -it --rm --mount type=bind,source=/home/johnny/test/step2/workspace/src,target=/workspace/src python:step2
```
<br><br>
# GPU環境構築
```
こちらのサイトを参考にした  
https://qiita.com/nabion/items/4c4d4d4119c8586cbd9e  
```

gpuドライバをインストールする  
windowsにインストールすればWSL内でも認識するため普通にインストールすればいい  
https://www.nvidia.com/Download/index.aspx

下記コマンドプロンプトでGPUの情報が帰ってくれば、成功
```bash
nvidia-smi
```

## nvidia-container-toolkitのインストール
下記コードを実行
```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
```

```bash
sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

成功していれば次のコードが通る
```bash
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```