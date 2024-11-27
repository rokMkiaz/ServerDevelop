USE [master]
GO

/****** Object:  LinkedServer [Metin_game_11]    Script Date: 2024-11-27 ¿ÀÈÄ 1:18:26 ******/
EXEC master.dbo.sp_addlinkedserver @server = N'Metin_game_11', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'192.168.150.36,1433', @catalog=N'Metin_game_11'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'Metin_game_11',@useself=N'False',@locallogin=NULL,@rmtuser=N'sa',@rmtpassword='gnisoft'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'rpc out', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'Metin_game_11', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


