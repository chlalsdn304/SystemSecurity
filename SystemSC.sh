#!binbash

# 출력 색상 정의
RED='033[0;31m'
GREEN='033[0;32m'
NC='033[0m' # No Color

echo ============================================
echo    주요정보통신기반시설 기술적 점검 스크립트
echo ============================================

# [U-15] World Writable 파일 점검
echo -e n[U-15] World Writable 파일 점검을 시작합니다.
# 시스템 전체에서 world writable 파일 탐색 (속도를 위해 주요 디렉토리 위주로 설정 가능)
# 점검 대상에서 제외할 경로는 -prune으로 설정
WW_FILES=$(find  -type f -perm -2 -ls 2devnull  grep -v proc  grep -v sys)

if [ -z $WW_FILES ]; then
    echo -e [결과] ${GREEN}양호${NC} World Writable 파일이 존재하지 않습니다.
else
    echo -e [결과] ${RED}취약${NC} World Writable 파일이 발견되었습니다.
    # 발견된 파일 중 상위 5개만 출력 (전체 출력 시 너무 길어질 수 있음)
    echo $WW_FILES  head -n 5
fi

echo --------------------------------------------

# [U-25] NFS 공유 설정 점검
echo -e [U-25] NFS 공유 설정 점검을 시작합니다.