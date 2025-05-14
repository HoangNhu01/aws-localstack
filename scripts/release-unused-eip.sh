#!/bin/bash
DATE=$(date "+%Y-%m-%d %H:%M:%S")
mkdir -p $HOME/logs/ && touch $HOME/logs/eip-cleanup-$DATE.log && chmod 666 $HOME/logs/eip-cleanup-$DATE.log
LOG_FILE="$HOME/logs/eip-cleanup-$DATE.log"

echo "[$DATE] Checking for unused EIPs..." >> $LOG_FILE

# Lấy danh sách EIP không dùng (LocalStack)
UNUSED_EIPS=$(aws ec2 describe-addresses --endpoint-url=http://localhost:4566 \
  --query "Addresses[?AssociationId==null].AllocationId" \
  --output text)

# Kiểm tra nếu không có EIP nào không dùng
if [ -z "$UNUSED_EIPS" ]; then
  echo "[$DATE] Error: Unable to retrieve unused EIPs." >> $LOG_FILE
  exit 1
fi
# Xử lý từng EIP
for EIP in $UNUSED_EIPS; do
  echo "[$DATE] Releasing $EIP..." >> $LOG_FILE
  aws ec2 release-address \
    --endpoint-url=http://localhost:4566 \
    --allocation-id "$EIP" >> $LOG_FILE 2>&1
  
  [ $? -eq 0 ] && STATUS="✅" || STATUS="❌"
  echo "[$DATE] $STATUS $EIP" >> $LOG_FILE
done