---
title: "WiscKey 论文阅读笔记"
date: 2022-03-26T12:30:00+08:00
draft: false
categories:
  - PaperReading
tags:
  - notes
---

# WiscKey 论文阅读笔记

WiscKey: Separating Keys from Values in SSD-conscious Storage

## 1. 资源
论文：

- Lanyue Lu, Thanumalayan Sankaranarayana Pillai, Andrea C. Arpaci-Dusseau, and Remzi H. Arpaci-Dusseau. 2016. WiscKey: Separating keys from values in SSD-conscious storage. In *Proceedings of the 14th USENIX Conference on File and Storage Technologies (FAST’16)*. https://dl.acm.org/doi/pdf/10.1145/3033273
- Lanyue Lu, Thanumalayan Sankaranarayana Pillai, Hariharan Gopalakrishnan, Andrea C. Arpaci- Dusseau, and Remzi H. Arpaci-Dusseau. 2017. WiscKey: Separating keys from values in SSD-conscious storage. ACM Trans. Storage 13, 1, Article 5 (March 2017), 28 pages. https://www.usenix.org/system/files/conference/fast16/fast16-papers-lu.pdf

[fast2016 Conference 上演讲语音记录](http://0b4af6cdc2f0c5998459-c0245c5c937c5dedcca3f1764ecc9b2f.r43.cf2.rackcdn.com/fast16/lu.mp3)

[演讲幻灯片](https://www.usenix.org/sites/default/files/conference/protected-files/fast16_slides_lu.pdf)

## 2. 论文总结

### 2.1 The problem

LevelDB

- 写放大
-  LevelDB 是为了 HDD 设计的，没有针对 SSD 的优化

### 2.2 The solution

- 基于 LevelDB 做优化。

- 分离 key 和 value，使用 SSD 的特性。
  - 将 key 和 **value 的地址**存储在 LST-tree 中；将 key 和 value 存储在**只能追加**的 `value-log` 中。
  - 每次 load ，先追加到 `value-log`，再插入到 LSM-tree。
  - 每次 query，先从 LSM-tree 中找 key 和 value 的地址，然后在 `value-log` 中点查 value。
  - range query 利用 SSD 多线程随机查询的性能优势。
  - 引入 GC 来解决更新和删除的问题，释放 `value-log` 的空间：从 `value-log` 头读，拿 Key 去 LST-tree 中查找，有效的话再追加到 `value-log` 末尾*


### 2.3 Pros vs. Cons in theory

||Pros|Cons|
|---|---|---|
|1|缩小 LSM-tree 大小, 从理论上减少 写放大|每次 GC，没有更新或删除的数据还会被重新写一次，会增加一次写放大。|
|2|Range query 利用 SSD 多线程随机读不弱于顺序读的性能|故障恢复难度增加|

### 2.4 Experiments

1. 测试 LevelDB 的读写放大。
2. 测试了 SSD 顺序读和随机读的性能。
3. 和 LevelDB 在 Load/Query/Range Query 的性能对比测试，写放大测试，测试平台是 LevelDB 的 microbenchmark。
5. 和 LevelDB、RocksDB 在 YCSB 上的测试。



