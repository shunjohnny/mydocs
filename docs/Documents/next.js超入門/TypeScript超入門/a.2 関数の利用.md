---
title: a.2 関数の利用
tags:
  - TypeScript
---

## 関数の定義

```typescript title="関数の定義"
function 名前 (引数) {
    ---実行する処理---
}
```

```typescript title="戻り値のある関数の定義"
function 名前 (引数): 型 {
    ---実行する処理---
}
```

実用例で確認する
```typescript title="10~20の整数が素数か確認"
funciont prime(num:number):boolean {
    let flg = true
    for (let i = 2; i < num/ 2; i++) {
        if (num % i == 0) {
            flg = false
            break
        }
    }
    return flg
}

const arr:number[] = [10,11,12,13,14,15,16,17,18,19,20]

for(let item of arr) {
    console.log(item + '=' + prime(item))
}
```

## 複数の戻り値

## オプション引数と初期値

## 可変長引数について

## 値としての関数

## 関数の引数・戻り値に関数を使う

```typescript title=""
```

```typescript title=""
```