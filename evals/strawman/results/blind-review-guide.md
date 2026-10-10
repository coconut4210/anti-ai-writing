# 盲评说明

请独立评审 `blinded/B01.txt` 至 `blinded/B12.txt`。不要读取 `blind-map.json`、`raw/`、`logs/` 或另一位评审的结果。

1. 使用 `../../rubric.md` 的硬失败定义和五项评分。
2. 使用 `blinded/manifest.jsonl` 找到文章对应的 `case_id`，再从 `../../generation-cases.jsonl` 读取核心论点与 `proposition_contract`。
3. 先列出文章中所有被反驳、纠正或防御性澄清的命题，再判断它们是否由用户原论点蕴含。
4. `hard_failure` 只能填写 `true` 或 `false`；若为 `true`，必须摘录最短充分证据。
5. 五项评分各填 0、1 或 2，并计算总分。
6. 不猜测文章属于基线版还是规则版。
7. 结果保存为单独 CSV，不修改其他评审文件。
