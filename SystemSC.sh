#!/bin/bash

# 통합 취약점 점검 스크립트 (U-15, U-25)
# 작성일: 2026-04-15

echo "=========================================="
echo "   리눅스 서버 기술적 취약점 점검 시작"
echo "=========================================="

# [U-15] World Writable 파일 점검
echo ""
echo "[U-15] World Writable 파일 점검"
echo "------------------------------------------"
# 시스템 전체에서 누구나 쓰기 권한이 있는 파일을 탐색 (다른 파일시스템 제외)
find / -type f -perm -2 -xdev -exec ls -l {} \; 2>/dev/null > u15_raw_result.txt

if [ -s u15_raw_result.txt ]; then
    echo "[결과] 취약: World Writable 파일이 존재합니다."
    echo "상세 내용은 u15_raw_result.txt를 확인하세요."
else
    echo "[결과] 양호: World Writable 파일이 없습니다."
    rm u15_raw_result.txt 2>/dev/null
fi


# [U-25] NFS 공유 설정 점검
echo ""
echo "[U-25] NFS 공유 설정 점검"
echo "------------------------------------------"
NFS_CONFIG="/etc/exports"

if [ -f "$NFS_CONFIG" ]; then
    # 접근 제한 없이 '*' 또는 모든 대역(0.0.0.0/0)이 허용된 설정 확인
    CHECK_NFS=$(grep -E "\*|0\.0\.0\.0/0" "$NFS_CONFIG" | grep -v "^#")
    
    if [ -n "$CHECK_NFS" ]; then
        echo "[결과] 취약: NFS 설정에 광범위한 접근 허용(*)이 포함되어 있습니다."
        echo "해당 설정: $CHECK_NFS"
    else
        echo "[결과] 양호: NFS 설정이 적절하게 제한되어 있습니다."
    fi
else
    echo "[결과] 양호: NFS 설정 파일($NFS_CONFIG)이 존재하지 않습니다."
fi

echo ""
echo "=========================================="
echo "             점검이 완료되었습니다."
echo "=========================================="