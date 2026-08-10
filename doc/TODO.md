# 既知の不具合と TODO

`ecology_dev` を `master` にマージした際（2026-08-10, `97eb83e`）の検証で判明した問題をまとめる。

各項目は gfortran 15.2.0 / Ubuntu (WSL2) 上で実測により確認した。再現手順を各項目に記載する。

## 優先度の概要

| # | 内容 | 影響 | 起因 |
|---|---|---|---|
| ~~[1](#1-ecosys_hiscsv-のヘッダとデータの列数が一致しない)~~ | ~~`ecosys_his.csv` のヘッダとデータの列数不一致~~ | 対応済み | マージ |
| ~~[2](#2-reef_flow-構成がビルドできない)~~ | ~~`reef_flow` 構成がビルド不可~~ | 対応済み（実行は入力データ待ち） | 既存 |
| [3](#3-blue_tide-を有効にするとコンパイルできない) | `BLUE_TIDE` 有効時にコンパイル不可 | 当該機能が使用不能 | 既存 |
| [4](#4-mod_inputf-num_header-が暗黙の-save-になっている) | `Num_header` の暗黙 SAVE | なし（整理のみ） | 既存 |
| ~~[5](#5-他4つのプロジェクト構成がコンパイルできない)~~ | ~~他4構成がコンパイル不可~~ | `chamber`・`coral_exp_T04` は対応済み。他2つは対象外 | 既存 |
| [6](#6-coral_nutrients-が有効化できない) | `CORAL_NUTRIENTS` が有効化できない | 当該機能が使用不能・**規模大** | 既存 |

---

## 1. `ecosys_his.csv` のヘッダとデータの列数が一致しない

**状態**: 対応済み（`mod_reef_ecosys.F` のヘッダ行にラベルを移植）

`ECOSYS_TESTMODE` の出力で、ヘッダ行が **24列**、データ行が **49列** となり、列名と数値が対応していない。25列ぶんの数値に列名がない状態。

### 原因

マージで両ブランチの異なる版が組み合わさったため。

- **ヘッダ行** … `src/mod_reef_ecosys.F:1383`（ecology_dev 由来）。SEAGRASS は `sgrass_Pg`, `sgrass_R`, `sgrass_Pn` の **3列**のみ
- **データ行** … `src/mod_reef_ecosys.F:1448`（master 由来）。SEAGRASS は `GridPhot` 〜 `PO4stockRatio` の **23列**、加えて `SEDIMENT_ECOSYS` のフラックス **5列**

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

## 2. `reef_flow` 構成がビルドできない

**状態**: 2-a・2-b・2-c とも対応済み。ビルドとリンクが通り、全 namelist も読める。ただし**入力データが未配置のため実行はまだできない**（2-d）。

`Projects/reef_flow/cppdefs.h` を使うと失敗していた。独立した原因が3つあった。

### 2-a. `FLOW_OUTPUT_INTERVAL` が未定義 — 対応済み（`8165c8c`）

```
src/mod_reef_flow.F:197:48:
  197 |         dsec=date*86400.0d0+FLOW_OUTPUT_INTERVAL*60.0d0
Error: Symbol 'flow_output_interval' at (1) has no IMPLICIT type
```

`Projects/reef_flow/cppdefs.h` だけが、他の全プロジェクトが持つ「出力間隔ブロック」を欠いていた。同じ値のブロックを追加して解消。

`src/mod_reef_flow.F:144` にあるコメントアウトされた `parameter` 定義は旧方式の名残で、`mod_coral.F:1974`、`mod_reef_ecosys.F:513`、`mod_sedecosys.F:782` にも同じものがある。ソース側の変更は不要。

これにより `ECOSYS_OUTPUT_INTERVAL` 未定義も併せて解消した。`main.F` が致命的エラーで打ち切られていたため表面化していなかったもの。

### 2-b. `write_env_vprof` に `USE mod_reef_flow` がない — 対応済み（`c88bb7f`）

```
src/mod_output.F:490:22:                        ← 行番号は修正前のもの
  490 |            , REEF(1)%Qrc(1,1), REEF(1)%Qch(1,1), REEF(1)%el (1,1)          &
Error: Symbol 'reef' at (1) has no IMPLICIT type
```

`mod_output.F` には `REEF(1)%...` を参照するサブルーチンが2つある。

| サブルーチン | REEF 参照 | `USE mod_reef_flow` |
|---|---|---|
| `write_env_data` | 680行 | あり（629行、`#if defined REEF_FLOW` 付き） |
| `write_env_vprof` | 493行 | 修正で追加（292行） |

出力行が両者で完全に同一なことから、ブロックをコピーした際に `USE` を持ってこなかったものと見られる。Fortran の `USE` はスコープ単位なので `write_env_data` のものは届かない。`write_env_vprof` に同じガード付き `USE` を追加して解消。

`REEF_FLOW` を define するのは `reef_flow` だけなので、他構成では当該行ごと無効化され表面化しなかった。

### 2-c. `main.F` の `reef_ecosys` 呼び出しにガードがない — 対応済み

```
main.F:(.text+0x14a8): undefined reference to `allocate_reef_ecosys_'
main.F:(.text+0x14d1): undefined reference to `initialize_reef_ecosys_'
main.F:(.text+0x3081): undefined reference to `reef_ecosys_'
```

`mod_reef_ecosys` は本体全体が `#if defined REEF_ECOSYS` で囲まれている（`src/mod_reef_ecosys.F:10`）。一方 `main.F` の3つの呼び出し（267, 275, 474行）は囲まれていない。

`reef_flow` は `REEF_ECOSYS` がコメントアウトされた「流動のみ」構成だったため、モジュール本体が空になり実体が見つからなかった。

`REEF_ECOSYS` は 2020-12-03 (`a670be2`) 時点では有効だったが、2022-10-27 の改修 (`f462cf1`) でコメントアウトされ、以後 `reef_flow` は更新されていなかった。約4年間ビルドできない状態が続いていたことになる。

取り得る対処は2つあり、`reef_flow` を「流動だけを見る構成」とするか「流動＋生態系」とするかで変わる。

1. **`main.F` の呼び出しを `#if defined REEF_ECOSYS` で囲む** — 流動のみモードを成立させる。ただし `main.F` はトレーサ配列など生態系側の変数を広く参照しているため、囲む範囲の見極めが要る。未検証
2. **`REEF_ECOSYS` を有効に戻す** — 流動＋生態系のフル構成にする

**選択肢2を採用した。** 項目5で `chamber` を直した結果、成立するようになったもの。`cppdefs.h` を2行変更した。

```c
Projects/reef_flow/cppdefs.h:14   /*#define REEF_ECOSYS*/       -> #define REEF_ECOSYS
Projects/reef_flow/cppdefs.h:34   #  define SEDIMENT_EMPIRICAL  -> コメントアウト
```

2行目が必要なのは、`SEDIMENT_EMPIRICAL` が `#if defined REEF_ECOSYS` の内側にあり、1行目だけ変えると死んだ経路（項目5参照）が有効になってしまうため。

これで有効になるのは `CORAL_POLYP`（+`CORAL_ZOOXANTHELLAE`, `CORAL_PHOTOINHIBITION`, `CORAL_SIZE_DYNAMICS`）、`FOODWEB`、`MACROALGAE`、`SEAGRASS`、`SEDIMENT_ECOSYS`、`NUTRIENTS`、`ORGANIC_MATTER`。

### 2-d. `reef_flow_01.in` の更新と入力データ — 入力データは未配置

`reef_flow_01.in` も2022年の改修前の形式のままで、ビルドが通った後も実行時に順に失敗した。

1. `&sedeco_config` が無い → `main.F:159` で停止
2. `&sgrass_config` が無い → `main.F:163` で停止
3. `&initial` が旧変数名 → `mod_param.F:337` で `Cannot match namelist object name doc1_0`

`&initial` をスカラー個別指定から配列形式へ移行し、不足の2グループを追加して解消した。

| 旧 | 新 |
|---|---|
| `DOC1_0`, `DOC2_0` | `DOC_0`（Ndom=2） |
| `POC1_0`, `POC2_0` | `POC_0`（Npom=3） |
| `Phyt1_0`〜`Phyt3_0` | `PhyC_0`（Nphy=4） |
| `Zoop1_0` | `ZooC_0`（Nzoo=1） |
| `PIC1_0` | `PIC_0`（Npim=2） |
| `p_coral1_0`, `p_coral2_0` | `p_coral_0`（Ncl=2） |
| `DON*_0`, `PON*_0`, `DOP*_0`, `POP*_0` | 削除（現行 namelist はコメントアウトされており受け付けない） |

旧ファイルに対応値が無かった `POC_0` の3要素目（粗大POC）と `PhyC_0` の4要素目（藍藻）は 0.0 とした。`&sedeco_config` は `Projects/seagrass` の値を流用したが、`p_sand_0 = 0.0`、`p_sgrass_0 = 0.0` のため実質不活性。

**残っているのは入力データのみ。** `reef_flow_01.in` が参照する強制データ13ファイルが `input/` に存在しない。

```
input/Ishigaki_frc_JMAobs_2018_{swrad,lwrad_down,Tair,Pair,wind,rain,Qair,cloud}.nc
input/PPFD.txt
input/level2017.txt, input/level2018.txt
input/temp2017.txt, input/temp2018.txt
```

データは作成済みとのことで、配置後に実行確認を行う。

> **注意**: このデータが無い状態で実行すると、Fortran の `open` 文が既定で存在しないファイルを作成するため、`input/` に空ファイルが生成される。実行前にデータを配置すること。

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

## 5. 他4つのプロジェクト構成がコンパイルできない

**状態**: `chamber`・`coral_exp_T04` は対応済み。`sedecosys_dev_muto`・`test` は**対応しない方針**（使用しないプロジェクトのため）。

`Projects/` 配下の13構成を全て確認したところ、`reef_flow` 以外にも4つが失敗していた。

| 構成 | 状態 |
|---|---|
| `coral_exp_T04` | 対応済み（`e04cf5c`） |
| `chamber` | 対応済み（`a0af00f`） |
| `sedecosys_dev_muto` | 対応しない。`cppdefs.h` の出力間隔ブロック欠落（項目 2-a と同型）なので、必要になれば同じ方法で直せる |
| `test` | 対応しない。`chamber` と同型 |

### 共通の根本原因

`c0b9c87`（2026-01-16「Bugfix: coral calcification process」）でサンゴの炭素プールが分割された。

```fortran
- real(8), pointer :: QC(:,:,:,:)     ! 初期値 300.0 umolC/cm2
+ real(8), pointer :: QCe(:,:,:,:)    ! 初期値  15.0
+ real(8), pointer :: QCv(:,:,:,:)    ! 初期値 290.0  ← Tanaka et al. 2018 のコメントを継承
+ real(8), pointer :: QCr(:,:,:,:), QCh(:,:,:,:)
```

このとき、当時どのプロジェクトも有効にしていなかった `CORAL_SIZE_DYNAMICS` と `CORAL_MUCUS` のブロックが取り残された。同様に `QC0(2) = [250.0d0, 250.0d0]` の宣言が `d09cbdf` で削除されていた。

`coral_exp_T04` は `CORAL_MUCUS` の `rQC` → `rQCe`、`chamber` は `CORAL_SIZE_DYNAMICS` の `%QC` → `%QCv` と `QC0` の復活で解消。プール選択の根拠は、粘液側は直後に `F_QCe` へ計上していること、サイズ動態側は閾値 `QC0=250` が分割前の `QC=300` と同オーダー（`QCe` は 15）であること。

### `chamber` で追加で必要だったもの

`SEDIMENT_EMPIRICAL` を無効化した。この経路は成立していない。

- `mod_sedecosys_empirical.F` はどの run スクリプトにも含まれない
- `USE mod_sedecosys_empirical` がソース中に存在しない
- 呼び出し側 `mod_reef_ecosys.F:1188` が rank2 の引数に `NH4(1)` を渡している

選択していたのは、当時ビルドできなかった3構成（`chamber`, `reef_flow`, `test`）だけだった。`chamber` と `reef_flow` では無効化済み。経験式の堆積物モデルを再び使うなら、モジュールの復活から別途必要になる。

また `mod_macroalgae.F` の `rQC` / `rDIC` が配列宣言なのにスカラーとして使われていた既存バグも解消した（`aC_resp` のエラーに隠れていた）。

なお `CORAL_NUTRIENTS` 配下にも同種の取り残しがあるが、規模が大きいため項目6として別建てにした。

### 再現手順（対応しない2構成）

```sh
for P in sedecosys_dev_muto test; do
  ( cd Projects/$P && sh run_win.sh )
done
```

---

## 6. `CORAL_NUTRIENTS` が有効化できない

**状態**: 未対応 / 規模大

サンゴの窒素・リン動態を扱うオプション。**どのプロジェクトも有効にしておらず**、そのため長期間コンパイルされないまま周辺の改修から取り残されている。有効化すると `mod_coral.F` だけで **21件**のエラーが出る。

他のモジュール（`mod_reef_ecosys.F`, `main.F` など）にエラーは波及しないので、修正は `mod_coral.F` に閉じる。

### 再現手順

`Projects/coral/cppdefs.h:55` のコメントを外してビルドする。

```sh
sed -i 's|^/\*#\( *\)define CORAL_NUTRIENTS\*/|#\1define CORAL_NUTRIENTS|' Projects/coral/cppdefs.h
cd Projects/coral && sh run_win.sh
```

### 問題の内訳

4種類に分かれる。上から順に直さないと、後続のエラーが隠れて見えない。

**(1) 構文の破損（2箇所）**

`mod_coral.F:1100〜1101` — 継続行の `&` が無く、2文に分断されている。

```fortran
    c_SQC=min((Flux_NH4 +Flux_NO3 )*c_CNP(nC)/c_CNP(nN)     ← 末尾に & が必要
                 ,Flux_PO4 *c_CNP(nC)/c_CNP(nP))
```

`mod_coral.F:1364〜1366` — 逆に `&` が余分で、次の代入文と連結されている。

```fortran
    F_Cgrowth(iCt) = g_max(n)*min( 1.0d0 - QC0(n)/CORAL(ng)%QCv(iCt,n,i,j) ,    &
                          min(1.0d0 - QN0(n)/CORAL(ng)%QNv(iNt,n,i,j),     &
                              1.0d0 - QP0(n)/CORAL(ng)%QPv(iPt,n,i,j) ) )  &   ← この & が余分
    F_Cgrowth(iCt) = max(F_Cgrowth(iCt), 0.0d0)
```

**(2) 炭素プール分割に伴う旧名参照**

項目5と同じく `c0b9c87` の分割に追随できていない。窒素・リン側も `QN` → `QNe`/`QNv`/`QNr`/`QNh`、`QP` → `QPe`/… と分割されている。

| 行 | 内容 |
|---|---|
| 1020 | `CORAL(ng)%QN (isp,n,i,j)` |
| 1103 | `CORAL(ng)%QC(n,i,j)` （添字数も旧形式のまま） |
| 2004, 2005 | `ZOOX(ng)%QN`, `ZOOX(ng)%QP`, `ZOOX(ng)%QC` |
| 2231 | `ZOOX(ng)%QN`, `ZOOX(ng)%QP` |

`t_coral` / `t_zoox` のどちらのプールに対応させるかは、項目5と同様に用途から判断する必要がある。

**(3) 未宣言の変数**

宣言が失われている、または一度も書かれていない。

```
rQN, rQP, rPO4coe, c_SQC, c_SQN, c_SQP, c_CNP, nC, nN, nP, tempb,
F_Ngrowth, F_Pgrowth
```

`c_CNP(nC)` / `c_CNP(nN)` / `c_CNP(nP)` は C:N:P 比を引く配列とその添字定数と見られるが、定義が見当たらない。`QN0` と `QP0` は宣言されている。

**(4) 未実装のプレースホルダ**

`CORAL_MUCUS` と併用したときのみ通る箇所（`mod_coral.F:1139` の `#  if defined CORAL_NUTRIENTS` 配下）。

```fortran
      F_Nmucus(m) = ???
      F_Pmucus(m) = ???
```

粘液に含まれる窒素・リンの放出量をどう決めるかが未定。**ここはモデルの定式化そのものが必要**で、機械的な修正では済まない。

`CORAL_MUCUS` を有効にする `coral_exp_T04` で `CORAL_NUTRIENTS` も併せて有効化する場合は、この2行の実装が前提になる。

### 進め方の目安

(1) と (3) は機械的に直せる。(2) は項目5と同じ判断（どのプールを指すか）が要る。(4) はモデルの定式化を決める必要があり、性質が異なる。

そのため「(1)(3) を直して残りのエラーを可視化する」→「(2) をプールごとに判断」→「(4) を検討」の順が現実的。

---

## 検証環境

- gfortran 15.2.0 (Ubuntu 15.2.0-16ubuntu1)
- Linux 6.18.33.2-microsoft-standard-WSL2

### 構成ごとのビルド状況

`Projects/` 配下の全13構成を確認した結果。

| 状態 | 構成 |
|---|---|
| ビルド・リンクとも成功 | `chamber`, `coral`, `coral_d13C`, `coral_exp_T04`, `foodweb`, `oyster`, `pelagic_bentic`, `reef_flow`, `sedecosys`, `seagrass`, `seagrass_chamber` |
| 対応しない（使用しないプロジェクト） | `sedecosys_dev_muto`, `test`（項目5） |

実行まで確認した構成は `seagrass` のみ（1日分の積分完走と出力 CSV の照合）。

`reef_flow` は入力データ未配置のため実行未確認（項目 2-d）。`chamber` は `.in` ファイルが無く、`runeco_s*.sh` が `mod_*.F90` や `ecosys_test5.F90` という現存しないファイル名を参照しているため実行未確認。
