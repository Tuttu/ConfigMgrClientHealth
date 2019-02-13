/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2017 (14.0.2002)
    Source Database Engine Edition : Microsoft SQL Server Standard Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [ClientHealth]
GO
/****** Object:  StoredProcedure [dbo].[up_GetErrorInfo]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_GetErrorInfo]
GO
/****** Object:  StoredProcedure [dbo].[up_get_SCCM_statusMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_SCCM_statusMsg]
GO
/****** Object:  StoredProcedure [dbo].[up_get_OS_Summary_data]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_OS_Summary_data]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_flat]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_ClientData_flat]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_ActionResult]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[up_get_ClientData_ActionResult]
GO
/****** Object:  Table [dbo].[SCCM_StatusMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[SCCM_StatusMsg]
GO
/****** Object:  Table [dbo].[SCCM_Config]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[SCCM_Config]
GO
/****** Object:  Table [dbo].[Report_Theme]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[Report_Theme]
GO
/****** Object:  Table [dbo].[ref_ServerStatMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[ref_ServerStatMsg]
GO
/****** Object:  Table [dbo].[ref_ProvStatMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[ref_ProvStatMsg]
GO
/****** Object:  Table [dbo].[ref_ClientStatMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[ref_ClientStatMsg]
GO
/****** Object:  Table [dbo].[LogMsg]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[LogMsg]
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[Configuration]
GO
/****** Object:  View [dbo].[v_ClientData_Actual]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP VIEW IF EXISTS [dbo].[v_ClientData_Actual]
GO
/****** Object:  View [dbo].[v_ClientData_historical]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP VIEW IF EXISTS [dbo].[v_ClientData_historical]
GO
/****** Object:  View [dbo].[v_ClientData_ALL]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP VIEW IF EXISTS [dbo].[v_ClientData_ALL]
GO
/****** Object:  Table [dbo].[Clients_Hist]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP TABLE IF EXISTS [dbo].[Clients_Hist]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 2/13/2019 9:21:06 PM ******/
DROP FUNCTION IF EXISTS [dbo].[udf_Split]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_Split]    Script Date: 2/13/2019 9:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ==============================================================================================================================
-- $HeadURL:                                                                         $ 
-- $LastChangedDate::                                                                $: Date of last commit 
-- $Rev::                                                                            $: Revision of last commit  
-- $Author::                                                                         $: Author of last commit
-- $Id::                                                                             $: 
-- ==============================================================================================================================
-- Beschreibung: 
--
--
-- ==============================================================================================================================


Create FUNCTION [dbo].[udf_Split](@List varchar(8000), @Splitter varchar(20) = ' ')
RETURNS @TB TABLE
(    
  position int IDENTITY PRIMARY KEY,
  value varchar(8000)   
)
AS
BEGIN
DECLARE @index int 
SET @index = -1 
WHILE (LEN(@List) > 0) 
 BEGIN  
    SET @index = CHARINDEX(@Splitter , @List)  
    IF (@index = 0) AND (LEN(@List) > 0)  
      BEGIN   
        INSERT INTO @TB VALUES (@List)
          BREAK  
      END  
    IF (@index > 1)  
      BEGIN   
        INSERT INTO @TB VALUES (LEFT(@List, @index - 1))   
        SET @List = RIGHT(@List, (LEN(@List) - @index))  
      END  
    ELSE 
      SET @List = RIGHT(@List, (LEN(@List) - @index)) 
    END
  RETURN
END
GO
/****** Object:  Table [dbo].[Clients_Hist]    Script Date: 2/13/2019 9:21:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Clients_Hist](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Hostname] [varchar](100) NOT NULL,
	[OperatingSystem] [varchar](100) NOT NULL,
	[Architecture] [varchar](10) NOT NULL,
	[Build] [varchar](100) NOT NULL,
	[Manufacturer] [varchar](100) NOT NULL,
	[Model] [varchar](100) NOT NULL,
	[InstallDate] [smalldatetime] NULL,
	[OSUpdates] [smalldatetime] NULL,
	[LastLoggedOnUser] [varchar](100) NOT NULL,
	[ClientVersion] [varchar](100) NOT NULL,
	[PSVersion] [float] NULL,
	[PSBuild] [int] NULL,
	[Sitecode] [varchar](3) NULL,
	[Domain] [varchar](100) NOT NULL,
	[MaxLogSize] [int] NULL,
	[MaxLogHistory] [int] NULL,
	[CacheSize] [int] NULL,
	[ClientCertificate] [varchar](50) NULL,
	[ProvisioningMode] [varchar](50) NULL,
	[DNS] [varchar](100) NULL,
	[Drivers] [varchar](100) NULL,
	[Updates] [varchar](100) NULL,
	[PendingReboot] [varchar](50) NULL,
	[LastBootTime] [smalldatetime] NULL,
	[OSDiskFreeSpace] [float] NULL,
	[Services] [varchar](200) NOT NULL,
	[AdminShare] [varchar](50) NULL,
	[StateMessages] [varchar](50) NULL,
	[WUAHandler] [varchar](50) NULL,
	[WMI] [varchar](50) NULL,
	[RefreshComplianceState] [smalldatetime] NULL,
	[ClientInstalled] [smalldatetime] NULL,
	[Version] [varchar](10) NULL,
	[Timestamp] [datetime] NULL,
	[HWInventory] [smalldatetime] NULL,
	[SWMetering] [varchar](50) NULL,
	[BITS] [varchar](50) NULL,
	[PatchLevel] [int] NULL,
	[ClientInstalledReason] [varchar](200) NULL,
	[LOG_Created_Date] [datetime] NULL,
	[LOG_Created_by] [varchar](50) NULL,
	[LOG_Action] [varchar](50) NULL,
 CONSTRAINT [PK__Clients___3214EC278B487331] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[v_ClientData_ALL]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[v_ClientData_ALL]    Script Date: 2/6/2019 2:46:03 PM ******/
CREATE VIEW [dbo].[v_ClientData_ALL]
AS
	SELECT	[Hostname],[OperatingSystem],[Architecture],[Build],[Manufacturer],[Model],[InstallDate],
			[OSUpdates],[LastLoggedOnUser],[ClientVersion],[PSVersion],[PSBuild],[Sitecode],[Domain],
			[MaxLogSize],[MaxLogHistory],[CacheSize],[ClientCertificate],[ProvisioningMode],[DNS],
			[Drivers],[Updates],[PendingReboot],[LastBootTime],[OSDiskFreeSpace],[Services],[AdminShare],
			[StateMessages],[WUAHandler],[WMI],[RefreshComplianceState],[ClientInstalled],[Version],
			[Timestamp],[HWInventory],[SWMetering],[BITS],[PatchLevel],[ClientInstalledReason] 
	from 
		dbo.clients
	union 
	select 
			[Hostname],[OperatingSystem],[Architecture],[Build],[Manufacturer],[Model],[InstallDate],
			[OSUpdates],[LastLoggedOnUser],[ClientVersion],[PSVersion],[PSBuild],[Sitecode],[Domain],
			[MaxLogSize],[MaxLogHistory],[CacheSize],[ClientCertificate],[ProvisioningMode],[DNS],
			[Drivers],[Updates],[PendingReboot],[LastBootTime],[OSDiskFreeSpace],[Services],[AdminShare],
			[StateMessages],[WUAHandler],[WMI],[RefreshComplianceState],[ClientInstalled],[Version],
			[Timestamp],[HWInventory],[SWMetering],[BITS],[PatchLevel],[ClientInstalledReason] 
	from dbo.clients_hist

GO
/****** Object:  View [dbo].[v_ClientData_historical]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  View [dbo].[v_ClientData_historical]    Script Date: 2/6/2019 2:46:03 PM ******/
CREATE VIEW [dbo].[v_ClientData_historical]
AS
	SELECT  ID, Hostname, OperatingSystem, Architecture, Build, Manufacturer, Model, InstallDate, 
			OSUpdates, LastLoggedOnUser, ClientVersion, PSVersion, PSBuild, Sitecode, Domain, MaxLogSize, 
			MaxLogHistory, CacheSize, ClientCertificate, ProvisioningMode, DNS, Drivers, Updates, PendingReboot, 
			LastBootTime, OSDiskFreeSpace, Services, AdminShare, StateMessages, WUAHandler, WMI, 
			RefreshComplianceState, ClientInstalled, Version, Timestamp, HWInventory, SWMetering, BITS, 
			PatchLevel, ClientInstalledReason, LOG_Created_Date, LOG_Created_by, LOG_Action
	FROM    dbo.Clients_Hist
GO
/****** Object:  View [dbo].[v_ClientData_Actual]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- create now views 
CREATE VIEW [dbo].[v_ClientData_Actual]
AS
	SELECT  Hostname, OperatingSystem, Architecture, Build, Manufacturer, Model, InstallDate, 
			OSUpdates, LastLoggedOnUser, ClientVersion, PSVersion, PSBuild, Sitecode, Domain, MaxLogSize, 
			MaxLogHistory,CacheSize, ClientCertificate, ProvisioningMode, DNS, Drivers, Updates, PendingReboot, 
			LastBootTime, OSDiskFreeSpace, Services, AdminShare, StateMessages, WUAHandler, WMI, 
			RefreshComplianceState, ClientInstalled, Version, Timestamp, HWInventory, SWMetering, BITS, 
			PatchLevel, ClientInstalledReason
	FROM
		 dbo.Clients
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configuration](
	[Name] [varchar](50) NOT NULL,
	[Version] [varchar](10) NOT NULL,
UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LogMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LogMsg](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LogMsg] [nvarchar](max) NOT NULL,
	[Logdate] [datetime] NOT NULL,
 CONSTRAINT [PK_LogMsg] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ref_ClientStatMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ref_ClientStatMsg](
	[MessageID] [nvarchar](50) NULL,
	[MessageString] [nvarchar](max) NULL,
	[Severity] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ref_ProvStatMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ref_ProvStatMsg](
	[MessageID] [nvarchar](50) NULL,
	[MessageString] [nvarchar](max) NULL,
	[Severity] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ref_ServerStatMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ref_ServerStatMsg](
	[MessageID] [nvarchar](50) NULL,
	[MessageString] [nvarchar](max) NULL,
	[Severity] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Report_Theme]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Report_Theme](
	[Theme] [nvarchar](50) NOT NULL,
	[BG_01] [varchar](20) NOT NULL,
	[FG_01] [varchar](20) NOT NULL,
	[BG_02] [varchar](20) NOT NULL,
	[FG_02] [varchar](20) NOT NULL,
	[BG_03] [varchar](20) NOT NULL,
	[FG_03] [varchar](20) NOT NULL,
	[BG_04] [varchar](20) NOT NULL,
	[FG_04] [varchar](20) NOT NULL,
	[BG_red] [varchar](20) NOT NULL,
	[BG_green] [varchar](20) NOT NULL,
	[BG_header] [varchar](20) NOT NULL,
	[FG_header] [varchar](20) NOT NULL,
	[BG_footer] [varchar](20) NOT NULL,
	[FG_Footer] [varchar](20) NOT NULL,
	[BG_Info] [varchar](20) NULL,
	[BG_State_OK] [varchar](20) NULL,
	[FG_State_OK] [varchar](20) NULL,
	[BG_State_Repair] [varchar](20) NULL,
	[FG_State_Repair] [varchar](20) NULL,
	[BG_State_Error] [varchar](20) NULL,
	[FG_State_Error] [varchar](20) NULL,
 CONSTRAINT [PK_TB_Report_Theme] PRIMARY KEY CLUSTERED 
(
	[Theme] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 70) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SCCM_Config]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCCM_Config](
	[ID] [bigint] NOT NULL,
	[ConfigItem] [nvarchar](50) NOT NULL,
	[ConfigValue] [nvarchar](2000) NOT NULL,
	[Note] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SCCM_StatusMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SCCM_StatusMsg](
	[RecordID] [bigint] NOT NULL,
	[ModuleName] [nvarchar](128) NOT NULL,
	[Severity] [int] NULL,
	[MessageID] [int] NOT NULL,
	[ReportFunction] [int] NULL,
	[SuccessfulTransaction] [int] NULL,
	[PartOfTransaction] [int] NULL,
	[PerClient] [int] NULL,
	[MessageType] [int] NULL,
	[Win32Error] [int] NULL,
	[Time] [datetime] NOT NULL,
	[SiteCode] [nvarchar](3) NOT NULL,
	[TopLevelSiteCode] [nvarchar](3) NULL,
	[MachineName] [nvarchar](128) NOT NULL,
	[Component] [nvarchar](128) NOT NULL,
	[ProcessID] [int] NULL,
	[ThreadID] [int] NULL,
	[AttributeTime] [datetime] NULL,
	[DeploymentID] [nvarchar](255) NULL,
	[MacAddress] [nvarchar](255) NULL,
	[PackageID] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_ActionResult]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_ClientData_ActionResult      ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for Action Result (SUM) Data     ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/13/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_ClientData_ActionResult]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --

    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')

	begin
		Select 'ClientCertificate' as 'Component_Name',
			sum(case when ClientCertificate = 'OK' then 1 else 0 end) as Component_Count_OK, 
			sum(case when ClientCertificate <> 'OK' then 1 else 0 end) as Component_Count_ERROR 
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter
		
		union 
		Select 'ProvisioningMode' as 'Component_Name', 
			sum(case when ProvisioningMode = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when ProvisioningMode <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'DNS' as 'Component_Name',
			sum(case when DNS = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when DNS <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'Drivers' as 'Component_Name', 
			sum(case when Drivers = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Drivers <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'PendingReboot' as 'Component_Name', 
			sum(case when PendingReboot = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when PendingReboot <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'Services' as 'Component_Name', 
			sum(case when Services = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Services <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'AdminShare' as 'Component_Name', 
			sum(case when AdminShare = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when AdminShare <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union
		Select 'StateMessages' as 'Component_Name',
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 
	
		union 
		Select 'WUAHandler' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'WMI' as 'Component_Name', 
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		union 
		Select 'BITS' as 'Component_Name',
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_Actual
		where Timestamp >=  @DateFilter 

		order by Component_Name  
	end

	-- query for all data
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 

		Select 'ClientCertificate' as 'Component_Name', 
			sum(case when ClientCertificate = 'OK' then 1 else 0 end) as Component_Count_OK, 
			sum(case when ClientCertificate <> 'OK' then 1 else 0 end) as Component_Count_ERROR 
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter

		union 
		Select 'ProvisioningMode' as 'Component_Name', 
			sum(case when ProvisioningMode = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when ProvisioningMode <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'DNS' as 'Component_Name', 
			sum(case when DNS = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when DNS <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'Drivers' as 'Component_Name', 
			sum(case when Drivers = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Drivers <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'PendingReboot' as 'Component_Name',
			sum(case when PendingReboot = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when PendingReboot <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'Services' as 'Component_Name', 
			sum(case when Services = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when Services <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'AdminShare' as 'Component_Name', 
			sum(case when AdminShare = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when AdminShare <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union
		Select 'StateMessages' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 
	
		union 
		Select 'WUAHandler' as 'Component_Name', 
			sum(case when StateMessages = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when StateMessages <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'WMI' as 'Component_Name', 
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 

		union 
		Select 'BITS' as 'Component_Name',
			sum(case when WMI = 'OK' then 1 else 0 end) as Component_Count_OK,
			sum(case when WMI <> 'OK' then 1 else 0 end) as Component_Count_ERROR
		from v_ClientData_ALL
		where Timestamp >=  @DateFilter 
		order by Component_Name
	end
end 
GO
/****** Object:  StoredProcedure [dbo].[up_get_ClientData_flat]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_ClientData_flat              ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for OS Summary Data              ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/09/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_ClientData_flat]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --
    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')
	-- check @UseHistorydate
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 
		-- select all data from actual and historie togehter 
		select * from [dbo].[v_ClientData_ALL] 
		where Timestamp > @DateFilter
		order by hostname, Timestamp desc 
	end
	if @UseHistorydate = 0
	begin
		-- select only data from actual
		select * from [dbo].[v_ClientData_Actual]
		where Timestamp > @DateFilter
		order by hostname, Timestamp desc 
	end
end
GO
/****** Object:  StoredProcedure [dbo].[up_get_OS_Summary_data]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_OS_Summary_data              ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - SP for OS Summary Data              ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/06/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_get_OS_Summary_data]
	@DateFilterDiff as int, @UseHistorydate as int = 0 , @HistorydateFilter as int = 43503
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	-- debug --
    declare @DateFilter as date = (select dateadd(DAY,-@DateFilterDiff,getdate()))
	
	-- load default Version for SCCM Client Version (based on the config Tbl)
	declare @SCCM_Current_ClientVersion as varchar(20) = (select top 1 configvalue from [dbo].[SCCM_Config] where ConfigItem = 'SCCM_Current_ClientVersion')
	-- check @UseHistorydate
	if @UseHistorydate = 1
	begin
		set @DateFilter =(select dateadd(DAY,-@HistorydateFilter,getdate())) 

		SELECT [OperatingSystem],
			Count (HOSTNAME) as TotalCount,
			SUM(Case when ClientCertificate = 'OK' then 1 else 0 end ) as ClientCertificate_OK,
			SUM(Case when ClientCertificate <> 'OK' then 1 else 0 end ) as ClientCertificate_Error, 
			SUM(Case when ClientVersion = @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Actual, 
			SUM(Case when ClientVersion > @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Newer, 
			SUM(Case when ClientVersion < @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Older, 
			SUM(Case when ProvisioningMode = 'OK' then 1 else 0 end ) as ProvisioningMode_OK,
			SUM(Case when ProvisioningMode <> 'OK' then 1 else 0 end ) as ProvisioningMode_Error,
			SUM(Case when DNS = 'OK' then 1 else 0 end ) as DNS_OK,
			SUM(Case when DNS <> 'OK' then 1 else 0 end ) as DNS_Error,
			SUM(Case when Drivers  = 'OK' then 1 else 0 end ) as Drivers_OK,
			SUM(Case when Drivers <> 'OK' then 1 else 0 end ) as Drivers_Error,
			SUM(Case when PendingReboot   = 'OK' then 1 else 0 end ) as PendingReboot_OK,
			SUM(Case when PendingReboot <> 'OK' then 1 else 0 end ) as PendingReboot_Error,
			SUM(Case when Services = 'OK' then 1 else 0 end ) as Services_OK,
			SUM(Case when Services <> 'OK' then 1 else 0 end ) as Services_Error,
			SUM(Case when AdminShare = 'OK' then 1 else 0 end ) as AdminShare_OK,
			SUM(Case when AdminShare <> 'OK' then 1 else 0 end ) as AdminShare_Error,
			SUM(Case when StateMessages = 'OK' then 1 else 0 end ) as StateMessages_OK,
			SUM(Case when StateMessages <> 'OK' then 1 else 0 end ) as StateMessages_Error,
			SUM(Case when WUAHandler = 'OK' then 1 else 0 end ) as WUAHandler_OK,
			SUM(Case when WUAHandler <> 'OK' then 1 else 0 end ) as WUAHandler_Error,
			SUM(Case when WMI = 'OK' then 1 else 0 end ) as WMI_OK,
			SUM(Case when WMI <> 'OK' then 1 else 0 end ) as WMI_Error,
			SUM(Case when BITS = 'OK' then 1 else 0 end ) as BITS_OK,
			SUM(Case when BITS <> 'OK' then 1 else 0 end ) as BITS_Error
		FROM  [dbo].[v_ClientData_ALL]
		where Timestamp > @DateFilter
		group by [OperatingSystem]
	end


	if @UseHistorydate = 0
	begin
		SELECT [OperatingSystem],
			Count (HOSTNAME) as TotalCount,
			SUM(Case when ClientCertificate = 'OK' then 1 else 0 end ) as ClientCertificate_OK,
			SUM(Case when ClientCertificate <> 'OK' then 1 else 0 end ) as ClientCertificate_Error, 
			SUM(Case when ClientVersion = @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Actual, 
			SUM(Case when ClientVersion > @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Newer, 
			SUM(Case when ClientVersion < @SCCM_Current_ClientVersion then 1 else 0 end ) as ClientVersion_Older, 
			SUM(Case when ProvisioningMode = 'OK' then 1 else 0 end ) as ProvisioningMode_OK,
			SUM(Case when ProvisioningMode <> 'OK' then 1 else 0 end ) as ProvisioningMode_Error,
			SUM(Case when DNS = 'OK' then 1 else 0 end ) as DNS_OK,
			SUM(Case when DNS <> 'OK' then 1 else 0 end ) as DNS_Error,
			SUM(Case when Drivers  = 'OK' then 1 else 0 end ) as Drivers_OK,
			SUM(Case when Drivers <> 'OK' then 1 else 0 end ) as Drivers_Error,
			SUM(Case when PendingReboot   = 'OK' then 1 else 0 end ) as PendingReboot_OK,
			SUM(Case when PendingReboot <> 'OK' then 1 else 0 end ) as PendingReboot_Error,
			SUM(Case when Services = 'OK' then 1 else 0 end ) as Services_OK,
			SUM(Case when Services <> 'OK' then 1 else 0 end ) as Services_Error,
			SUM(Case when AdminShare = 'OK' then 1 else 0 end ) as AdminShare_OK,
			SUM(Case when AdminShare <> 'OK' then 1 else 0 end ) as AdminShare_Error,
			SUM(Case when StateMessages = 'OK' then 1 else 0 end ) as StateMessages_OK,
			SUM(Case when StateMessages <> 'OK' then 1 else 0 end ) as StateMessages_Error,
			SUM(Case when WUAHandler = 'OK' then 1 else 0 end ) as WUAHandler_OK,
			SUM(Case when WUAHandler <> 'OK' then 1 else 0 end ) as WUAHandler_Error,
			SUM(Case when WMI = 'OK' then 1 else 0 end ) as WMI_OK,
			SUM(Case when WMI <> 'OK' then 1 else 0 end ) as WMI_Error,
			SUM(Case when BITS = 'OK' then 1 else 0 end ) as BITS_OK,
			SUM(Case when BITS <> 'OK' then 1 else 0 end ) as BITS_Error
		FROM  [dbo].[v_ClientData_Actual]
		where Timestamp > @DateFilter
		group by [OperatingSystem]
	end
END
GO
/****** Object:  StoredProcedure [dbo].[up_get_SCCM_statusMsg]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_get_SCCM_statusMsg               ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - new Stored Procedure                ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 02/06/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/

CREATE PROCEDURE [dbo].[up_get_SCCM_statusMsg]

AS
BEGIN
	SET NOCOUNT ON;

	-- load config to find the actiontype
	declare @Actiontype as bit = 0 
	set @Actiontype = (select CONVERT(bit, Configvalue) from dbo.SCCM_Config where ConfigItem = 'SCCM_transfer_StatusMsg_to_ClientHealtDB')

	if @Actiontype = 0 
	begin
		print 'show data only'
		Select v_s.*, pvt.AttributeTime, pvt.DeploymentID, pvt.MacAddress, pvt.PackageID 
				From CM_ABC.dbo.v_StatusMessage AS v_S LEFT JOIN
					(SELECT Recordid, AttributeTime, [400] AS PackageID, [401] AS DeploymentID, 
					Case When [426] IS NULL THEN 'MAC Address missing' ELSE [426] END  AS MacAddress
						FROM  CM_ABC.dbo.v_StatMsgAttributes PIVOT (max(AttributeValue) FOR AttributeID 
						IN ([400], [401], [408], [425], [426])) AS P) AS pvt ON v_S.RecordID = pvt.recordid
				where 
					(MachineName in (select distinct Hostname from ClientHealth.dbo.Clients)	
				or 
					MachineName in (Select distinct Hostname +'.'+ Domain from ClientHealth.dbo.Clients))
				and MessageID not in 
				(SELECT value FROM [dbo].[udf_Split] ((SELECT top 1 ConfigValue FROM [ClientHealth].[dbo].[SCCM_Config] where ConfigItem  =		'SCCM_blocked_StatusMsg') ,','))
				and Component in 
				(SELECT value FROM [dbo].[udf_Split] ((SELECT top 1 ConfigValue FROM [ClientHealth].[dbo].[SCCM_Config] where ConfigItem  = 'SCCM_ComponetsStatusMsg') ,','))
				order by v_s.Time desc 
	end 
	if @Actiontype = 1
	begin
		print 'add data to local tbl'
		INSERT INTO [dbo].[SCCM_StatusMsg]
           ([RecordID],[ModuleName],[Severity],[MessageID],[ReportFunction],[SuccessfulTransaction],[PartOfTransaction],
		   [PerClient],[MessageType],[Win32Error],[Time],[SiteCode],[TopLevelSiteCode],[MachineName],[Component],
		   [ProcessID],[ThreadID],[AttributeTime],[DeploymentID],[MacAddress],[PackageID])
		Select v_s.*, pvt.AttributeTime, pvt.DeploymentID, pvt.MacAddress, pvt.PackageID
				From CM_ABC.dbo.v_StatusMessage AS v_S LEFT JOIN
					(SELECT Recordid, AttributeTime, [400] AS PackageID, [401] AS DeploymentID, 
					Case When [426] IS NULL THEN 'MAC Address missing' ELSE [426] END  AS MacAddress
						FROM  CM_ABC.dbo.v_StatMsgAttributes PIVOT (max(AttributeValue) FOR AttributeID 
						IN ([400], [401], [408], [425], [426])) AS P) AS pvt ON v_S.RecordID = pvt.recordid
				where 
					(MachineName in (select distinct Hostname from ClientHealth.dbo.Clients)	
				or 
					MachineName in (Select distinct Hostname +'.'+ Domain from ClientHealth.dbo.Clients))
				and MessageID not in 
				(SELECT value FROM [dbo].[udf_Split] ((SELECT top 1 ConfigValue FROM [ClientHealth].[dbo].[SCCM_Config] where ConfigItem  =		'SCCM_blocked_StatusMsg') ,','))
				and Component in 
				(SELECT value FROM [dbo].[udf_Split] ((SELECT top 1 ConfigValue FROM [ClientHealth].[dbo].[SCCM_Config] where ConfigItem  = 'SCCM_ComponetsStatusMsg') ,','))
				and v_s.RecordID not in (Select tb1.RecordID from [dbo].[SCCM_StatusMsg] as tb1)

	-- show now all status messsage
	Select * from [dbo].[SCCM_StatusMsg] order by Time desc 

	end
END
GO
/****** Object:  StoredProcedure [dbo].[up_GetErrorInfo]    Script Date: 2/13/2019 9:21:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****************************************************************************/
/*** Script Name                  : - up_GetErrorInfo                     ***/
/*** Script Version               : - 1.00                                ***/
/*** Script Desciption            : - erstellt Stored Procedure           ***/
/*** Script Audience              : -                                     ***/
/*** Script Owner                 : - C-S-L K.Bilger                      ***/
/*** Scripter/Design              : - C-S-L K.Bilger                      ***/
/***                                                                      ***/
/*** Change History *********************************************************/
/*** Version (Old/New)            : - 1.00.00                             ***/
/*** Modification Date            : - 01/25/2019                          ***/
/*** By                           : - Klaus Bilger                        ***/
/*** Reason                       : -                                     ***/
/*** Comments                     : -                                     ***/
/***                                                                      ***/
/*** Version (Old/New)            : - %Version%                           ***/
/*** Modification Date            : - %DATE%                              ***/
/*** By                           : - %PERSON%                            ***/
/*** Reason                       : - %REASON%                            ***/
/*** Comments                     : - %COMMENTS%                          ***/
/***                                                                      ***/
/****************************************************************************/
CREATE PROCEDURE [dbo].[up_GetErrorInfo]
AS
begin 
 declare @Error_Text as nvarchar(max), @str_line as nvarchar(max)
 set  @str_line = replicate('#*',55) 
	set @Error_Text = @str_line + char(09) +  char(13)+ char(09) +  char(13)
	set @Error_Text = @Error_Text + ' Mail erzeugt:    ' + CONVERT(varchar(25),getdate())+ char(09) +  char(13)
	if ERROR_NUMBER() is not null 
		begin 
			set @Error_Text =  @Error_Text + 'ERROR_SEVERITY:  '  + CONVERT(varchar(max),ERROR_NUMBER())+ char(09) +  char(13)
		end
	if ERROR_SEVERITY() is not null 
		begin
			set @Error_Text = @Error_Text + 'ERROR_SEVERITY:  '  + CONVERT(varchar(max),ERROR_SEVERITY())+ char(09) +  char(13)
		end
	if ERROR_STATE() is not null 
	begin
		set @Error_Text = @Error_Text + 'ERROR_STATE:     '  + CONVERT(varchar(max),ERROR_STATE())+ char(09) +  char(13)
	end
	if ERROR_PROCEDURE() is not null 
	begin
		set @Error_Text = @Error_Text + 'ERROR_PROCEDURE:   '  + CONVERT(varchar(max),ERROR_PROCEDURE())+ char(09) +  char(13)
	end
	if ERROR_LINE() is not null 
	begin
		set @Error_Text = @Error_Text + 'ERROR_LINE:      '  + CONVERT(varchar(max),ERROR_LINE())+ char(09) +  char(13)
	end
	if ERROR_MESSAGE() is not null 
	begin
		set @Error_Text = @Error_Text + 'ERROR_MESSAGE:   '  + CONVERT(varchar(max),ERROR_MESSAGE())+ char(09) +  char(13)
	end
		set @Error_Text = @Error_Text + char(09) +  char(13)
		set @Error_Text = @Error_Text + @str_line

	INSERT INTO [dbo].[LogMsg]
           ([LogMsg],[Logdate])
     VALUES
           (@Error_Text, getdate())
END

GO
