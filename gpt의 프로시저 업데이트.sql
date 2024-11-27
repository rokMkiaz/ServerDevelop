CREATE PROCEDURE MoveData
    @TableName NVARCHAR(100),
    @Columns NVARCHAR(MAX),
    @CharUnique NVARCHAR(50),
    @MoveRecord NVARCHAR(MAX),
    @ErrorOffset INT
AS
BEGIN
    DECLARE @QUERY NVARCHAR(MAX);

    SET @QUERY = 
    'INSERT INTO ' + @FROM_SERVER_DBNAME + '[Back' + @TableName + '] (' + @Columns + ')
     SELECT ' + @Columns + ', ' + @MoveRecord + '
     FROM ' + @FROM_SERVER_DBNAME + '[' + @TableName + '] 
     WHERE charunique = ''' + @CharUnique + '''';

    EXEC(@QUERY);

    IF @@ERROR <> 0
    BEGIN
        RETURN @ErrorOffset;
    END
END;
--------------------------------------------------------------------------------------
EXEC MoveData 
    'TPurchaseData', 
    'BundleIdx, charunique, buytime, channelId, vaccunique, packageType, buycount, timetype', 
    @CHARACTER__UNIQUE, 
    @MOVE_RECORD_CONVERT, 
    15;

-- TPresetList 처리
EXEC MoveData 
    'TPresetList', 
    'charunique, presetname, number, transform, equiitem, equistone, mainsuhoryung, subsuhoryung, eightstoneset, active, equipcharactertitle', 
    @CHARACTER__UNIQUE, 
    @MOVE_RECORD_CONVERT, 
    16;

----------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE UpdateOrInsertList
    @TO_SERVER_DBNAME NVARCHAR(100),       -- 대상 데이터베이스
    @TO_TABLE_NAME NVARCHAR(50),          -- 대상 테이블 이름
    @FROM_TABLE_NAME NVARCHAR(50),        -- 소스 테이블 이름
    @ACCOUNT__UNIQUE NVARCHAR(50),        -- 계정 고유 식별자
    @MOVE_RECORD_CONVERT NVARCHAR(50),    -- 이동 레코드 조건
    @COLUMNS NVARCHAR(MAX),               -- 업데이트 및 삽입할 컬럼 목록
    @ERROR_CODE INT                       -- 오류 발생 시 반환할 코드
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @QUERY NVARCHAR(MAX);

        -- UPDATE 쿼리 생성
        SET @QUERY = '
        UPDATE ' + @TO_SERVER_DBNAME + @TO_TABLE_NAME + '
        SET ' + REPLACE(@COLUMNS, ',', ' = fromTable.,') + ' = fromTable.' + '
        FROM ' + @TO_SERVER_DBNAME + @TO_TABLE_NAME + ' AS targetTable
        INNER JOIN (
            SELECT TOP 1 * 
            FROM ' + @FROM_TABLE_NAME + ' 
            WHERE accunique = ' + @ACCOUNT__UNIQUE + ' 
              AND moverecord = ' + @MOVE_RECORD_CONVERT + '
        ) AS fromTable
        ON targetTable.accunique = ' + @ACCOUNT__UNIQUE + '

        IF (@@ROWCOUNT = 0)
        BEGIN
            INSERT INTO ' + @TO_SERVER_DBNAME + @TO_TABLE_NAME + ' (' + @COLUMNS + ')
            SELECT ' + @COLUMNS + '
            FROM ' + @FROM_TABLE_NAME + '
            WHERE accunique = ' + @ACCOUNT__UNIQUE + ' 
              AND moverecord = ' + @MOVE_RECORD_CONVERT + '
        END';

        -- 동적 SQL 실행
        EXEC(@QUERY);

    END TRY
    BEGIN CATCH
        -- 오류 발생 시 지정된 코드 반환
        RETURN @ERROR_CODE;
    END CATCH
END;

------------------------------------------------------------------------------
EXEC UpdateOrInsertList
    @TO_SERVER_DBNAME = 'TargetDB.',
    @TO_TABLE_NAME = 'TAwakeList',
    @FROM_TABLE_NAME = 'fromTAwakeList',
    @ACCOUNT__UNIQUE = '12345',
    @MOVE_RECORD_CONVERT = '67890',
    @COLUMNS = 'accunique, awakelist, awakeusetime, awakeusecount',
    @ERROR_CODE = -7;

EXEC UpdateOrInsertList
   @TO_SERVER_DBNAME = 'TargetDB.',
   @TO_TABLE_NAME = 'TSinsuList',
   @FROM_TABLE_NAME = 'fromTSinsuList',
   @ACCOUNT__UNIQUE = '12345',
   @MOVE_RECORD_CONVERT = '67890',
   @COLUMNS = '
       accunique, sinsuList, favoriteSinsu, lastSinsuIdx, RandomSinsuIdx, SinseongData, 
       materialunique, sinsuIndex, avatarInfo, avatarIndex, mainsuho, subsuho, 
       suhoryungExp, avatarcount1, avatarcount2, avatarcount3, suhocount1, suhocount2, 
       suhocount3, starupcount1, starupcount2, avatarengrave, SuhoConstellation',
   @ERROR_CODE = -8;