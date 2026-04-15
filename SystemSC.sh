#!/bin/bash

# 통합 취약점 점검 스크립트 (U-15, U-25)
# 수정 사항: 파일 저장 없이 터미널에 직접 출력

echo "=========================================="
echo "   리눅스 서버 기술적 취약점 점검 시작"
echo "=========================================="

# [U-15] World Writable 파일 점검
echo ""
echo "[U-15] World Writable 파일 점검"
echo "------------------------------------------"
echo "점검 중... (파일이 많을 경우 시간이 소요될 수 있습니다)"

# 결과를 변수에 담지 않고 즉시 화면에 출력 (표준 에러는 숨김)
WW_FILES=$(find / -type f -perm -2 -xdev -exec ls -l {} \; 2>/dev/null)

if [ -n "$WW_FILES" ]; then
    echo "[결과] 취약: 다음의 World Writable 파일이 발견되었습니다."
    echo "------------------------------------------"
    echo "$WW_FILES"
    echo "------------------------------------------"
else
    echo "[결과] 양호: World Writable 파일이 발견되지 않았습니다."
fi


# [U-25] NFS 공유 설정 점검
echo ""
echo "[U-25] NFS 공유 설정 점검"
echo "------------------------------------------"
NFS_CONFIG="/etc/exports"

if [ -f "$NFS_CONFIG" ]; then
    # 주석 제외, * 또는 0.0.0.0/0 포함 여부 확인
    CHECK_NFS=$(grep -E "\*|0\.0\.0\.0/0" "$NFS_CONFIG" | grep -v "^#")
    
    if [ -n "$CHECK_NFS" ]; then
        echo "[결과] 취약: NFS 설정에 광범위한 접근 허용이 확인되었습니다."
        echo "취약 설정 내용: $CHECK_NFS"
    else
        echo "[결과] 양호: NFS 설정이 적절하게 제한되어 있거나 개방된 설정이 없습니다."
    fi
else
    echo "[결과] 양호: NFS 설정 파일($NFS_CONFIG)이 존재하지 않습니다."
fi

echo ""
echo "=========================================="
echo "             점검이 완료되었습니다."
echo "=========================================="