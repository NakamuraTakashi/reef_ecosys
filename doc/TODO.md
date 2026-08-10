# 既知の不具合と TODO

`ecology_dev` を `master` にマージした際（2026-08-10, `97eb83e`）の検証で判明した問題をまとめる。

各項目は gfortran 15.2.0 / Ubuntu (WSL2) 上で実測により確認した。再現手順を各項目に記載する。

## 優先度の概要

| # | 内容 | 影響 | 起因 |
|---|---|---|---|
| ~~[1](#1-ecosys_hiscsv-のヘッダとデータの列数が一致しない)~~ | ~~`ecosys_his.csv` のヘッダとデータの列数不一致~~ | 対応済み | マージ |
| [2](#2-reef_flow-構成がコンパイルできない) | `reef_flow` 構成がコンパイル不可 | 当該構成が使用不能 | 既存 |
| [3](#3-blue_tide-を有効にするとコンパイルできない) | `BLUE_TIDE` 有効時にコンパイル不可 | 当該機能が使用不能 | 既存 |
| [4](#4-mod_inputf-num_header-が暗黙の-save-になっている) | `Num_header` の暗黙 SAVE | なし（整理のみ） | 既存 |

---

## 1. `ecosys_his.csv` のヘッダとデータの列数が一致しない

**状態**: 対応済み（`mod_reef_ecosys.F` のヘッダ行にラベルを移植）

`ECOSYS_TESTMODE` の出力で、ヘッダ行が **24列**、データ行が **49列** となり、列名と数値が対応していない。25列ぶんの数値に列名がない状態。

### 原因

マージで両ブランチの異なる版が組み合わさったため。

- **ヘッダ行** … `src/mod_reef_ecosys.F:1383`（ecology_dev 由来）。SEAGRASS は `sgrass_Pg`, `sgrass_R`, `sgrass_Pn` の **3列**のみ
- **データ行** … `src/mod_reef_ecosys.F:1434`（master 由来）。SEAGRASS は `GridPhot` 〜 `PO4stockRatio` の **23列**、加えて `SEDIMENT_ECOSYS` のフラックス **5列**

master では対応するヘッダが `mod_output.F` の `write_ecosys_his_lavel` にあり整合していたが、ecology_dev が出力系を再構成した際に同ルーチンと呼び出し側を削除。マージで ecology_dev 側（削除）を採用した結果、master のデータ行だけが残った。

### 実施した対応

`src/mod_reef_ecosys.F:1383` のヘッダに、master の `write_ecosys_his_lavel` が持っていたラベルを移植した。ラベル定義は以下で参照できる。

```sh
git show 613a115:src/mod_output.F | sed -n '723,768p'
```

`SEAGRASS` ブロックを次の23列に置換し、`SEDIMENT_ECOSYS` ブロックにフラックス5列を追加した。

```
sgrass_GrossPhot, sgrass_Grow, sgrass_Phot_lim, sgrass_Grow_lim,
sgrass_Resp, sgrass_NetPhot, sgrass_Dieoff,
sgrass_Wt, sgrass_LfWt, sgrass_RtWt, sgrass_LAI, sgrass_ELAP,
sgrass_ocean_flux_DIC, sgrass_ocean_flux_DO,
sgrass_ocean_flux_NH4, sgrass_ocean_flux_NO3, sgrass_ocean_flux_PO4,
sgrass_DOstockRatio, sgrass_DICstockRatio, sgrass_CH2OstockRatio,
sgrass_NH4stockRatio, sgrass_NO3stockRatio, sgrass_PO4stockRatio
```

```
sedeco_fluxDIC, sedeco_fluxDO, sedeco_fluxNO3, sedeco_fluxNH4, sedeco_fluxPO4
```

なお master のヘッダは NH4/NO3/PO4 系のラベルを `#if defined SEAGRASS_LEAF_NUTRIENT_UPTAKE` で囲っていなかった。データ行側は囲っているため、**同マクロが無効な構成では master 時点でも不一致が生じていた**。移植にあたってはデータ行と同じガードを付与し、この潜在的な不整合も解消してある。

### 確認結果

修正前は 24列 / 49列。修正後は両方 49列で一致する。

```sh
cd Projects/seagrass && sh run_win.sh
awk -F',' 'NR<=2{print NR": "NF" 列"}' output/01-ecosys_his.csv
# 1: 49 列
# 2: 49 列
```

関連マクロ（`CORAL_POLYP`, `SEAGRASS`, `MACROALGAE`, `SEDIMENT_ECOSYS`, `CARBON_ISOTOPE`,
`SEAGRASS_LEAF_NUTRIENT_UPTAKE`）の 64 通りすべての組み合わせで、ヘッダとデータの
列数が一致することを確認済み。

---

## 2. `reef_flow` 構成がコンパイルできない

**状態**: 未対応 / マージ前から存在（master・ecology_dev 双方で同一エラー）

`Projects/reef_flow/cppdefs.h` を使うとコンパイルが通らない。独立した原因が2つある。

### 2-a. `FLOW_OUTPUT_INTERVAL` が未定義

```
src/mod_reef_flow.F:197:48:
  197 |         dsec=date*86400.0d0+FLOW_OUTPUT_INTERVAL*60.0d0
Error: Symbol 'flow_output_interval' at (1) has no IMPLICIT type
```

`src/mod_reef_flow.F:144` で定義がコメントアウトされたままになっている。

```fortran
#if defined REEF_FLOW_TESTMODE
!    real(8), parameter :: FLOW_OUTPUT_INTERVAL  = 5.0d0    ! Output interval (min)
    real(8), save :: dsec = 0.d0 !sec
#endif
```

コメントを外すか、他モジュールと同様に `cppdefs.h` 側で定義する。

### 2-b. `write_env_vprof` に `USE mod_reef_flow` がない

```
src/mod_output.F:490:22:
  490 |            , REEF(1)%Qrc(1,1), REEF(1)%Qch(1,1), REEF(1)%el (1,1)          &
Error: Symbol 'reef' at (1) has no IMPLICIT type
```

`write_env_vprof`（`src/mod_output.F:287`〜）は `#if defined REEF_FLOW` のブロックで `REEF` を参照するが、USE 文は `mod_param` と `mod_geochem` のみ。同ファイルの `write_env_data`（626行目付近）には `#if defined REEF_FLOW / USE mod_reef_flow / #endif` があるので、同じものを追加すればよい。

上記2件により `mod_reef_flow.mod` と `mod_output.mod` が生成されず、`main.F` まで連鎖して失敗する。

### 再現手順

```sh
cd Projects/reef_flow && sh run.sh
```

---

## 3. `BLUE_TIDE` を有効にするとコンパイルできない

**状態**: 未対応 / マージ前から存在

現在 `BLUE_TIDE` を define しているプロジェクトはないため通常のビルドには影響しないが、有効化するとコンパイルが通らない。

### 原因

`src/main.F` に `BLUE_TIDE` の記述が一切ない一方、`src/mod_reef_ecosys.F` は同マクロ下で `reef_ecosys` の引数を4つ追加している。

- 入力: `H2S`, `S0`
- 出力: `dH2S_dt`, `dS0_dt`

呼び出し側と仮引数リストがずれるため、以降の引数が総崩れになり rank mismatch が10件発生する。

```
Error: Rank mismatch in argument 'h2s' at (1) (rank-2 and scalar)
Error: Rank mismatch in argument 's0' at (1) (rank-2 and scalar)
Error: Rank mismatch in argument 'sgd_ta' at (1) (scalar and rank-1)
...
Error: Rank mismatch in argument 'wcal' at (1) (rank-1 and scalar)
```

### 対応方針

`main.F` の `CALL reef_ecosys` に `#if defined BLUE_TIDE` ブロックを追加し、`H2S`, `S0`, `dH2S_dt`, `dS0_dt` を渡す。対応する配列の宣言と初期化も併せて必要。

`mod_reef_ecosys.F` 側の該当箇所は次で確認できる。

```sh
grep -n "BLUE_TIDE" src/mod_reef_ecosys.F
```

### 再現手順

任意の `cppdefs.h` に `# define BLUE_TIDE` を追加してビルドする。

---

## 4. `mod_input.F`: `Num_header` が暗黙の SAVE になっている

**状態**: 未対応 / 実害なし

```fortran
src/mod_input.F:52:    integer :: Num_header = 0
```

Fortran では宣言時に初期化子を書くと暗黙の `SAVE` 属性が付き、初期化はプログラム開始時に一度だけ実行される。呼び出しごとにはゼロ初期化されない。

ただし本変数は使用前に必ず `Num_header = 0`（または `4`, `1`）が代入され、`read_data` 自体も `main.F:247` で起動時に1回呼ばれるのみのため、**実害はない**。宣言と代入を分けるか `save` を明示すれば意図が明確になる。

### 関連する対応済みの修正

同じ機構による不具合として、以下は対応済み。

- `571b559` — `mod_foodweb.F` の `d*_dt` 系。`decomposition` が `intent(inout)` で加算する変数が全タイムステップにわたり累積していた
- `0a08ab6` — `mod_geochem.F` の `l2mol` を `parameter` 化（`!$acc routine seq` 下の静的変数を回避）、`mod_reef_flow.F` の `dsec` に `save` を明示

全ソースを走査済みで、`d*_dt` という名前で同じ問題が残っている箇所は他にない。

---

## 検証環境

- gfortran 15.2.0 (Ubuntu 15.2.0-16ubuntu1)
- Linux 6.18.33.2-microsoft-standard-WSL2

### コンパイルが確認できている構成

`coral`, `coral_d13C`, `foodweb`, `oyster`, `pelagic_bentic`, `sedecosys`, `seagrass`, `seagrass_chamber`

`seagrass` 構成では 1 日分の積分完走まで確認済み。
