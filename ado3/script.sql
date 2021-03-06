USE [master]
GO
/****** Object:  Database [CRCMS_new]    Script Date: 19.05.2018 13:19:42 ******/
CREATE DATABASE [CRCMS_new]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CRCMS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CRCMS_new.mdf' , SIZE = 118784KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CRCMS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\DATA\CRCMS_new_log.ldf' , SIZE = 625792KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [CRCMS_new] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CRCMS_new].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CRCMS_new] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CRCMS_new] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CRCMS_new] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CRCMS_new] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CRCMS_new] SET ARITHABORT OFF 
GO
ALTER DATABASE [CRCMS_new] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CRCMS_new] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CRCMS_new] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CRCMS_new] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CRCMS_new] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CRCMS_new] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CRCMS_new] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CRCMS_new] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CRCMS_new] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CRCMS_new] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CRCMS_new] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CRCMS_new] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CRCMS_new] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CRCMS_new] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CRCMS_new] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CRCMS_new] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CRCMS_new] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CRCMS_new] SET RECOVERY FULL 
GO
ALTER DATABASE [CRCMS_new] SET  MULTI_USER 
GO
ALTER DATABASE [CRCMS_new] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CRCMS_new] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CRCMS_new] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CRCMS_new] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [CRCMS_new] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'CRCMS_new', N'ON'
GO
USE [CRCMS_new]
GO
/****** Object:  User [CRCMSlogin]    Script Date: 19.05.2018 13:19:42 ******/
CREATE USER [CRCMSlogin] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [CRCMS]    Script Date: 19.05.2018 13:19:42 ******/
CREATE USER [CRCMS] WITHOUT LOGIN WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [BMST-KZ\Adm-Artyom]    Script Date: 19.05.2018 13:19:42 ******/
CREATE USER [BMST-KZ\Adm-Artyom] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [af]    Script Date: 19.05.2018 13:19:42 ******/
CREATE USER [af] FOR LOGIN [af] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [CRCMSlogin]
GO
ALTER ROLE [db_owner] ADD MEMBER [CRCMS]
GO
ALTER ROLE [db_owner] ADD MEMBER [BMST-KZ\Adm-Artyom]
GO
ALTER ROLE [db_owner] ADD MEMBER [af]
GO
ALTER ROLE [db_accessadmin] ADD MEMBER [af]
GO
ALTER ROLE [db_securityadmin] ADD MEMBER [af]
GO
ALTER ROLE [db_ddladmin] ADD MEMBER [af]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [af]
GO
ALTER ROLE [db_datareader] ADD MEMBER [af]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [af]
GO
ALTER ROLE [db_denydatareader] ADD MEMBER [af]
GO
ALTER ROLE [db_denydatawriter] ADD MEMBER [af]
GO
/****** Object:  UserDefinedFunction [dbo].[GetNotUseFulTimeForDocument]    Script Date: 19.05.2018 13:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[GetNotUseFulTimeForDocument]
(@documentId int)
returns @table table
(
TimerInactivityArchiveId int,
UserId int,
AreaId int,
DocumentId int,
DateStart datetime,
DateFinish datetime,
DurationInSeconds int,
StatusId int,
Comment nvarchar(350)
)
as
BEGIN
insert into @table
select * from TimerInactivityArchive t
where t.DocumentId=@documentId
return 
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUsefulTimeForDoCument]    Script Date: 19.05.2018 13:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetUsefulTimeForDoCument] (@DocumentId INT)
RETURNS @TA TABLE
(
TimerArchiveId INT,
UserId INT,
AreaId INT,
DocumentId INT,
DateStart DATETIME,
DateFinish DATETIME,
DurationInSeconds INT
)

AS
BEGIN
	INSERT INTO @TA
	SELECT * FROM [dbo].[TimerArchive] t
	WHERE t.DocumentId = @DocumentId;

	RETURN
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetUsfulTimeByDocument]    Script Date: 19.05.2018 13:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetUsfulTimeByDocument]
(	
	@DocumentId int
)
RETURNS @retTimerTable TABLE 
(
    TimerId int,
	UserId int,
	AreaId int,
	DocumentId int,
	DateStart datetime,
	DateFinish datetime,
	DurationInSeconds int
)
AS
BEGIN
    INSERT @retTimerTable
    SELECT TimerId, UserId, AreaId, DocumentId, DateStart, DateFinish, DurationInSeconds FROM [dbo].[Timer] WHERE DocumentId = @DocumentId
    RETURN
END
GO
/****** Object:  Table [dbo].[__MigrationHistory]    Script Date: 19.05.2018 13:19:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__MigrationHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ContextKey] [nvarchar](300) NOT NULL,
	[Model] [varbinary](max) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK_dbo.__MigrationHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC,
	[ContextKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccessTab]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessTab](
	[TabId] [int] IDENTITY(1,1) NOT NULL,
	[TabName] [nvarchar](255) NULL,
	[GroupId] [int] NULL,
 CONSTRAINT [PK_AccessTab] PRIMARY KEY CLUSTERED 
(
	[TabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccessTabsForDocuments]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessTabsForDocuments](
	[AccessTabDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[UploadTypeId] [int] NULL,
	[TabId] [int] NULL,
 CONSTRAINT [PK_AccessTabsForReports] PRIMARY KEY CLUSTERED 
(
	[AccessTabDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccessUser]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessUser](
	[AccessID] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Create] [datetime] NULL,
	[TabId] [int] NULL,
 CONSTRAINT [PK_AccessUser] PRIMARY KEY CLUSTERED 
(
	[AccessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Area]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Area](
	[AreaId] [int] IDENTITY(1,1) NOT NULL,
	[TypeArea] [int] NULL,
	[Name] [nvarchar](500) NULL,
	[ParentId] [int] NULL,
	[NoSplit] [bit] NULL,
	[AssemblyArea] [bit] NULL,
	[FullName] [nvarchar](500) NULL,
	[MultipleOrders] [bit] NULL,
	[HiddenArea] [bit] NULL,
	[IP] [varchar](5000) NULL,
	[PavilionId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[OrderExecution] [int] NULL,
	[Dependence] [int] NULL,
	[WorkingPeople] [int] NULL,
	[ComponentTypeId] [int] NULL,
	[GroupId] [int] NULL,
	[Segment] [int] NULL,
 CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AreaCamera]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaCamera](
	[AreaCameraId] [int] IDENTITY(1,1) NOT NULL,
	[AreaId] [int] NOT NULL,
	[CameraIP] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AreaCamera] PRIMARY KEY CLUSTERED 
(
	[AreaCameraId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Areas]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Areas](
	[AreaId] [int] IDENTITY(1,1) NOT NULL,
	[TypeArea] [int] NULL,
	[Name] [nvarchar](max) NULL,
	[ParentId] [int] NULL,
	[NoSplit] [bit] NULL,
	[AssemblyArea] [bit] NULL,
	[FullName] [nvarchar](max) NULL,
	[MultipleOrders] [bit] NULL,
	[HiddenArea] [bit] NULL,
	[IP] [nvarchar](max) NULL,
	[PavilionId] [int] NOT NULL,
	[TypeId] [int] NOT NULL,
	[OrderExecution] [int] NULL,
	[Dependence] [int] NULL,
	[WorkingPeople] [int] NULL,
	[ComponentTypeId] [int] NULL,
	[GroupId] [int] NULL,
	[Segment] [int] NULL,
 CONSTRAINT [PK_dbo.Areas] PRIMARY KEY CLUSTERED 
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AreaUpdate]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaUpdate](
	[AreaUpdateId] [int] IDENTITY(1,1) NOT NULL,
	[AreaId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AreaUpdate] PRIMARY KEY CLUSTERED 
(
	[AreaUpdateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetExternalUserCustomer]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetExternalUserCustomer](
	[UserId] [nvarchar](128) NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_ExternalUsersCustomer] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[CustomerId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BusyUsers]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusyUsers](
	[BusyUsersId] [int] IDENTITY(1,1) NOT NULL,
	[AreaId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_BusyUsers] PRIMARY KEY CLUSTERED 
(
	[BusyUsersId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[CommentText] [nvarchar](max) NOT NULL,
	[UserId] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[CommentDate] [datetime] NULL,
	[TypeId] [int] NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CounterCabinet]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterCabinet](
	[DocumentId] [int] NOT NULL,
	[StatusId] [int] NULL,
	[SendDate] [datetime] NULL,
	[AnswerDate] [datetime] NULL,
	[DeliveryMethodId] [int] NULL,
	[Ordered] [bit] NULL,
	[OrderedDate] [datetime] NULL,
 CONSTRAINT [PK_CounterCabinet] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_AreaComponentType]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_AreaComponentType](
	[AreaComponentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[AreaId] [int] NULL,
	[ComponentTypeId] [int] NULL,
 CONSTRAINT [PK_dic_AreaComponentType] PRIMARY KEY CLUSTERED 
(
	[AreaComponentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_ComponentType]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_ComponentType](
	[ComponentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[SMCSComponentID] [int] NULL,
	[ParentId] [int] NULL,
	[ComponentTypeName] [nvarchar](255) NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_TablesComponentType] PRIMARY KEY CLUSTERED 
(
	[ComponentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_ComponentTypeSMCSInterval]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_ComponentTypeSMCSInterval](
	[intSMCSIntervalComponentId] [int] IDENTITY(1,1) NOT NULL,
	[intComponentTypeId] [int] NULL,
	[intStart] [nvarchar](4) NULL,
	[intEnd] [nvarchar](4) NULL,
	[strDescription] [nvarchar](512) NULL,
 CONSTRAINT [PK_dic_ComponentTypeSMCSInterval] PRIMARY KEY CLUSTERED 
(
	[intSMCSIntervalComponentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_CounerCabinetDeliveryMethod]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_CounerCabinetDeliveryMethod](
	[DeliveryMethodId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_dic_CounerCabinetDeliveryMethod] PRIMARY KEY CLUSTERED 
(
	[DeliveryMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_CounterCabinetStatus]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_CounterCabinetStatus](
	[StatusId] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_dic_CounterCabinet_Status] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Customer]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Customer](
	[CustomerId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](1000) NULL,
 CONSTRAINT [PK_dic_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_DeliveryMethod]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_DeliveryMethod](
	[DeliveryMethodId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](350) NOT NULL,
	[Term] [int] NULL,
 CONSTRAINT [PK_dic_DeliveryMethod] PRIMARY KEY CLUSTERED 
(
	[DeliveryMethodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Department]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Department](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](500) NULL,
 CONSTRAINT [PK_dic_Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_DocumentType]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_DocumentType](
	[DocumentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [varchar](50) NULL,
	[Name] [nvarchar](500) NULL,
 CONSTRAINT [PK_dic_DocumentType] PRIMARY KEY CLUSTERED 
(
	[DocumentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_EngineModel]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_EngineModel](
	[EngineModelId] [int] IDENTITY(1,1) NOT NULL,
	[EngineModel] [nvarchar](50) NULL,
	[ComponentTypeId] [int] NULL,
 CONSTRAINT [PK_dic_EngineModel2] PRIMARY KEY CLUSTERED 
(
	[EngineModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Group]    Script Date: 19.05.2018 13:19:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Group](
	[GroupId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
 CONSTRAINT [PK_dic_Group] PRIMARY KEY CLUSTERED 
(
	[GroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Model]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Model](
	[ModelId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](500) NULL,
	[SeriesId] [int] NULL,
 CONSTRAINT [PK_dic_Model] PRIMARY KEY CLUSTERED 
(
	[ModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Pavilion]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Pavilion](
	[PavilionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
 CONSTRAINT [PK_dic_Pavilion] PRIMARY KEY CLUSTERED 
(
	[PavilionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Producer]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Producer](
	[ProducerId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](500) NULL,
 CONSTRAINT [PK_dic_Producer] PRIMARY KEY CLUSTERED 
(
	[ProducerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_RepairType]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_RepairType](
	[RepairTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NULL,
	[Name] [nvarchar](250) NULL,
 CONSTRAINT [PK_dic_RepairType] PRIMARY KEY CLUSTERED 
(
	[RepairTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLaborHours]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLaborHours](
	[SegmentHoursId] [int] IDENTITY(1,1) NOT NULL,
	[SegmentId] [int] NULL,
	[AreaId] [int] NULL,
	[LaborHours] [float] NULL,
 CONSTRAINT [PK_dic_SegmentLaborHours_N] PRIMARY KEY CLUSTERED 
(
	[SegmentHoursId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLaborHours_old]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLaborHours_old](
	[SegmentId] [int] IDENTITY(1,1) NOT NULL,
	[SegmentModelId] [int] NULL,
	[ComponentTypeId] [int] NULL,
	[AreaId] [int] NULL,
	[LaborHours] [float] NULL,
 CONSTRAINT [PK_dic_SegmentLaborHours] PRIMARY KEY CLUSTERED 
(
	[SegmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLabour]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLabour](
	[SegmentId] [int] IDENTITY(1,1) NOT NULL,
	[EngineModelId] [int] NULL,
	[ComponentTypeId] [int] NULL,
	[LaborHours] [float] NULL,
 CONSTRAINT [PK_dic_SegmentLabour] PRIMARY KEY CLUSTERED 
(
	[SegmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLabourModel]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLabourModel](
	[SegmentModelId] [int] IDENTITY(1,1) NOT NULL,
	[SegmentId] [int] NOT NULL,
	[ModelId] [int] NULL,
 CONSTRAINT [PK_dic_SegmentLabourModel_N] PRIMARY KEY CLUSTERED 
(
	[SegmentModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLabourModel_new]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLabourModel_new](
	[SegmentModelId] [int] IDENTITY(1,1) NOT NULL,
	[ModelId] [int] NULL,
 CONSTRAINT [PK_dic_SegmentLabourModel_new] PRIMARY KEY CLUSTERED 
(
	[SegmentModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SegmentLabourModel_old]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SegmentLabourModel_old](
	[SegmentModelId] [int] IDENTITY(1,1) NOT NULL,
	[ModelId] [int] NULL,
	[EngineModelId] [int] NULL,
	[ComponentTypeId] [int] NULL,
	[LaborHours] [float] NULL,
 CONSTRAINT [PK_dic_SegmentLabourModel] PRIMARY KEY CLUSTERED 
(
	[SegmentModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Series]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Series](
	[SeriesId] [int] IDENTITY(1,1) NOT NULL,
	[NameEn] [nvarchar](50) NULL,
	[NameRu] [nvarchar](50) NULL,
 CONSTRAINT [PK_dic_EngineSeries] PRIMARY KEY CLUSTERED 
(
	[SeriesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_SMCSComponent]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_SMCSComponent](
	[SMCSComponentID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](5) NULL,
	[Description] [nvarchar](255) NULL,
	[DescriptionEn] [nvarchar](500) NULL,
 CONSTRAINT [PK_dic_SMCSComponent] PRIMARY KEY CLUSTERED 
(
	[SMCSComponentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_StandStatus]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_StandStatus](
	[StandStatusId] [int] IDENTITY(1,1) NOT NULL,
	[NameRu] [nvarchar](250) NULL,
	[NameEn] [nvarchar](250) NULL,
 CONSTRAINT [PK_dic_StandStatus] PRIMARY KEY CLUSTERED 
(
	[StandStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_Status]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_Status](
	[StatusId] [int] NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[NameRu] [nvarchar](500) NOT NULL,
	[StatusTypeId] [int] NULL,
 CONSTRAINT [PK_dic_ReasonsOfPause] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_TypesOfOperation]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_TypesOfOperation](
	[TypesOfOperationId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[TypesOfWorkId] [int] NULL,
 CONSTRAINT [PK_dic_TypesOfOperation] PRIMARY KEY CLUSTERED 
(
	[TypesOfOperationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_TypesOfWork]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_TypesOfWork](
	[TypesOfWorkId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
 CONSTRAINT [PK_dic_TypesOfWork] PRIMARY KEY CLUSTERED 
(
	[TypesOfWorkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_UploadType]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_UploadType](
	[UploadTypeId] [int] IDENTITY(1,1) NOT NULL,
	[NameRu] [nvarchar](500) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[GroupId] [int] NOT NULL,
	[SortPosition] [int] NULL,
 CONSTRAINT [PK_dic_UploadType] PRIMARY KEY CLUSTERED 
(
	[UploadTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[dic_UserAccessGroup]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dic_UserAccessGroup](
	[GroupId] [int] NULL,
	[Name] [nvarchar](350) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dispatch]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dispatch](
	[DispatchId] [int] IDENTITY(1,1) NOT NULL,
	[Consignor] [nvarchar](550) NULL,
	[Consignee] [nvarchar](550) NULL,
	[Number] [int] NULL,
	[DispatchDate] [date] NULL,
	[CarBrand] [nvarchar](550) NULL,
	[CarNumber] [nvarchar](550) NULL,
	[Driver] [nvarchar](550) NULL,
	[Sender] [nvarchar](550) NULL,
	[Comment] [nvarchar](1050) NULL,
	[Saved] [bit] NULL,
	[TransportCompany] [nvarchar](550) NULL,
	[Destination] [nvarchar](550) NULL,
 CONSTRAINT [PK_Dispatch] PRIMARY KEY CLUSTERED 
(
	[DispatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DispatchItem]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DispatchItem](
	[DispatchItemId] [int] IDENTITY(1,1) NOT NULL,
	[DispatchId] [int] NOT NULL,
	[DocumentId] [int] NULL,
	[Component] [nvarchar](250) NULL,
	[SerialNumber] [nvarchar](250) NULL,
	[Comment] [nvarchar](500) NULL,
	[Quantity] [int] NULL,
	[Unit] [nvarchar](50) NULL,
	[PlaceQuantity] [int] NULL,
 CONSTRAINT [PK_DispatchItem] PRIMARY KEY CLUSTERED 
(
	[DispatchItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentNumber] [nvarchar](50) NULL,
	[DocumentCreateDate] [datetime] NULL,
	[DocumentCloseDate] [datetime] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[DocumentTypeId] [int] NULL,
	[CustomerId] [int] NULL,
	[ModelId] [int] NULL,
	[DepartmentId] [int] NULL,
	[ProducerId] [int] NULL,
	[StockId] [int] NULL,
	[MachinesSN] [nvarchar](50) NULL,
	[HoursMachines] [decimal](18, 0) NULL,
	[Description] [nvarchar](500) NULL,
	[SmcsCode] [nvarchar](50) NULL,
	[ComponentSN] [nvarchar](50) NULL,
	[ComponentDismantlingDate] [datetime] NULL,
	[PartsCost] [money] NULL,
	[WorkCost] [money] NULL,
	[ConsumablesCost] [money] NULL,
	[ApprovedServiceEngineer] [bit] NULL,
	[EngineModelId] [int] NULL,
	[ComponentHours] [money] NULL,
	[RepairTypeId] [int] NULL,
	[ArrivalMonth] [datetime] NULL,
	[DispatchDate] [datetime] NULL,
	[DeliveryMethodId] [int] NULL,
	[ToPlan] [bit] NULL,
	[CabinetSE] [int] NULL,
	[IsArrived] [bit] NULL,
	[ParentId] [int] NULL,
	[StatusId] [int] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentArea]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentArea](
	[DocumentAreaId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
	[Status] [int] NOT NULL,
	[MaxHours] [decimal](18, 2) NULL,
 CONSTRAINT [PK_DocumentAreas] PRIMARY KEY CLUSTERED 
(
	[DocumentAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentOldCopy]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentOldCopy](
	[DocumentId] [int] NOT NULL,
	[DocumentNumber] [nvarchar](50) NULL,
	[DocumentCreateDate] [datetime] NULL,
	[DocumentCloseDate] [datetime] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[DocumentTypeId] [int] NULL,
	[CustomerId] [int] NULL,
	[ModelId] [int] NULL,
	[DepartmentId] [int] NULL,
	[ProducerId] [int] NULL,
	[StockId] [int] NULL,
	[MachinesSN] [nvarchar](50) NULL,
	[HoursMachines] [decimal](18, 0) NULL,
	[Description] [nvarchar](500) NULL,
	[SmcsCode] [nvarchar](50) NULL,
	[ComponentSN] [nvarchar](50) NULL,
	[ComponentDismantlingDate] [datetime] NULL,
	[PartsCost] [money] NULL,
	[WorkCost] [money] NULL,
	[ConsumablesCost] [money] NULL,
	[ApprovedServiceEngineer] [bit] NULL,
	[EngineModelId] [int] NULL,
	[ComponentHours] [money] NULL,
	[RepairTypeId] [int] NULL,
	[ArrivalMonth] [datetime] NULL,
	[DispatchDate] [datetime] NULL,
	[DeliveryMethodId] [int] NULL,
	[ToPlan] [bit] NULL,
	[CabinetSE] [int] NULL,
 CONSTRAINT [PK_DocumentOldCopy] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentsLine]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentsLine](
	[DocumentsLineId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[SortPriority] [int] NOT NULL,
	[AreaId] [int] NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_DocumentsLine_1] PRIMARY KEY CLUSTERED 
(
	[DocumentsLineId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Entity1Set]    Script Date: 19.05.2018 13:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entity1Set](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[MyProp] [nvarchar](max) NOT NULL,
	[myProp2] [int] NULL,
 CONSTRAINT [PK_Entity1Set] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LettersToSend]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LettersToSend](
	[LettersToSendId] [int] NOT NULL,
	[EmailFrom] [nvarchar](250) NULL,
	[EmailTo] [nvarchar](250) NULL,
	[Subject] [nvarchar](1000) NULL,
	[Message] [nvarchar](4000) NULL,
 CONSTRAINT [PK_LettersToSend] PRIMARY KEY CLUSTERED 
(
	[LettersToSendId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LocalUser]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LocalUser](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[SID] [nvarchar](1024) NULL,
	[Name] [nvarchar](350) NULL,
 CONSTRAINT [PK_LocalUser] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MachineShopComponent]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MachineShopComponent](
	[MachineShopComponentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NULL,
	[SMCSComponentID] [int] NULL,
	[TypesOfWorkId] [int] NULL,
	[TypesOfOperationId] [int] NULL,
	[ConfirmTamplate] [bit] NULL,
 CONSTRAINT [PK_MachineShopComponent] PRIMARY KEY CLUSTERED 
(
	[MachineShopComponentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanningDetailsList]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanningDetailsList](
	[PlanningDetailsListId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NULL,
	[DocumentNumber] [nvarchar](50) NULL,
	[DocumentCreateDate] [datetime] NULL,
	[ModelId] [int] NULL,
	[ModelName] [nvarchar](50) NULL,
	[EngineModel] [int] NULL,
	[AreaId] [int] NULL,
	[ParentId] [int] NULL,
	[AreaName] [nvarchar](50) NULL,
	[LaborHours] [float] NULL,
	[WorkingPeople] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[FactStartDate] [datetime] NULL,
	[FactEndDate] [datetime] NULL,
	[DateWithError] [datetime] NULL,
	[PlanDate] [datetime] NULL,
	[DifferenceStart] [float] NULL,
	[DifferenceFinish] [float] NULL,
	[DifferencePause] [float] NULL,
	[SortPriority] [int] NULL,
	[OrderExecution] [int] NULL,
	[Dependence] [int] NULL,
	[Color] [nvarchar](50) NULL,
	[NonStop] [bit] NULL,
	[ComponentTypeId] [int] NULL,
	[ChangePlaces] [bit] NULL,
	[SortExecution] [int] NULL,
 CONSTRAINT [PK_PlanningDetailsList] PRIMARY KEY CLUSTERED 
(
	[PlanningDetailsListId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanningDocumentList]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanningDocumentList](
	[DocumentsPlanId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NULL,
	[SortPriority] [int] NULL,
	[Status] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Color] [nvarchar](50) NULL,
 CONSTRAINT [PK_PlanningDocumentList] PRIMARY KEY CLUSTERED 
(
	[DocumentsPlanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reception]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reception](
	[ReceptionId] [int] IDENTITY(1,1) NOT NULL,
	[Comment] [nvarchar](max) NULL,
	[ReceptionDate] [datetime] NULL,
	[Saved] [bit] NULL,
	[City] [nvarchar](350) NULL,
	[Customer] [nvarchar](350) NULL,
 CONSTRAINT [PK_Reception] PRIMARY KEY CLUSTERED 
(
	[ReceptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionAreaMessages]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionAreaMessages](
	[ReceptionAreaMessagesId] [int] IDENTITY(1,1) NOT NULL,
	[City] [nvarchar](350) NULL,
	[Customer] [nvarchar](350) NULL,
	[Message] [nvarchar](max) NULL,
	[ReceptionDate] [datetime] NULL,
 CONSTRAINT [PK_ReceptionAreaMessages] PRIMARY KEY CLUSTERED 
(
	[ReceptionAreaMessagesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReceptionItem]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReceptionItem](
	[ReceptionItemId] [int] IDENTITY(1,1) NOT NULL,
	[ReceptionId] [int] NOT NULL,
	[DocumentId] [int] NULL,
	[City] [nvarchar](250) NULL,
	[Customer] [nvarchar](250) NULL,
	[Component] [nvarchar](250) NULL,
	[SerialNumber] [nvarchar](250) NULL,
	[Comment] [nvarchar](500) NULL,
	[IsHaveRequest] [bit] NOT NULL,
	[StandStatusId] [int] NULL,
	[IsCompleted] [bit] NULL,
 CONSTRAINT [PK_ReceptionItem] PRIMARY KEY CLUSTERED 
(
	[ReceptionItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Redo]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Redo](
	[RedoId] [int] IDENTITY(1,1) NOT NULL,
	[AreaId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[Comment] [nvarchar](2000) NOT NULL,
	[RedoDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Redo] PRIMARY KEY CLUSTERED 
(
	[RedoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Schedule]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schedule](
	[ScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[Comment] [nvarchar](3000) NULL,
	[StartDate] [datetime] NULL,
	[FinishDate] [datetime] NULL,
	[Duration] [int] NULL,
	[Deadline] [datetime] NULL,
	[AreaId] [int] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_Schedule] PRIMARY KEY CLUSTERED 
(
	[ScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ShowWorkOrderFiles]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ShowWorkOrderFiles](
	[ShowFileId] [int] IDENTITY(1,1) NOT NULL,
	[UploadTypeId] [int] NULL,
	[Show] [bit] NULL,
 CONSTRAINT [PK_ShowWorkOrderFiles_] PRIMARY KEY CLUSTERED 
(
	[ShowFileId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SmcsCodeCabinetSe]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmcsCodeCabinetSe](
	[CabinetId] [int] IDENTITY(1,1) NOT NULL,
	[TabId] [int] NULL,
	[SMCSComponentID] [int] NULL,
 CONSTRAINT [PK_SmcsCodeCabinetSe] PRIMARY KEY CLUSTERED 
(
	[CabinetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Table_Bill]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Bill](
	[billId] [int] IDENTITY(1,1) NOT NULL,
	[orderId] [int] NULL,
 CONSTRAINT [PK_Table_Bill] PRIMARY KEY CLUSTERED 
(
	[billId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Table_Order]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Table_Order](
	[orderId] [int] IDENTITY(1,1) NOT NULL,
	[orderNumber] [nvarchar](50) NULL,
	[createDate] [datetime] NULL,
 CONSTRAINT [PK_Table_Order] PRIMARY KEY CLUSTERED 
(
	[orderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TamplateOperation]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TamplateOperation](
	[TamplateOperationId] [int] IDENTITY(1,1) NOT NULL,
	[TypesOfWorkId] [int] NULL,
	[TypesOfOperationId] [int] NULL,
 CONSTRAINT [PK_TamplateOperation] PRIMARY KEY CLUSTERED 
(
	[TamplateOperationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TamplateOperationArea]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TamplateOperationArea](
	[TamplateOperationAreaId] [int] IDENTITY(1,1) NOT NULL,
	[TamplateOperationId] [int] NULL,
	[AreaId] [int] NULL,
 CONSTRAINT [PK_TamplateOperationArea] PRIMARY KEY CLUSTERED 
(
	[TamplateOperationAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TemporaryOrder]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TemporaryOrder](
	[TemporaryOrderId] [int] NULL,
	[DocumentId] [int] NULL,
	[DocumentNumber] [int] NULL,
	[ModelId] [int] NULL,
	[MachinesSN] [nvarchar](50) NULL,
	[CustomerId] [int] NULL,
	[SmcsCode] [nvarchar](50) NULL,
	[Description] [nvarchar](500) NULL,
	[ComponentSN] [nvarchar](50) NULL,
	[EngineModelId] [int] NULL,
	[PSStatus] [datetime] NULL,
	[SMCSStatus] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Timer]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Timer](
	[TimerId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[AreaId] [int] NULL,
	[DocumentId] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateFinish] [datetime] NULL,
	[DurationInSeconds] [int] NULL,
 CONSTRAINT [PK_Timer] PRIMARY KEY CLUSTERED 
(
	[TimerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimerArchive]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerArchive](
	[TimerArchiveId] [int] NOT NULL,
	[UserId] [int] NULL,
	[AreaId] [int] NULL,
	[DocumentId] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateFinish] [datetime] NULL,
	[DurationInSeconds] [int] NULL,
 CONSTRAINT [PK_TimerArchive] PRIMARY KEY CLUSTERED 
(
	[TimerArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimerInactivity]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerInactivity](
	[TimerInactivityId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[AreaId] [int] NULL,
	[DocumentId] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateFinish] [datetime] NULL,
	[DurationInSeconds] [int] NULL,
	[StatusId] [int] NULL,
	[Comment] [nvarchar](350) NULL,
 CONSTRAINT [PK_TimerInactivity] PRIMARY KEY CLUSTERED 
(
	[TimerInactivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimerInactivityArchive]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimerInactivityArchive](
	[TimerInactivityArchiveId] [int] NOT NULL,
	[UserId] [int] NULL,
	[AreaId] [int] NULL,
	[DocumentId] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateFinish] [datetime] NULL,
	[DurationInSeconds] [int] NULL,
	[StatusId] [int] NULL,
	[Comment] [nvarchar](350) NULL,
 CONSTRAINT [PK_TimerInactivityArchive] PRIMARY KEY CLUSTERED 
(
	[TimerInactivityArchiveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Timers]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Timers](
	[TimerId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[AreaId] [int] NULL,
	[DocumentId] [int] NULL,
	[DateStart] [datetime] NULL,
	[DateFinish] [datetime] NULL,
	[DurationInSeconds] [int] NULL,
 CONSTRAINT [PK_dbo.Timers] PRIMARY KEY CLUSTERED 
(
	[TimerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Upload]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Upload](
	[UploadId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](1000) NOT NULL,
	[Path] [nvarchar](1000) NOT NULL,
	[TypeId] [int] NOT NULL,
	[DocumentId] [int] NOT NULL,
	[Extension] [nvarchar](10) NULL,
	[SizeKB] [decimal](18, 2) NULL,
	[DateUpload] [datetime] NULL,
	[ZoneId] [int] NULL,
	[UserId] [nvarchar](100) NULL,
	[UserName] [nvarchar](250) NULL,
	[ReferenceId] [int] NULL,
 CONSTRAINT [PK_Upload] PRIMARY KEY CLUSTERED 
(
	[UploadId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](350) NOT NULL,
	[Code] [nvarchar](15) NOT NULL,
	[EmployeeNumber] [nvarchar](12) NULL,
	[GroupId] [int] NULL,
	[Team] [nvarchar](350) NULL,
	[JobTitle] [nvarchar](350) NULL,
	[TeamId] [int] NULL,
	[SAPNumber] [nvarchar](50) NULL,
	[NameEn] [nvarchar](250) NULL,
	[ShowInWorkReport] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 19.05.2018 13:19:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersAccess]    Script Date: 19.05.2018 13:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersAccess](
	[UsersAccessId] [int] IDENTITY(1,1) NOT NULL,
	[Email] [varchar](250) NOT NULL,
	[Name] [nvarchar](350) NOT NULL,
	[GroupId] [int] NOT NULL,
 CONSTRAINT [PK_UsersAccess] PRIMARY KEY CLUSTERED 
(
	[UsersAccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UsersHardWorkForDataBase]    Script Date: 19.05.2018 13:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UsersHardWorkForDataBase](
	[UserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](max) NOT NULL,
	[description] [varchar](max) NULL,
 CONSTRAINT [PK_UsersHardWorkForDataBase] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [RoleNameIndex]    Script Date: 19.05.2018 13:19:46 ******/
CREATE UNIQUE NONCLUSTERED INDEX [RoleNameIndex] ON [dbo].[AspNetRoles]
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserClaims]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserLogins]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_RoleId]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_UserId]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[AspNetUserRoles]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UserNameIndex]    Script Date: 19.05.2018 13:19:46 ******/
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex] ON [dbo].[AspNetUsers]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Document_7_517576882__K1_15]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Document_7_517576882__K1_15] ON [dbo].[Document]
(
	[DocumentId] ASC
)
INCLUDE ( 	[ComponentSN]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Document_7_517576882__K2_8066]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Document_7_517576882__K2_8066] ON [dbo].[Document]
(
	[DocumentNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Document_7_517576882__K21]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Document_7_517576882__K21] ON [dbo].[Document]
(
	[EngineModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Document_7_517576882__K24_1_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_18_19_20_21_22_23_25_26_9987]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Document_7_517576882__K24_1_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_18_19_20_21_22_23_25_26_9987] ON [dbo].[Document]
(
	[ArrivalMonth] ASC
)
INCLUDE ( 	[DocumentId],
	[DocumentNumber],
	[DocumentCreateDate],
	[DocumentCloseDate],
	[CreatedBy],
	[ApprovedServiceEngineer],
	[EngineModelId],
	[Description],
	[ComponentSN],
	[DispatchDate],
	[DeliveryMethodId],
	[WorkCost],
	[ConsumablesCost],
	[ModelId],
	[DepartmentId],
	[ComponentHours],
	[RepairTypeId],
	[MachinesSN],
	[HoursMachines],
	[ProducerId],
	[StockId],
	[ComponentDismantlingDate],
	[PartsCost],
	[DocumentTypeId],
	[CustomerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_Document_7_517576882__K25_1_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_18_19_20_21_22_23_24_26_9987]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Document_7_517576882__K25_1_2_3_4_5_6_7_8_9_10_11_12_13_14_15_16_17_18_19_20_21_22_23_24_26_9987] ON [dbo].[Document]
(
	[DispatchDate] ASC
)
INCLUDE ( 	[DocumentId],
	[DocumentNumber],
	[DocumentCreateDate],
	[DocumentCloseDate],
	[CreatedBy],
	[ApprovedServiceEngineer],
	[EngineModelId],
	[Description],
	[ComponentSN],
	[ArrivalMonth],
	[DeliveryMethodId],
	[WorkCost],
	[ConsumablesCost],
	[ModelId],
	[DepartmentId],
	[ComponentHours],
	[RepairTypeId],
	[MachinesSN],
	[HoursMachines],
	[ProducerId],
	[StockId],
	[ComponentDismantlingDate],
	[PartsCost],
	[DocumentTypeId],
	[CustomerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [_dta_index_Timer_7_1813581499__K3_K4_K6_1_2_5_7_4149]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_Timer_7_1813581499__K3_K4_K6_1_2_5_7_4149] ON [dbo].[Timer]
(
	[AreaId] ASC,
	[DocumentId] ASC,
	[DateFinish] ASC
)
INCLUDE ( 	[TimerId],
	[UserId],
	[DateStart],
	[DurationInSeconds]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [_dta_index_TimerInactivity_7_2037582297__K6_K4_K3_K2_1_5_7_8_9]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [_dta_index_TimerInactivity_7_2037582297__K6_K4_K3_K2_1_5_7_8_9] ON [dbo].[TimerInactivity]
(
	[DateFinish] ASC,
	[DocumentId] ASC,
	[AreaId] ASC,
	[UserId] ASC
)
INCLUDE ( 	[TimerInactivityId],
	[DateStart],
	[DurationInSeconds],
	[StatusId],
	[Comment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_AreaId]    Script Date: 19.05.2018 13:19:46 ******/
CREATE NONCLUSTERED INDEX [IX_AreaId] ON [dbo].[Timers]
(
	[AreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Area] ADD  CONSTRAINT [DF_Area_GroupId]  DEFAULT ((0)) FOR [GroupId]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [CustomerId]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_CommentDate]  DEFAULT (getdate()) FOR [CommentDate]
GO
ALTER TABLE [dbo].[Document] ADD  CONSTRAINT [DF_Document_IsArrived]  DEFAULT ((0)) FOR [IsArrived]
GO
ALTER TABLE [dbo].[DocumentArea] ADD  CONSTRAINT [DF_DocumentArea_MaxHours]  DEFAULT ((0)) FOR [MaxHours]
GO
ALTER TABLE [dbo].[PlanningDetailsList] ADD  CONSTRAINT [DF_PlanningDetailsList_ChangePlaces]  DEFAULT ((0)) FOR [ChangePlaces]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[Timer]  WITH CHECK ADD  CONSTRAINT [FK_Timer_Area] FOREIGN KEY([AreaId])
REFERENCES [dbo].[Area] ([AreaId])
GO
ALTER TABLE [dbo].[Timer] CHECK CONSTRAINT [FK_Timer_Area]
GO
ALTER TABLE [dbo].[Timer]  WITH CHECK ADD  CONSTRAINT [FK_Timer_Document] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[Timer] CHECK CONSTRAINT [FK_Timer_Document]
GO
ALTER TABLE [dbo].[TimerArchive]  WITH CHECK ADD  CONSTRAINT [FK_TimerArchive_Document] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[TimerArchive] CHECK CONSTRAINT [FK_TimerArchive_Document]
GO
ALTER TABLE [dbo].[TimerInactivity]  WITH CHECK ADD  CONSTRAINT [FK_TimerInactivity_Document] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[TimerInactivity] CHECK CONSTRAINT [FK_TimerInactivity_Document]
GO
ALTER TABLE [dbo].[TimerInactivityArchive]  WITH CHECK ADD  CONSTRAINT [FK_TimerInactivityArchive_Document] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[TimerInactivityArchive] CHECK CONSTRAINT [FK_TimerInactivityArchive_Document]
GO
ALTER TABLE [dbo].[Timers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Timers_dbo.Areas_AreaId] FOREIGN KEY([AreaId])
REFERENCES [dbo].[Areas] ([AreaId])
GO
ALTER TABLE [dbo].[Timers] CHECK CONSTRAINT [FK_dbo.Timers_dbo.Areas_AreaId]
GO
ALTER TABLE [dbo].[Timers]  WITH CHECK ADD  CONSTRAINT [FK_Timers_Document] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[Timers] CHECK CONSTRAINT [FK_Timers_Document]
GO
/****** Object:  StoredProcedure [dbo].[GetDocumentInfo]    Script Date: 19.05.2018 13:19:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetDocumentInfo]
	 @DocumentId int
AS
BEGIN
	  SELECT * FROM Document 
    WHERE DocumentId=@DocumentId;
END
GO
USE [master]
GO
ALTER DATABASE [CRCMS_new] SET  READ_WRITE 
GO
