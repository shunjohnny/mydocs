---
title: whisper
tags:
  - whisper
  - Hugging Face
  - Pytorch
  - AI
---

<br>

## whisperの概要
---
whisperとはOpenAIが開発して大規模な音声認識モデルです。  
transformerアーキテクチャをベースにしており、  
Webから収集された68万時間分の多言語音声データを用いて教師付き学習を行っているため、  
高い精度で音声をテキストに変換することが可能です。  
また、mp3, mpeg, wav等のファイルの処理が可能です。

ここでは主に実使用方法に関して記載します。  
論文は下記リンクよりご確認下さい。

- [paper](https://arxiv.org/abs/2212.04356)  
- [github](https://github.com/openai/whisper?tab=readme-ov-file)

<br><br>

## ローカルで使用できるwhisperライブラリの種類
---
whisperの使用方法として  
openaiのapiを使用してオンラインで行う方法とローカルにて行う方法があります。  
ここではローカルで行う方法に関して紹介します。  
ローカルで行う方法でも下記表に示すように2種類あり、  
それぞれで使用方法が異なります。  
!!! note
    Hugging Faceのopenaiは複雑だけど細かなセッティングができる!  

| 特徴                     | `Hugging Face`のwhisper                                                  | `opwnai`のwhisper                                                      |
|--------------------------|--------------------------------------------------------------------------|-----------------------------------------------------------------------|
| **提供元**               | Hugging Face                                                             | OpenAI                                                                |
| **ファインチューニング** | 可能（独自のデータセットで再トレーニングが可能）                         | 非対応                                                                |
| **利用の容易さ**         | 複雑（多機能で細かい設定が可能）                                          | 簡単（トランスクリプションに特化してシンプル）                         |
| **機能の範囲**           | 音声認識、トランスクリプション、ファインチューニングなど多用途            | 音声認識、トランスクリプションのみ                                     |
| **エコシステム**         | `datasets`や`Trainer`などHugging Faceの他のツールとシームレスに連携      | OpenAI提供のシンプルなモデルローディングとトランスクリプション        |
| **カスタマイズ性**       | 高い（トークナイザー、デコーダなどのパラメータを詳細に設定可能）          | 低い（標準的なトランスクリプション用途のみ）                           |
| **モデルのロード**       | `WhisperProcessor`と`WhisperForConditionalGeneration`クラスを使用         | `whisper.load_model`メソッドでロード                                   |
| **デバイスサポート**     | CPU/GPUに対応                                                            | CPU/GPU（CUDAサポート）に対応                                         |
| **適用例**               | カスタム音声認識モデルのトレーニングや高度な設定が必要なタスク            | シンプルな音声トランスクリプションが目的のタスク                      |
| **インストール**         | `pip install transformers datasets torchaudio`                            | `pip install openai-whisper`                                          |


<br><br>

## openaiのwhisepr
---

### 基本的な使用方法

上記のwhisperの[github](https://github.com/openai/whisper?tab=readme-ov-file)に使用方法が書いてあります。
ffmpegをインストールしていない場合はインストール

!!! note ""
    === "Ubuntu"
        ターミナルに下記コマンドを記入して実行
        ```bash
        sudo apt update && sudo apt install ffmpeg
        ```

    === "windows"
        powershellに下記コマンドを記入して実行
        ```powershell
        winget install ffmpeg
        ```

    === "Docker"
        Docker上でwhisperを使用したい時
        Dockerfileに下記を記載
        ```Dockerfile
        RUN apt-get update && apt-get install -y \
            ffmpeg
        ```

ライブラリをインストールして
```bash
pip install openai-whisper
```
下記のようなコードのみで動く。
large-v3が最も精度がよいがgpuを使用しないととても遅い。

```python
import whisper

# Whisperモデルのロード（tiny, base, small, medium, large, large-v3, turbo）
model = whisper.load_model("base")

# 音声ファイルのトランスクリプション
result = model.transcribe("path/to/audio.mp3")

# テキスト出力
print(result["text"])
```

<br>

### その他の使用方法
下記にその他の使用方法を記載する
```python
# 音声の指定(デフォルトでは自動検出)
result_ja = model.transcribe("path/to/audio.mp3", language="ja")
print(result_ja["text"])

# 自動検出した言語を表示
print(f"Detected language: {result['language']}")

# 翻訳(英語への翻訳)
result_translate = model.transcribe("path/to/audio.mp3", task="translate")
print(result_translate["text"])

# 詳細なログを表示しながらのトランスクリプション
result_verbose = model.transcribe("path/to/audio.mp3", verbose=True)

# トランスクリプション時にワードタイムスタンプを取得
result_timestamps = model.transcribe("path/to/audio.mp3", word_timestamps=True)
for segment in result_timestamps["segments"]:
    print(f"Start: {segment['start']}s, End: {segment['end']}s, Text: {segment['text']}")

# GPUを使用する(CUDAが使用できる場合)
model_cuda = whisper.load_model("base", device="cuda")
result_cuda = model_cuda.transcribe("path/to/audio.mp3")
print(result_cuda["text"])

# トランスクリプション時のセグメント情報を取得
# 各セグメントの開始時間、終了時間、テキストを表示
for segment in result["segments"]:
    print(f"Start: {segment['start']}s, End: {segment['end']}s, Text: {segment['text']}")
```

<br><br>

## Hugging Faceのwhisper
---
### 基本的な使用用法

Hugging Fadceのwhisperの公式ページは[こちら](https://huggingface.co/docs/transformers/model_doc/whisper)

!!! note
    上記と同様でffmpegをインストールして下さい。  

ライブラリをインストールして
```bash
pip install transformers torchaudio
```

下記のようなコードのみで動く
```python
from transformers import pipeline

# Whisperモデルとプロセッサをロード
whisper_pipeline = pipeline(
    "automatic-speech-recognition",
    model="openai/whisper-small",
    device="cuda"  # GPUを使う場合は"cuda"、CPUの場合は"cpu"
)

# 音声を文字起こし
result = whisper_pipeline("path/to/audio.mp3")

# 文字起こし結果を表示
print(result["text"])
```

!!! warning
    model名がopenaiのライブラリのものと異なることに注意

<br>

### WhisperProcessorとWhisperForConditionalGeneration

こちらがHuggingFaceのライブラリを使用する場合にメリット？となる使用方法。
WhisperProcessorとWhisperForConditionalGenerationを使用し、  
細かな設定変更を行うことができる。  

<br>

#### 基本的なコード

```python
from transformers import WhisperProcessor, WhisperForConditionalGeneration, pipeline

# Whisperのプロセッサとモデルをロード
processor = WhisperProcessor.from_pretrained("openai/whisper-small")
model = WhisperForConditionalGeneration.from_pretrained("openai/whisper-small")

# トランスフォーマーパイプラインをカスタマイズして作成
whisper_pipeline = pipeline(
    "automatic-speech-recognition",
    model=model,
    tokenizer=processor.tokenizer,
    feature_extractor=processor.feature_extractor,
    device="cuda"  # 必要に応じて"cuda"または"cpu"に変更
)

result = whisper_pipeline("path/to/audio.mp3")
print(result)
```

!!! Tip 
    **処理の順番イメージ**
    <br>   
    1. 音声データの入力  
       音声ファイルがパイプラインに渡される。
    <br>  
    2. 前処理（`WhisperProcessor`の`feature_extractor`）  
       音声データがサンプリングレートの調整や正規化などを経て、モデル入力用のテンソルに変換される。  
    <br>
    3. モデルによる推論（`WhisperForConditionalGeneration`）  
       前処理済みの音声データからテキストトークンが生成される。  
    <br>
    4. 後処理（`WhisperProcessor`の`tokenizer`）  
       生成されたトークンが人間が読めるテキストにデコードされる。  
    <br>
    5. **結果の出力**

       認識されたテキストが`result`として取得され、表示される。

<br>

#### pipelineを使用しないコード
pipelineを使用せずにより細かに設定したもの。

```python
import torch
from transformers import WhisperProcessor, WhisperForConditionalGeneration
import librosa

# モデル名の指定
model_name = "openai/whisper-small"

# WhisperProcessorとWhisperForConditionalGenerationの初期化
processor = WhisperProcessor.from_pretrained(model_name)
model = WhisperForConditionalGeneration.from_pretrained(model_name)

# モデルとデータをGPUに移動（可能な場合）
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model.to(device)

# 音声データの読み込みと前処理
audio_array, sampling_rate = librosa.load("path/to/audio.mp3", sr=16000)
inputs = processor(audio_array, sampling_rate=sampling_rate, return_tensors="pt")
inputs = {key: val.to(device) for key, val in inputs.items()}

# 言語とタスクを指定してデコーダーの入力を準備
forced_decoder_ids = processor.get_decoder_prompt_ids(language="ja", task="transcribe")

# モデルによるテキスト生成
generated_ids = model.generate(
    inputs["input_features"],
    forced_decoder_ids=forced_decoder_ids,
    max_length=448
)

# 生成されたトークンIDをテキストにデコード
transcription = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]

# 結果の表示
print("書き起こし結果：", transcription)
```

!!! Tip 
    **librosa**
    ここでlibrosaを用いて16kHzにリサンプリングしているが、  
    これは、whisperモデルは入力される音声データが16kHzを前提としているため。  
    pipelineではそれも含めて処理してくれていた。

<br>

### ファインチューニング
Hugging Faceのフレームワークを用いたファインチューニング方法が[こちら](https://huggingface.co/blog/fine-tune-whisper)に書いてあります。  
しかし、この通りに実装してもファインチューニングはできません🤗