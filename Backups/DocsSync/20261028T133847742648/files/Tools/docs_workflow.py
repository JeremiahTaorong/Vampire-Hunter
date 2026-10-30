#!/usr/bin/env python3
"""Local document bookkeeping only; never approves designs or operates Unity/Git."""
from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
import argparse
import hashlib
import json
import os
import re
import shutil
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
GENERATED = ('Docs/PROJECT_STATUS.md', 'Docs/02_Systems/SYSTEM_INDEX.md',
             'Docs/01_Coverage/System_Coverage_Tracking.md',
             'Docs/03_Management/REVIEW_REGISTER.md', 'Docs/05_Testing/TEST_INDEX.md')

def read_json(rel):
    return json.loads((ROOT / rel).read_text(encoding='utf-8'))

def digest(p):
    return hashlib.sha256(p.read_bytes()).hexdigest()

def safe(rel):
    if not isinstance(rel, str) or not rel or Path(rel).is_absolute():
        raise ValueError('expected nonempty project-relative path')
    p = ROOT / rel
    if not p.resolve().is_relative_to(ROOT) or '..' in Path(rel).parts:
        raise ValueError('path escapes project: ' + rel)
    # Reject symlinks, including in parents, before any managed write/copy.
    if any(x.is_symlink() for x in (p, *p.parents) if x.is_relative_to(ROOT)):
        raise ValueError('symlink is not a managed document: ' + rel)
    return p

def parse_baseline(manifest):
    scm = next(x['path'] for x in manifest['files'] if x['role'] == 'SCM')
    records = []
    for block in safe(scm).read_text(encoding='utf-8').split('\n## '):
        if block.startswith(('3. R', '4. F')):
            for ln in block.splitlines():
                if ln.startswith('| `'):
                    rid, summary, owner, collab = [x.strip() for x in ln.split('|')[1:-1]]
                    records.append(dict(id=rid.strip('`'), summary=summary, owner=owner,
                                        collaborators=re.findall(r'S\d{2}|ENG|PM', collab)))
    return records

def load_validate():
    errors = []
    manifest = read_json('Docs/00_Baseline/Baseline_Manifest.json')
    if len(manifest['files']) != 5:
        errors.append('initial inventory must retain all 5 files')
    for item in manifest['files']:
        p = safe(item['path'])
        if not p.is_file() or digest(p) != item['sha256'] or p.stat().st_size != item['bytes']:
            errors.append('baseline/reference drift or missing: ' + item['path'])
        backup = safe('Backups/Bootstrap_2026-10-28/originals/' + item['path'])
        if not backup.is_file() or digest(backup) != item['sha256']:
            errors.append('initial recovery copy missing/changed: ' + item['path'])
    state = read_json('Docs/03_Management/workflow_state.json')
    reqs = read_json('Docs/01_Coverage/requirements.json')['records']
    expected = {f'R{i:02}' for i in range(1,85)} | {'R03.1'} | {f'F{i:02}' for i in range(1,39)}
    if len(reqs) != 123 or {r['id'] for r in reqs} != expected:
        errors.append('requirement IDs must be exactly R01-R84 + R03.1 + F01-F38, once each')
    if reqs != parse_baseline(manifest):
        errors.append('requirement mapping/summary changed from original SCM; approved rebaseline required')
    systems = state['systems']
    if [s['id'] for s in systems] != [f'S{i:02}' for i in range(1,14)]:
        errors.append('system list must contain S01-S13 exactly once, in order')
    for s in systems:
        if not safe(s['template']).is_file():
            errors.append('missing independent template: ' + s['id'])
        if s['design_status'] not in {'Template','Draft','AwaitingReview','Approved'}:
            errors.append('invalid design status: ' + s['id'])
        if s['document'] and not safe(s['document']).is_file():
            errors.append('missing draft: ' + s['id'])
        if s['design_status'] != 'Template' and not s['document']:
            errors.append('draft/review requires a document: ' + s['id'])
        if s['development_status'] != 'NotStarted' and state['phase'].startswith('Phase2'):
            errors.append('development is outside current Phase2 scope: ' + s['id'])
        if s['design_status'] == 'Approved':
            found = False
            for a in state['approvals']:
                if a.get('system') != s['id'] or a.get('version') != s['version']:
                    continue
                if (a.get('decision') == 'Approved' and a.get('approver') == 'user'
                    and a.get('sha256') == digest(safe(s['document']))
                    and all(a.get(k) for k in ('date','quote','source','evidence'))):
                    p = safe(a['evidence'])
                    if p.is_file() and a['quote'] in p.read_text(encoding='utf-8'):
                        found = True
            if not found:
                errors.append('Approved lacks matching explicit-user evidence/version/hash: ' + s['id'])
    tests = state['tests']
    if [t['id'] for t in tests] != [f'T{i:02}' for i in range(1,17)]:
        errors.append('original tests must remain T01-T16 exactly once')
    for t in tests:
        if t['status'] not in {'NotRun','Passed','Failed','Blocked'}:
            errors.append('invalid test status: ' + t['id'])
        if t['status'] in {'Passed','Failed'}:
            if not t.get('evidence') or not safe(t['evidence']).is_file():
                errors.append('test result requires actual evidence file: ' + t['id'])
            if not all(t.get(k) is not None and t.get(k) != '' for k in
                       ('mode','environment','revision','expected','actual','run_at','exit_code')):
                errors.append('test result metadata incomplete: ' + t['id'])
            if t['status'] == 'Passed' and t.get('exit_code') != 0:
                errors.append('Passed requires successful exit code: ' + t['id'])
    approved = sum(s['design_status'] == 'Approved' for s in systems)
    plans = [p for pattern in ('Project_Plan.md','Task_Registry.md') for p in ROOT.rglob(pattern)
             if 'Backups' not in p.relative_to(ROOT).parts]
    if approved < 13 and (plans or state['development_tasks_created'] or state['phase'].startswith(('Phase3','Phase4'))):
        errors.append('phase gate: all 13 current designs need explicit approval before plans/tasks/development')
    if errors:
        raise ValueError('\n'.join(errors))
    return manifest, state, reqs

def link(rel, from_file):
    return Path(os.path.relpath(ROOT/rel, (ROOT/from_file).parent)).as_posix()

def render(manifest, state, reqs):
    out = {}
    systems = {s['id']: s for s in state['systems']}
    approved = sum(s['design_status'] == 'Approved' for s in systems.values())
    passed = sum(t['status'] == 'Passed' for t in state['tests'])
    header = '> 自动生成；源：workflow_state.json + requirements.json + 原始 SCM。不要手工改此派生文件。\n\n'
    f = GENERATED[0]
    lines = ['# Vampire Hunter — 项目状态', '', header,
             f"更新日期：{state['updated_date']}（Asia/Shanghai）。当前阶段：{state['phase']}。", '',
             f'系统明确批准：**{approved}/13**；开发状态为 NotStarted 的系统：**{sum(s["development_status"] == "NotStarted" for s in systems.values())}/13**；基准测试通过：**{passed}/16**。', '',
             '当前交付：阶段 1 管理规范与恢复机制；阶段 2 的 13 份独立模板、S01 v0.1 初稿。交付物创建不代表用户审阅通过或游戏完成。', '',
             '## 当前行动', '', state['next_action'], '',
             '- [S01 v0.1 待审正文](02_Systems/S01_Player_Control.md)：重点看 §9 的 Q1–Q6。',
             '- [基准与文件名差异](00_Baseline/BASELINE_INDEX.md)；[目录/Git/Unity 检查](03_Management/INITIAL_INSPECTION.md)。',
             '- [13 系统目录与状态](02_Systems/SYSTEM_INDEX.md)；[动态需求覆盖](01_Coverage/System_Coverage_Tracking.md)。',
             '- [审阅记录](03_Management/REVIEW_REGISTER.md)；[变更日志](03_Management/CHANGE_LOG.md)；[测试索引](05_Testing/TEST_INDEX.md)。',
             '- [同步与恢复用法](03_Management/RECOVERY_AND_SYNC.md)；[本次文档校验记录](03_Management/Evidence/BOOTSTRAP_VALIDATION.md)。', '',
             '## 阶段门与限制', '',
             'S02–S13 尚未起草；模板不是初稿。全部 13 份明确确认后才生成 Project_Plan.md / Task_Registry.md；当前没有开发任务 ID 或技术方案批准。', '',
             '目录原有 5 份 Markdown 全部保留；未发现 Git 或 Unity 工程；未创建工程、未编写玩法代码、未提交 Git。Unity/平台/组员/正式截止日/Rubric 未知（O-11），后续计划阶段采集。', '',
             'R/F 123 条都有主责映射，其中 3 条 ENG、2 条 PM。映射率不是细化率、批准率、实现率或测试通过率。T01–T16 的当前状态见测试索引；本轮没有 Unity 测试证据。', '',
             '## 继续工作', '',
             '先读根目录 AGENTS.md，按基准索引读取来源。更新前快照，修改后运行 sync 与 check。脚本不自动批准，不执行外部操作，不监视后台变化。初始副本在 Backups/Bootstrap_2026-10-28；导出恢复不覆盖当前文件。']
    out[f] = '\n'.join(lines).strip()+'\n'
    f = GENERATED[1]
    rows = ['# S01–S13 系统目录', '', header,
            '| 系统 | 独立模板 | 当前策划 | 版本 | 设计状态 | 开发状态 | 主责 R/F |',
            '|---|---|---|---|---|---|---:|']
    for s in systems.values():
        doc = f"[正文]({link(s['document'],f)})" if s['document'] else '未起草'
        rows.append(f"| {s['id']} {s['name']} | [模板]({link(s['template'],f)}) | {doc} | {s['version']} | {s['design_status']} | {s['development_status']} | {sum(r['owner']==s['id'] for r in reqs)} |")
    rows += ['', '模板只有来源索引和填写提示，不能视为系统策划已完成。每个系统确认后再推进下一份；SCM 建议审阅顺序：S01 → S02 → S03 → S04 → S06 → S05 → S08 → S07 → S09 → S10 → S11 → S13 → S12。', '',
             'ENG/PM 分别保留工程与项目管理要求，不创建额外纯游戏系统。所有 S 文档均应按同一结构填写目标、冻结规则、玩家流程、状态边界、契约、开放问题、验收场景和审阅记录。']
    out[f] = '\n'.join(rows).strip()+'\n'
    f = GENERATED[2]
    rows = ['# System Coverage — 当前追踪', '', header,
            '原始 SCM 保持不变；下表严格保留 123 条 ID、唯一主责、协作与原摘要。正文细化需要逐项审阅，不凭映射或文件存在宣称覆盖完成。', '',
            '| 需求 | 基准摘要 | 主责 | 协作 | 当前策划/模板 | 设计阶段 | 实现证据 |',
            '|---|---|---|---|---|---|---|']
    for r in reqs:
        s = systems.get(r['owner'])
        if s:
            p = s['document'] or s['template']
            doc = f"[{s['id']}]({link(p,f)})"
            phase = s['design_status']
        else:
            doc, phase = '后续阶段保留', 'Deferred'
        rows.append(f"| {r['id']} | {r['summary']} | {r['owner']} | {', '.join(r['collaborators']) or '—'} | {doc} | {phase} | 无；未实施 |")
    scm_path = next(x['path'] for x in manifest['files'] if x['role']=='SCM')
    rows += ['', f'[原始 SCM（N 节拍、C 契约、O 开放项、T 测试定义）]({link(scm_path,f)})。N-P/N-01…N-08/N-E 共 10；C-01…C-11 共 11；O-01…O-11 共 11 均沿用基准，不因本轮建模板关闭。', '',
             'S01 主责 10 条已在正文 §2 展开且待审；协作系统仍为模板。T11/T12/T13 已关联 S01 设计验收场景，但全部未执行。后续任务 ID 与证据列要在计划获准后扩展，当前未分配。']
    out[f] = '\n'.join(rows).strip()+'\n'
    f = GENERATED[3]
    rows = ['# 系统审阅登记', '', header,
            '只有用户明确确认具体版本才可批准。文件变化会使旧摘要批准失效；脚本拒绝无证据的 Approved，不生成批准。', '',
            '| 系统 | 版本 | 当前状态 | 用户批准记录 |', '|---|---|---|---|']
    for s in systems.values():
        approvals = [a for a in state['approvals'] if a.get('system')==s['id']]
        detail = '; '.join(f"{a['decision']} {a['version']} · [原话]({link(a['evidence'],f)})" for a in approvals) or '无'
        rows.append(f"| {s['id']} | {s['version']} | {s['design_status']} | {detail} |")
    rows += ['', 'S01 首次审阅：正文 §9 Q1–Q6；待用户逐项确认或指出修改。没有得到确认前，不起草 S02。批准内容/边界须保存在 workflow_state 与 Review_Evidence；不得把旧版本批准套用到新版本。']
    out[f] = '\n'.join(rows).strip()+'\n'
    f = GENERATED[4]
    scm = safe(scm_path).read_text(encoding='utf-8')
    rows = ['# T01–T16 基准测试索引', '', header,
            '这些是 GDD/SCM 既有设计验收用例，不是已执行测试，也不是完整测试计划。文档脚本的校验日志不能填作这些用例通过的证据。', '',
            '| 用例 | 验证目标（原 SCM） | 主责/关联 | 执行状态 | 实际证据 |', '|---|---|---|---|---|']
    testmap = {}
    for ln in scm.splitlines():
        if re.match(r'^\| T\d{2} \|',ln):
            c = [x.strip() for x in ln.split('|')[1:-1]]
            if len(c)==5:
                testmap[c[0]]=c
    for t in state['tests']:
        c=testmap[t['id']]
        evidence=f"[结果]({link(t['evidence'],f)})" if t.get('evidence') else '无'
        rows.append(f"| {t['id']} | {c[1]} | {c[2]} / {c[3]} | {t['status']} | {evidence} |")
    rows += ['', '未来实测记录：用例与 Task ID、输入配置/版本、运行环境和代码版本、步骤、预期/实际、时间、退出码、原始日志与适用截图。失败保留失败证据，未测明确 NotRun。完整用例拆分与排期在全部系统批准后制定。']
    out[f] = '\n'.join(rows).strip()+'\n'
    return out

def snapshot(paths=None):
    if paths is None:
        paths=['AGENTS.md'] + [str(p.relative_to(ROOT)) for folder in ('Docs','Tools')
                              for p in (ROOT/folder).rglob('*') if p.is_file() and '__pycache__' not in p.parts]
    paths=sorted(set(p for p in paths if safe(p).is_file()))
    stamp=datetime.now(ZoneInfo('Asia/Shanghai')).strftime('%Y%m%dT%H%M%S%f')
    dest=safe('Backups/DocsSync/'+stamp)
    dest.mkdir(parents=True,exist_ok=False)
    records=[]
    for rel in paths:
        source=safe(rel)
        target=dest/'files'/rel
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(source,target)
        records.append({'path':rel,'sha256':digest(source),'bytes':source.stat().st_size})
    (dest/'manifest.json').write_text(json.dumps({'date':stamp,'files':records},ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    return str(dest.relative_to(ROOT))

def restore_to(snapshot_rel,dest_rel):
    source=safe(snapshot_rel)
    dest=safe(dest_rel)
    if dest.exists():
        raise ValueError('restore destination must not exist')
    if not source.is_dir() or not (source/'manifest.json').is_file():
        raise ValueError('missing snapshot/manifest')
    if dest == source or dest.is_relative_to(source) or source.is_relative_to(dest):
        raise ValueError('restore destination must be separate from source')
    records=json.loads((source/'manifest.json').read_text(encoding='utf-8'))['files']
    payload='originals' if (source/'originals').is_dir() else 'files'
    pairs=[]
    for item in records:
        safe(item['path'])
        p=source/payload/item['path']
        if not p.is_file() or p.is_symlink() or not p.resolve().is_relative_to(source) or digest(p)!=item['sha256']:
            raise ValueError('snapshot payload invalid: '+item['path'])
        pairs.append((p,dest/item['path']))
    dest.mkdir(parents=True,exist_ok=False)
    for p,target in pairs:
        target.parent.mkdir(parents=True,exist_ok=True)
        shutil.copy2(p,target)
    print('Recovery export verified; current files untouched: '+str(dest.relative_to(ROOT)))

def check_links():
    errors=[]
    for p in [ROOT/'AGENTS.md',*(ROOT/'Docs').rglob('*.md')]:
        for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)',p.read_text(encoding='utf-8')):
            if '://' in target or target.startswith('#'):
                continue
            target=target.split('#')[0].strip('<>')
            q=(p.parent/target).resolve()
            if not q.is_relative_to(ROOT) or not q.exists():
                errors.append(str(p.relative_to(ROOT))+': broken local link '+target)
    if errors:
        raise ValueError('\n'.join(errors))

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action',choices=('check','sync','snapshot','restore-to'))
    parser.add_argument('paths',nargs='*')
    args=parser.parse_args()
    if args.action=='restore-to':
        if len(args.paths)!=2:
            raise ValueError('restore-to requires snapshot and NEW destination')
        restore_to(*args.paths)
        return
    if args.paths:
        raise ValueError('unexpected path arguments')
    data=load_validate()
    if args.action=='snapshot':
        print('Saved local snapshot: '+snapshot())
        return
    output=render(*data)
    if args.action=='sync':
        # Resolve/reject all unsafe paths before changing any output.
        targets={rel:safe(rel) for rel in output}
        changed=[rel for rel,p in targets.items() if not p.exists() or p.read_text(encoding='utf-8')!=output[rel]]
        if changed:
            print('Before-sync snapshot: '+snapshot(changed))
        for rel in changed:
            p=targets[rel]
            p.parent.mkdir(parents=True,exist_ok=True)
            fd,name=tempfile.mkstemp(prefix='.docs-sync-',dir=p.parent)
            try:
                with os.fdopen(fd,'w',encoding='utf-8') as f:
                    f.write(output[rel])
                os.replace(name,p)
            finally:
                if os.path.exists(name):
                    os.unlink(name)
        print(f'Synced {len(changed)} generated documents; approvals/baselines unchanged.')
    stale=[rel for rel,value in output.items() if not safe(rel).is_file() or safe(rel).read_text(encoding='utf-8')!=value]
    if stale:
        raise ValueError('generated documents stale/missing; run sync: '+', '.join(stale))
    check_links()
    print('PASS: 5 original hashes, 123 requirement mappings, 13 independent templates, approvals, phase gate, test metadata, generated state and local links.')
    print('Document consistency only. No Unity or gameplay test was run by this tool.')

if __name__=='__main__':
    try:
        main()
    except (ValueError,KeyError,OSError,StopIteration) as e:
        print('CHECK FAILED: '+str(e),file=sys.stderr)
        sys.exit(1)
