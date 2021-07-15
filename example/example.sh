# 主库
bucardo add database main dbhost=$DB_HOST dbport=$DB_PORT dbname=$DB_NAME dbuser=$DB_USER dbpass=$DB_PASS
bucardo add table erp_device_sn_sale db=main relgroup=$GP_NAME --verbose
bucardo add table mac_sn_p% db=main relgroup=$GP_NAME --verbose
bucardo add table sn_ctei_p% db=main relgroup=$GP_NAME --verbose
bucardo add table five_code_p% db=main relgroup=$GP_NAME --verbose

# 从库
bucardo add database follower dbhost=$DB_HOST2 dbport=$DB_PORT2 dbname=$DB_NAME2 dbuser=$DB_USER2 dbpass=$DB_PASS2
bucardo add sync $SYNC_NAME relgroup=$GP_NAME dbs=main:source,follower:target 
bucardo update sync $SYNC_NAME checktime='5 min'
# bucardo update sync $SYNC_NAME onetimecopy=2
bucardo restart

# 清理
bucardo stop sync $SYNC_NAME
bucardo remove sync $SYNC_NAME
bucardo remove dbgroup $SYNC_NAME
bucardo purge all
bucardo remove table all
bucardo remove relgroup $GP_NAME
bucardo remove database main
bucardo remove database follower

SELECT 'DROP TRIGGER ' || trigger_name || ' ON ' || event_object_table || ';'
FROM information_schema.triggers
WHERE trigger_schema = 'public' trigger_name LIKE 'bucardo%' 

DROP SCHEMA bucardo CASCADE;