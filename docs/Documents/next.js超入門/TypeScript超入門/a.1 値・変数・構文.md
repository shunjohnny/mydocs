---
title: a.1 値・変数・構文
tags:
  - TypeScript
---

## 値・変数・演算

| 型               | 説明                                                         |
|------------------|--------------------------------------------------------------|
| 数値 (number)    | 数の値。TypeScriptでは、数の値はすべてnumberという種類の値として扱われる |
| テキスト (string) | テキストを扱うための値                                       |
| 真偽値 (boolean) | 「真か偽か」という二者択一の状態を示すための値             |

| 宣言方法   | キーワード | スコープ                    | 再代入 | 特徴・注意点                                                   |
|------------|------------|-----------------------------|--------|---------------------------------------------------------------|
| 変数       | var      | 関数スコープ<br>関数内でのみ有効 | 可能   | 古い構文<br>ブロックスコープを無視するため<br>非推奨       |
| 変数       | let      | ブロックスコープ<br>{}内でのみ有効| 可能   | 現在の推奨される変数宣言方法<br>スコープがブロックに限定    |
| 定数       | const    | ブロックスコープ              | 不可   | 再代入不可の定数を宣言<br>オブジェクトや配列のプロパティは<br>変更可能 |

下記のように型を指定することも可能

```typescript title="型指定の例"
let x: number = 100;      // 数値型の変数
const y: string = "Hello"; // 文字列型の定数
```

### 値の演算
演算子はJavascriptと同様  

### 配列
TypeScriptでは、配列の型を指定することが可能

```typescript title="配列の使用例"
let x: number[] = [];
x[0] = 100;
x[1] = 200;
x[2] = 300;
x[5] = x[0] + x[1] + x[2];
console.log(x); // [100, 200, 300, undefined, undefined, 600]
```

### 配列の定数

- 配列を定数として定義するにはconstを使用
  ただし、constで宣言しても変更可能
  ```typescript title="配列の定数"
    const x: number[] = [1, 2, 3];
    x[0] = 10; // 許可される
  ```


- 完全に不変の配列とするにはreadonlyキーワードを使用
  ```typescript title="配列の定数"
    const x: readonly number[] = [1, 2, 3];
    // x[0] = 10; // エラー: 読み取り専用の配列の要素は変更できません
  ```

## タプルについて

複数の異なる型の値をまとめて扱うために使用  
下記のように配列arrに異なる値を代入することができる

```typescript title="タプル"
const arr: [string, string, number][] = []

arr[0] = ['taro', 'yamada', 39]
arr[1] = ['hanako', 'tanaka', 28]
arr[2] = ['sachiko', 'sato', 17]
```

## 列挙型について

複数の値から1つを選ぶ際に使用

```typescript title="列挙型enum"
enum color {white,black,red,green,blue}

const arr:color[] = []

arr[0] = color.red
arr[1] = color.green
arr[2] = color.blue

for (let item of arr) {
    console.log(item + ':' + color[item])
}
```

![alt text](<../../../images/a.1 値・変数・構文/a.1 値・変数・構文_J0133291.png>)

## 制御構文

#### 条件分岐
```typescript title=""
if ( 条件 ) {
    条件成立時の処理
} else {
    不成立時の処理
}
```

#### 多項分岐
```typescript title=""
switch ( 対象 ) {
    case 値1:
        値1のときの処理
        break
    case 値2:
        値2のときの処理
        break
    ……必要なだけcaseを用意……
    default:
        どれにも一致しないときの処理
}
```

#### while
```typescript title=""
while ( 条件 ) {
    繰り返す処理
}
```


```typescript title=""
do {
    繰り返す処理
} while ( 条件 )
```

#### for
```typescript title=""
for ( 初期化 ; 条件 ; 後処理 ) {
    繰り返す処理
}
```

```typescript title="配列のfor文"
for ( let 変数 in 値 ) {
    繰り返す処理
}

for ( let 変数 of 値 ) {
    繰り返す処理
}
```