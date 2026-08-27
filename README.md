# FinQ-iOS



### Git Convention
#### Commit Type

| 타입 | 설명 |
| --- | --- |
| `feat` | 새로운 기능 추가 또는 기존 기능의 동작 변경 |
| `fix` | 의도와 다르게 동작하는 버그 수정 |
| `refactor` | 기능 변경 없는 코드 구조 개선 |
| `style` | 코드 포맷 변경 |
| `docs` | 문서 작업 |
| `test` | 테스트 코드 추가 또는 수정 |
| `chore` | 빌드, 설정, 패키지 등 기타 작업 |

#### Git Strategy
```mermaid
gitGraph
    commit id:"init"

    branch develop order:3
    commit id:"develop start"

    branch feature order:4
    commit id:"feat: login-ui"
    commit id:"feat: login-logic"

    checkout develop
    merge feature

    checkout develop
    branch release order:2
    commit id:"chore: app version update v1.0.0(1)"
    commit id:"fix: qa-issues"

    checkout main
    merge release tag:"v1.0.0"

    checkout develop
    merge release

    checkout main
    branch hotfix order:1
    commit id:"fix: crash"

    checkout main
    merge hotfix tag:"v1.0.1"

    checkout develop
    merge hotfix
```
