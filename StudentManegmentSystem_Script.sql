USE [master]
GO
/****** Object:  Database [StudentManagementDB]    Script Date: 4/20/2017 10:28:03 AM ******/
CREATE DATABASE [StudentManagementDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'StudentManagementDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\StudentManagementDB.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'StudentManagementDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\StudentManagementDB_log.ldf' , SIZE = 12352KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [StudentManagementDB] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [StudentManagementDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [StudentManagementDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [StudentManagementDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [StudentManagementDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [StudentManagementDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [StudentManagementDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [StudentManagementDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [StudentManagementDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [StudentManagementDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [StudentManagementDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [StudentManagementDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [StudentManagementDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [StudentManagementDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [StudentManagementDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [StudentManagementDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [StudentManagementDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [StudentManagementDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [StudentManagementDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [StudentManagementDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [StudentManagementDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [StudentManagementDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [StudentManagementDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [StudentManagementDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [StudentManagementDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [StudentManagementDB] SET RECOVERY FULL 
GO
ALTER DATABASE [StudentManagementDB] SET  MULTI_USER 
GO
ALTER DATABASE [StudentManagementDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [StudentManagementDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [StudentManagementDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [StudentManagementDB] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'StudentManagementDB', N'ON'
GO
USE [StudentManagementDB]
GO
/****** Object:  StoredProcedure [dbo].[BulkUpload]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[BulkUpload]

AS
BEGIN
--school
		insert into tbl_school (Name) select distinct School_Name from [dbo].[tbl_student_temp] where School_Name <> '' 
		EXCEPT	select Name from tbl_school

		update [tbl_student_temp] set School_Id =  s.Id from [dbo].[tbl_student_temp] st
		inner join tbl_school s on  st.School_Name = s.Name  where School_Name <> ''

--standard
		insert into [tbl_standard] (Name) select distinct Standard_Name from [dbo].[tbl_student_temp] where Standard_Name <> '' 
		EXCEPT	select Name from [tbl_standard]

		update [tbl_student_temp] set Standard_Id =  s.Id from [dbo].[tbl_student_temp] st
		inner join [dbo].[tbl_standard] s on  st.Standard_Name = s.Name  where Standard_Name <> ''

--section
		insert into [tbl_section] (Name) select distinct Section_Name from [dbo].[tbl_student_temp] where Section_Name <> '' 
		EXCEPT	select Name from [tbl_section]

		update [tbl_student_temp] set Section_Id =  s.Id from [dbo].[tbl_student_temp] st
		inner join [dbo].[tbl_section] s on  st.Section_Name = s.Name  where Section_Name <> ''


	insert into [dbo].[tbl_student] (Name, School_Id, Standard_Id, Section_Id, Roll_No, DOB, Blood_Group, Gender) 
	select distinct Name, School_Id, Standard_Id, Section_Id, Roll_No, DOB, Blood_Group, Gender from [dbo].[tbl_student_temp] 
	where Roll_No <> '' EXCEPT	select Name, School_Id, Standard_Id, Section_Id, Roll_No, DOB, Blood_Group, Gender 
	from [dbo].[tbl_student]

	truncate table [dbo].[tbl_student_temp]
END

GO
/****** Object:  StoredProcedure [dbo].[GetAllDropDown]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllDropDown]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	Select * from tbl_school
	select * from tbl_standard order by Name asc;
	select * from tbl_section

END

GO
/****** Object:  StoredProcedure [dbo].[Link1]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Link1]
	
AS
BEGIN
	Select s.Name, s.DOB, s.Blood_Group, s.Roll_No, s.Gender, sc.Name as School_Name,  st.Name as Standard_Name
	from [dbo].[tbl_student] s inner join [dbo].[tbl_school] sc on sc.Id = s.School_Id inner join tbl_section se on se.Id  = s.Section_Id
	inner join tbl_standard st on st.Id = s.Standard_Id where st.Name ='10'

END

GO
/****** Object:  StoredProcedure [dbo].[Link2]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Link2]
AS
BEGIN
	select count(*) as count  from [dbo].[tbl_student] stu inner join [dbo].[tbl_section] sec on stu.Section_Id = sec.Id  inner join tbl_standard 
	tst on tst.Id = stu.Standard_Id where  sec.Name = 'A'

	--select stu.Name, stu.Roll_No, stu.DOB, stu.Blood_Group, stu.Gender, sec.Name as Sec_Name, tst.Name as Standard_Name from 
	--[dbo].[tbl_student] stu inner join [dbo].[tbl_section] sec on stu.Section_Id = sec.Id  inner join tbl_standard 
	--tst on tst.Id = stu.Standard_Id where  sec.Name = 'A'
END

GO
/****** Object:  StoredProcedure [dbo].[Link3]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Link3]
AS
BEGIN
	SELECT s.Name,s.Roll_No,s.DOB,s.Gender,s.Blood_Group, se.Name as Section_Name,st.Name as Standard_Name,sc.Name as School_Name 
	from [dbo].[tbl_student] s 	inner join [dbo].[tbl_school] sc on sc.Id = s.School_Id inner join tbl_section se 
	on se.Id  = s.Section_Id inner join tbl_standard st on st.Id = s.Standard_Id where DATEDIFF(hour,DOB,GETDATE())/8766 
	between 13 and 17
END

GO
/****** Object:  StoredProcedure [dbo].[Link4]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Link4]
AS
BEGIN
	select stu.Name, stu.Roll_No, stu.DOB, stu.Blood_Group, stu.Gender,se.Name as Section_Name,st.Name as Standard_Name,
	sc.Name as School_Name 	 from [dbo].[tbl_student] stu 	inner join [dbo].[tbl_school] sc on sc.Id = stu.School_Id 
	inner join tbl_section se on se.Id  = stu.Section_Id 	inner join tbl_standard st on st.Id = stu.Standard_Id 
	where stu.Gender = 'male' and stu.Blood_Group='AB-'
END

GO
/****** Object:  StoredProcedure [dbo].[Link5]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Link5]
AS
BEGIN
	select (select Name from tbl_school where id = school_Id) as School_Name, (select Name from tbl_standard where id = Standard_Id) as Standard_Name , (select count
(Gender) from dbo.tbl_student where Gender = 
'male' 
and Standard_Id = ts.Standard_Id and School_Id 
=ts.School_Id ) as Male , (select count(Gender) from dbo.tbl_student where Gender = 'female' 
and Standard_Id = ts.Standard_Id and School_Id =ts.School_Id ) as Female from dbo.tbl_student  ts group by  Standard_Id, 
School_Id

END

GO
/****** Object:  StoredProcedure [dbo].[ViewAllStudents]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ViewAllStudents]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	Select s.Name, s.DOB, s.Blood_Group, s.Roll_No, s.Gender, sc.Name as School_Name, se.Name as Section_Name, st.Name as Standard_Name,
	sc.Id as School_Id, se.Id as Section_Id, st.Id as Standard_Id from [dbo].[tbl_student] s inner join [dbo].[tbl_school] sc
	on sc.Id = s.School_Id inner join tbl_section se on se.Id  = s.Section_Id inner join tbl_standard st on st.Id = s.Standard_Id
END

GO
/****** Object:  Table [dbo].[tbl_school]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_school](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Status] [bit] NULL,
	[Created_on] [datetime] NULL,
	[Created_by] [varchar](50) NULL,
	[Updated_on] [datetime] NULL,
	[Updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_school] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_section]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_section](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Standard_Id] [int] NULL,
	[Status] [bit] NULL,
	[Created_on] [datetime] NULL,
	[Created_by] [varchar](50) NULL,
	[Updated_on] [datetime] NULL,
	[Updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_section] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_standard]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_standard](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[School_Id] [int] NULL,
	[Status] [bit] NULL,
	[Created_on] [datetime] NULL,
	[Created_by] [varchar](50) NULL,
	[Updated_on] [datetime] NULL,
	[Updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_standard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_student]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_student](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[School_Id] [int] NULL,
	[Standard_Id] [int] NULL,
	[Section_Id] [int] NULL,
	[Roll_No] [int] NULL,
	[DOB] [date] NULL,
	[Blood_Group] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[Status] [bit] NULL,
	[Created_on] [datetime] NULL,
	[Created_by] [varchar](50) NULL,
	[Updated_on] [datetime] NULL,
	[Updated_by] [varchar](50) NULL,
 CONSTRAINT [PK_tbl_student] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tbl_student_temp]    Script Date: 4/20/2017 10:28:04 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tbl_student_temp](
	[Name] [varchar](50) NULL,
	[School_Name] [varchar](50) NULL,
	[Standard_Name] [varchar](50) NULL,
	[Section_Name] [varchar](50) NULL,
	[Roll_No] [int] NULL,
	[DOB] [date] NULL,
	[Blood_Group] [varchar](50) NULL,
	[Gender] [varchar](50) NULL,
	[School_Id] [int] NULL,
	[Standard_Id] [int] NULL,
	[Section_Id] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[tbl_school] ON 

INSERT [dbo].[tbl_school] ([Id], [Name], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (1, N'CBSE School', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_school] ([Id], [Name], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (2, N'Demo School', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_school] ([Id], [Name], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (3, N'Trial School', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_school] ([Id], [Name], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (4, N'Model School', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_school] ([Id], [Name], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (5, N'DPS', 1, CAST(0x0000A75A010EB8B0 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbl_school] OFF
SET IDENTITY_INSERT [dbo].[tbl_section] ON 

INSERT [dbo].[tbl_section] ([Id], [Name], [Standard_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (1, N'A', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_section] ([Id], [Name], [Standard_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (2, N'B', NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbl_section] OFF
SET IDENTITY_INSERT [dbo].[tbl_standard] ON 

INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (1, N'3', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (2, N'12', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (3, N'9', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (4, N'Pre-KG', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (5, N'2', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (6, N'8', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (7, N'6', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (8, N'UKG', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (9, N'11', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (10, N'1', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (11, N'7', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (12, N'10', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (13, N'5', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (14, N'LKG', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_standard] ([Id], [Name], [School_Id], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (15, N'4', NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbl_standard] OFF
SET IDENTITY_INSERT [dbo].[tbl_student] ON 

INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (1, N'AAKASH J', 3, 11, 1, 1, CAST(0xF5250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (2, N'AANCHAL GUPTA', 2, 2, 2, 1, CAST(0x88240B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (3, N'ABHINANDH S', 3, 11, 1, 2, CAST(0xCD260B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (4, N'ADITYA R', 2, 9, 2, 1, CAST(0xF5250B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (5, N'ADITYA RAJU GANAPATHI', 2, 2, 1, 2, CAST(0x60250B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (6, N'ADITYA RAJU GANAPATHI', 3, 5, 1, 1, CAST(0x172D0B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (7, N'AG ABISHEK', 1, 2, 1, 4, CAST(0x2E240B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (8, N'AGRAWAL PARUL', 2, 2, 1, 5, CAST(0x63240B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (9, N'AHAD KHAN', 4, 2, 2, 2, CAST(0x60250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (10, N'AHMED FARHAN M', 3, 8, 1, 1, CAST(0xCC320B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (11, N'AISHWARRYA P', 4, 11, 1, 3, CAST(0xD6250B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (12, N'AISHWARYA A', 2, 2, 2, 3, CAST(0x69240B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (13, N'AISHWARYA G', 4, 11, 1, 4, CAST(0x9C250B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (14, N'AJAYSESHATTHRI V G', 4, 2, 2, 4, CAST(0x2E240B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (15, N'AJITH S T', 4, 2, 2, 5, CAST(0x63240B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (16, N'AKANKSHA MALHOTRA', 2, 2, 2, 6, CAST(0xC1240B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (17, N'AKHIL G', 1, 11, 1, 5, CAST(0xD0250B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (18, N'AKSHAY K', 3, 11, 1, 1, CAST(0xBD290B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (19, N'AMARCHAND S', 1, 11, 1, 6, CAST(0x2E260B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (20, N'ANAND ABHAY P', 1, 4, 2, 1, CAST(0xEF360B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (21, N'ANITHAA H', 2, 4, 1, 2, CAST(0x3C380B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (22, N'ANJALI GUPTA', 3, 10, 1, 1, CAST(0xF22F0B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (23, N'ANJAN CHIDAMBARAM', 2, 2, 2, 7, CAST(0x88240B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (24, N'ANJAN SUHAS', 3, 4, 1, 3, CAST(0x7A380B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (25, N'ANJANA J', 1, 4, 1, 4, CAST(0x7B380B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (26, N'ANJANA J', 2, 1, 1, 1, CAST(0xAA2B0B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (27, N'ANJANA J', 3, 4, 2, 2, CAST(0x4D370B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (28, N'ANJU KURIAN', 1, 2, 2, 8, CAST(0x60250B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (29, N'ANKITA JAIN', 3, 4, 1, 5, CAST(0x23380B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (30, N'ANKITHA M', 3, 4, 1, 6, CAST(0x03380B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (31, N'ANNAMALAI VISHWANATH M', 2, 2, 1, 6, CAST(0xC1240B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (32, N'ANNAMALAI VISHWANATH M', 4, 4, 1, 7, CAST(0xED370B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (33, N'ANNAPOORNA T', 3, 4, 1, 8, CAST(0x99380B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (34, N'ANOOP VISHAL', 1, 14, 2, 1, CAST(0x39340B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (35, N'ANOOP VISHAL', 4, 12, 1, 1, CAST(0x62270B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (36, N'ANUGRAHA S M', 3, 4, 1, 9, CAST(0x07380B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (37, N'ANUPRIYA A', 4, 4, 1, 10, CAST(0xDC380B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (38, N'APOORVA MOOKHERJEE', 1, 1, 2, 1, CAST(0xAA2B0B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (39, N'APOORVA MOOKHERJEE', 1, 3, 1, 1, CAST(0xF5250B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (40, N'ARAAVIND S', 4, 10, 2, 1, CAST(0x842E0B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (41, N'ARCHANA B', 1, 12, 2, 1, CAST(0x62270B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (42, N'ARCHANA B', 2, 14, 1, 1, CAST(0xA7350B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (43, N'ARCHANA B', 4, 5, 1, 2, CAST(0xEF2D0B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (44, N'ARCHITA S', 1, 2, 1, 7, CAST(0x88240B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (45, N'ARJUNASARATHY M', 1, 2, 1, 8, CAST(0x60250B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (46, N'ARUN M', 3, 5, 1, 3, CAST(0xF82C0B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (47, N'ARVIND G', 4, 13, 2, 1, CAST(0x09270B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (48, N'ARVIND P', 2, 12, 2, 2, CAST(0x3A280B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (49, N'ARVIND P', 3, 11, 1, 7, CAST(0xF5250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (50, N'ARVIND P', 3, 14, 1, 2, CAST(0x7F360B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (51, N'ASHIRWADH M', 4, 2, 1, 9, CAST(0x69240B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (52, N'ASHIRWADH VIJITH G', 1, 14, 1, 3, CAST(0x88350B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (53, N'ASHIRWADH VIJITH G', 2, 12, 2, 3, CAST(0x43270B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (54, N'ASHWIN R', 1, 8, 2, 2, CAST(0x37320B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (55, N'AVINASH', 4, 13, 2, 2, CAST(0x62270B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (56, N'AVINASH A', 1, 11, 1, 8, CAST(0xCD260B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (57, N'AVINASH A', 3, 8, 1, 2, CAST(0xA4330B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (58, N'AYSHWARYA M', 2, 8, 1, 3, CAST(0xAD320B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (59, N'AYSHWARYA M', 4, 6, 1, 3, CAST(0xD6250B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (60, N'BABU SHANKAR YUVAN', 3, 10, 1, 2, CAST(0xCA300B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (61, N'BABU VENKATESH SUNDRU', 1, 1, 2, 2, CAST(0x822C0B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (62, N'BALIK MAASHA', 1, 2, 2, 9, CAST(0x69240B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (63, N'BHARATH T', 4, 4, 1, 11, CAST(0x09380B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (64, N'BHERWANI G CHAITANYA', 1, 14, 1, 4, CAST(0x4D350B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (65, N'BHUVANESWARI REVATHI', 1, 12, 2, 4, CAST(0x09270B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (66, N'BHUVANESWARI REVATHI', 2, 14, 1, 5, CAST(0x82350B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (67, N'BHUVANESWARI REVATHI', 3, 2, 1, 10, CAST(0x2E240B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (68, N'BINDHU J', 4, 2, 1, 11, CAST(0x63240B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (69, N'BRAHADHEESWARAN T T', 1, 8, 1, 4, CAST(0x73320B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (70, N'BRAHADHEESWARAN T T', 4, 7, 1, 1, CAST(0xF5250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (71, N'CATHERINE ALICE A', 2, 3, 1, 2, CAST(0xCD260B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (72, N'CATHERINE ALICE A', 3, 1, 2, 3, CAST(0x8B2B0B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (73, N'CHACHAM VIPANCHI', 3, 13, 2, 3, CAST(0x3D270B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (74, N'CHAKKARAVARTHI M', 3, 14, 1, 6, CAST(0xE0350B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (75, N'CHAKRABORTI SHATARUPA', 1, 11, 1, 9, CAST(0xD6250B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (76, N'CHANDRA GUPTA', 4, 2, 2, 10, CAST(0x2E240B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (77, N'CHARANYA MOHAN P', 3, 2, 1, 12, CAST(0xC1240B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (78, N'CHITHALA REDDY', 3, 4, 1, 12, CAST(0x99380B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (79, N'CHRISTINA S', 1, 6, 1, 4, CAST(0x9C250B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (80, N'DAHRE NONEET', 2, 8, 2, 3, CAST(0x40310B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (81, N'DAMIEN ANTO S', 3, 10, 2, 2, CAST(0x5C2F0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (82, N'DANIEL ABISHEK B', 3, 13, 2, 4, CAST(0x9B270B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (83, N'DANIEL BERRIN Y', 2, 10, 2, 3, CAST(0x652E0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (84, N'DANIEL EBENEZER', 1, 1, 2, 4, CAST(0x512B0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (85, N'DANIEL EBENEZER', 1, 3, 1, 3, CAST(0xD6250B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (86, N'DARUN J', 2, 5, 2, 2, CAST(0x822C0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (87, N'DAVEY M DHRUV', 1, 5, 1, 4, CAST(0xBE2C0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (88, N'DEEKSHA G', 3, 7, 1, 2, CAST(0xCD260B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (89, N'DEEPAK Y', 1, 8, 2, 4, CAST(0x06310B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (90, N'DEEPIKA S', 1, 8, 2, 5, CAST(0x3A310B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (91, N'DEEPIKA S M', 3, 10, 1, 3, CAST(0xD32F0B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (92, N'DESHPANDE ROHAN', 1, 10, 2, 4, CAST(0x2B2E0B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (93, N'DEV SHRIYA', 4, 10, 2, 5, CAST(0x5F2E0B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (94, N'DEV SNEHA', 3, 10, 2, 6, CAST(0xBD2E0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (95, N'DEWAN AAYUSH', 3, 13, 1, 1, CAST(0xCF280B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (96, N'DHANALAKSHMI V', 2, 11, 1, 10, CAST(0x9C250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (97, N'DHANYA S', 2, 11, 1, 11, CAST(0xD0250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (98, N'DINAKARAN G', 4, 2, 2, 11, CAST(0x63240B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (99, N'DINESH', 4, 9, 1, 1, CAST(0xF5250B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (100, N'Dinesh Kumar', 3, 11, 2, 1, CAST(0xF5250B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (101, N'Dinesh Kumar', 4, 11, 2, 16, CAST(0x9C250B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (102, N'DIVYA S', 1, 13, 1, 2, CAST(0xA7290B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (103, N'DIVYALAKSHMI J', 4, 13, 2, 5, CAST(0x62270B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (104, N'DIWAKAR PRANAV', 1, 8, 1, 5, CAST(0xA7320B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (105, N'DIWAKAR PRANAV', 2, 6, 1, 5, CAST(0xD0250B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (106, N'DIWAKAR PRANAV', 4, 8, 2, 6, CAST(0x98310B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (107, N'DOKANIA HARSHITA', 4, 6, 2, 1, CAST(0xF5250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (108, N'DOMNIC B', 4, 6, 1, 6, CAST(0x2E260B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (109, N'DOMNIC B A', 2, 13, 1, 3, CAST(0xB0280B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (110, N'DOSHI A JEENAL', 2, 14, 1, 7, CAST(0xA7350B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (111, N'DOSHI A JEENAL', 4, 13, 1, 4, CAST(0x76280B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (112, N'DOSHI H MITANSHI', 1, 7, 1, 3, CAST(0xD6250B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (113, N'DRAVIDA S', 4, 14, 1, 8, CAST(0x7F360B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (114, N'DRAVIDA S R', 4, 4, 2, 3, CAST(0x14370B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (115, N'DUBEY AKSHITA', 4, 6, 1, 7, CAST(0xF5250B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (116, N'DUBEY ANSHU', 1, 8, 2, 7, CAST(0x5F310B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (117, N'DUGGIRALA SAHAS', 1, 14, 1, 9, CAST(0x88350B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (118, N'DUGGIRALA SAHAS', 3, 12, 2, 5, CAST(0x3D270B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (119, N'DURKA M M', 1, 6, 1, 8, CAST(0xCD260B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (120, N'DUTTA DIPANJAN', 1, 5, 2, 3, CAST(0x8B2B0B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (121, N'DUTTA ROHAN', 2, 7, 1, 4, CAST(0x9C250B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (122, N'DUTTA ROHAN', 2, 12, 2, 6, CAST(0x9B270B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (123, N'DUTTA ROHAN', 4, 14, 1, 10, CAST(0x4D350B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (124, N'EESHA P', 3, 2, 2, 12, CAST(0xC1240B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (125, N'ELAKKIYA A', 1, 7, 1, 5, CAST(0xD0250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (126, N'ELAKKIYA A', 2, 12, 2, 7, CAST(0x62270B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (127, N'ELAKKIYA A', 3, 14, 1, 11, CAST(0x82350B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (128, N'FLORA STEFFY', 3, 10, 1, 4, CAST(0x982F0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (129, N'GANESH PRACHAN', 1, 10, 1, 5, CAST(0xCD2F0B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (130, N'GARAVIND S', 2, 2, 1, 13, CAST(0x88240B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (131, N'GAYATHRI', 2, 3, 2, 1, CAST(0x88240B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (132, N'Gayathri', 4, 11, 2, 2, CAST(0xCD260B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (133, N'Gayathri', 4, 11, 2, 17, CAST(0xA7250B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (134, N'GOKULAKRISHNAN D', 4, 9, 1, 2, CAST(0xCD260B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (135, N'GOLECHA NITESH', 4, 9, 1, 3, CAST(0xD6250B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (136, N'GOPAL GAYATRI', 1, 13, 2, 6, CAST(0x3A280B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (137, N'GOPAL GAYATRI', 3, 9, 1, 4, CAST(0x9C250B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (138, N'GOPINATH S', 2, 13, 1, 5, CAST(0xAA280B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (139, N'GOUTHAM R', 4, 13, 1, 6, CAST(0x08290B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (140, N'GOVIND AKSHAYA', 2, 7, 2, 1, CAST(0xF5250B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (141, N'GOVIND ARUN', 4, 11, 1, 12, CAST(0x2E260B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (142, N'GOWRI R', 2, 9, 1, 5, CAST(0xD0250B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (143, N'GOWRI R', 4, 13, 1, 7, CAST(0xCF280B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (144, N'GOWTHAM S', 3, 10, 2, 7, CAST(0x842E0B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (145, N'GOWTHAMI T', 3, 5, 1, 5, CAST(0xF22C0B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (146, N'GUNASEKARAN RAGHUL', 2, 7, 2, 2, CAST(0xCD260B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (147, N'GUPTA A ARCHIT', 3, 13, 2, 7, CAST(0x43270B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (148, N'GUPTA AAYUSH', 1, 4, 2, 4, CAST(0xEC370B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (149, N'GUPTA AAYUSH', 2, 1, 1, 3, CAST(0x8B2B0B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (150, N'GUPTA PRASHANSHA', 2, 12, 2, 8, CAST(0x3A280B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (151, N'GUPTA PRASHANSHA', 3, 14, 1, 12, CAST(0xE0350B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (152, N'GURU KUMARA PRANAVA', 1, 6, 1, 9, CAST(0xD6250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (153, N'GURU S C', 1, 12, 2, 9, CAST(0x43270B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (154, N'GURU S C', 2, 10, 1, 6, CAST(0x2B300B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (155, N'HAARIKA CHITTOORY', 2, 5, 1, 6, CAST(0x502D0B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (156, N'HAARINI G M', 3, 5, 1, 7, CAST(0x172D0B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (157, N'HAARISH V C', 2, 13, 2, 8, CAST(0x09270B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (158, N'HAJIRA ZAINAB', 3, 7, 1, 6, CAST(0x2E260B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (159, N'HARAN VISHNU K', 3, 13, 2, 9, CAST(0x3D270B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (160, N'HARI S', 2, 13, 2, 10, CAST(0x9B270B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (161, N'HARI T', 2, 6, 1, 1, CAST(0xF5250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (162, N'HARIHARAN R', 1, 5, 1, 8, CAST(0xEF2D0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (163, N'HARIHARAN S', 4, 7, 2, 3, CAST(0xD6250B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (164, N'HARINI', 4, 10, 2, 9, CAST(0x652E0B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (165, N'HARIPRAKASH VALIATHAN ADITYA', 1, 7, 1, 7, CAST(0xF5250B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (166, N'HARIRAM K', 3, 7, 1, 8, CAST(0xCD260B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (167, N'HARISH K', 2, 8, 1, 6, CAST(0x05330B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (168, N'HARISH P', 1, 13, 1, 8, CAST(0xA7290B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (169, N'Harmendra Dharmendra', 2, 13, 2, 11, CAST(0x62270B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (170, N'Harold P', 4, 5, 1, 9, CAST(0xF82C0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (171, N'HAROON A M', 3, 1, 2, 5, CAST(0x852B0B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (172, N'HAROON A M', 3, 3, 1, 4, CAST(0x9C250B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (173, N'HARSHA B M', 1, 3, 1, 5, CAST(0xD0250B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (174, N'HARSHA B M', 3, 1, 2, 6, CAST(0xE32B0B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (175, N'HARSHA B Ms', 4, 9, 1, 6, CAST(0x2E260B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (176, N'HARSHA RUPAK', 2, 13, 1, 9, CAST(0xB0280B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (177, N'HARSHITHA R', 4, 5, 1, 10, CAST(0xBE2C0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (178, N'HEMA', 2, 11, 1, 13, CAST(0xF5250B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (179, N'HEMAGANTH S', 3, 6, 2, 2, CAST(0xCD260B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (180, N'HEMALATHA A', 3, 14, 1, 13, CAST(0xA7350B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (181, N'HEMALATHA A', 4, 12, 2, 10, CAST(0x09270B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (182, N'HEMANTH REDDY', 1, 14, 1, 14, CAST(0x7F360B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (183, N'HEMANTH REDDY', 4, 12, 2, 11, CAST(0x3D270B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (184, N'HEMNATH RA', 2, 6, 1, 10, CAST(0x9C250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (185, N'HEMNATH RA', 4, 7, 1, 9, CAST(0xD6250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (186, N'Henry Jackson', 4, 6, 2, 3, CAST(0xD6250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (187, N'HIMESH W', 2, 6, 1, 11, CAST(0xD0250B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (188, N'HOWARD DAVID', 1, 10, 1, 7, CAST(0xF22F0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (189, N'HOWARD DAVID', 1, 14, 1, 15, CAST(0x88350B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (190, N'HOWARD DAVID', 3, 12, 2, 12, CAST(0x9B270B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (191, N'HUBERT HYACINTH ANGELA', 2, 1, 1, 4, CAST(0x512B0B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (192, N'HUBERT HYACINTH ANGELA', 2, 4, 2, 5, CAST(0xF5360B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (193, N'HUBERT HYACINTH ANGELA', 2, 14, 1, 16, CAST(0x4D350B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (194, N'HUBERT HYACINTH ANGELA', 4, 12, 2, 13, CAST(0x62270B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (195, N'HUSSAIN AMEENUDDIN A', 2, 1, 1, 5, CAST(0x852B0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (196, N'HUSSAIN AMEENUDDIN A', 2, 4, 2, 6, CAST(0xBB360B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (197, N'IBRAHIM MOHAMED', 3, 10, 2, 10, CAST(0x2B2E0B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (198, N'INAMUL', 3, 3, 1, 6, CAST(0x2E260B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (199, N'ISHWAR R', 2, 13, 2, 12, CAST(0x3A280B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (200, N'JAFFERARSHAD D', 3, 5, 2, 4, CAST(0x512B0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (201, N'JANANI D', 1, 9, 1, 7, CAST(0xF5250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (202, N'JANANI MOHANRAJ', 1, 12, 2, 14, CAST(0x3A280B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (203, N'JANE BARRISTON', 4, 12, 2, 15, CAST(0x43270B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (204, N'JAYAKUMAR SHILPA', 1, 9, 1, 8, CAST(0xCD260B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (205, N'JAYAN K G', 2, 13, 2, 13, CAST(0x43270B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (206, N'JAYANTHI T', 4, 5, 2, 5, CAST(0x852B0B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (207, N'JAYARAM SHRINIVAS', 4, 7, 1, 10, CAST(0x9C250B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (208, N'JAYARAMAN HARINI', 1, 8, 1, 7, CAST(0xCC320B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (209, N'JAYARAMAN HARINI', 1, 13, 2, 14, CAST(0x09270B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (210, N'JAYASOORYA S K', 4, 13, 2, 15, CAST(0x14270B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (211, N'JECINTHA V', 1, 13, 2, 16, CAST(0x7A270B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (212, N'JECINTHA V', 4, 8, 1, 8, CAST(0xA4330B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (213, N'JEEVITHA P V', 4, 7, 1, 11, CAST(0xD0250B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (214, N'JEMIMAH ANGELINE S', 2, 7, 2, 4, CAST(0x9C250B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (215, N'JENNY VIJAY', 3, 2, 2, 13, CAST(0x88240B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (216, N'JEYACHANDRAN PRANAV', 1, 1, 1, 6, CAST(0xE32B0B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (217, N'JEYACHANDRAN PRANAV', 2, 4, 2, 7, CAST(0xEF360B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (218, N'JHA SHRESHTHA', 4, 7, 2, 5, CAST(0xD0250B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (219, N'JITANI M SHUBHAM', 2, 5, 1, 11, CAST(0xF22C0B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (220, N'JITANI M SHUBHAM', 4, 8, 1, 9, CAST(0xAD320B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (221, N'JITHIN S C', 1, 8, 1, 10, CAST(0x73320B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (222, N'JOSHI KUMAR LOKESH', 1, 11, 1, 14, CAST(0xCD260B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (223, N'JOSHUA MANUEL J', 4, 6, 2, 4, CAST(0x9C250B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (224, N'JOSHUA MARVIN', 1, 6, 2, 5, CAST(0xD0250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (225, N'JOSHUA NITHIN R', 2, 15, 2, 20, CAST(0x3D2A0B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (226, N'JOY JOSHI', 3, 12, 2, 16, CAST(0x09270B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (227, N'JOY JOSHI', 3, 14, 1, 17, CAST(0x58350B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (228, N'JUHNA R J', 1, 6, 2, 6, CAST(0x2E260B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (229, N'KALA PRIYA', 2, 1, 2, 7, CAST(0xAA2B0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (230, N'KALA PRIYA', 3, 3, 1, 7, CAST(0xF5250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (231, N'KALPANA REJINA', 3, 2, 1, 14, CAST(0x60250B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (232, N'KAMAL', 3, 8, 1, 11, CAST(0xA7320B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (233, N'KAMALA', 4, 4, 1, 13, CAST(0x07380B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (234, N'KAREENA K', 2, 2, 1, 15, CAST(0x69240B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (235, N'KARTHIK NITHIN', 1, 14, 2, 2, CAST(0x11350B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (236, N'KARTHIK NITHIN', 4, 12, 1, 2, CAST(0x3A280B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (237, N'KATHIRESAN M KRITHIKA', 4, 7, 2, 6, CAST(0x2E260B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (238, N'KATYAL DEEPIKA', 3, 11, 1, 2, CAST(0x372A0B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (239, N'KAUR RAAGVEEN', 2, 5, 2, 6, CAST(0xE32B0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (240, N'KAUSHIK S L', 1, 7, 2, 7, CAST(0xF5250B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (241, N'KAVIN S T', 4, 5, 1, 12, CAST(0x502D0B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (242, N'KAVYA S', 3, 13, 1, 10, CAST(0x76280B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (243, N'KESAAV Y', 4, 1, 2, 8, CAST(0x822C0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (244, N'KESAAV Y', 4, 3, 1, 8, CAST(0xCD260B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (245, N'KEVIN K', 3, 7, 2, 8, CAST(0xCD260B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (246, N'KHATRI YUKTI', 3, 15, 2, 19, CAST(0x152B0B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (247, N'KHOUSHIK R M', 1, 7, 1, 12, CAST(0x2E260B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (248, N'Kiran', 2, 11, 2, 3, CAST(0xD6250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (249, N'Kiran', 2, 11, 2, 18, CAST(0x0D260B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (250, N'KIRTHIKA B', 1, 1, 2, 9, CAST(0x8B2B0B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (251, N'KIRTHIKA B', 2, 3, 1, 9, CAST(0xD6250B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (252, N'KIRTHIKAN B', 4, 9, 1, 9, CAST(0xD6250B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (253, N'KIRUBASHANKAR T', 1, 9, 1, 10, CAST(0x9C250B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (254, N'KIRUTHIKA R', 1, 9, 1, 11, CAST(0xD0250B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (255, N'KIRUTHIKA R', 1, 15, 2, 18, CAST(0x1E2A0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (256, N'KISHORE K', 3, 9, 2, 2, CAST(0xCD260B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (257, N'KISHORE S', 3, 7, 2, 9, CAST(0xD6250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (258, N'KOHLI SINGH AMITOJ', 1, 7, 2, 10, CAST(0x9C250B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (259, N'KOKILA S', 1, 5, 2, 7, CAST(0xAA2B0B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (260, N'KOTHARI R CHIRAG', 2, 3, 1, 10, CAST(0x9C250B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (261, N'KOTHARI R CHIRAG', 3, 9, 2, 3, CAST(0xD6250B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (262, N'KOTHARI R CHIRAG', 4, 1, 2, 10, CAST(0x512B0B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (263, N'KOTHARI S DIXITHA', 2, 9, 2, 4, CAST(0x9C250B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (264, N'KR NACHIAPPAN', 1, 9, 2, 5, CAST(0xD0250B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (265, N'KRISHNA ADITYA R', 3, 11, 1, 3, CAST(0x772A0B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (266, N'KRISHNA AJAY M', 3, 10, 1, 8, CAST(0xCA300B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (267, N'KRISHNA SAI SD', 2, 13, 1, 11, CAST(0xAA280B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (268, N'KRISHNA SAI SD', 3, 13, 1, 12, CAST(0x08290B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (269, N'KRISHNA SHREE S', 4, 13, 1, 13, CAST(0xCF280B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (270, N'KRISHNA SRI MAHIKA', 2, 13, 1, 14, CAST(0xA7290B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (271, N'KRISHNA SURESH D', 2, 13, 1, 15, CAST(0xB0280B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (272, N'KRISHNA VAMSI MULA', 1, 13, 1, 16, CAST(0x76280B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (273, N'KRISHNA VAMSI MULA', 4, 8, 2, 8, CAST(0x37320B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (274, N'KRISHNAMURTHY SAISRIVATSA', 3, 7, 2, 11, CAST(0xD0250B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (275, N'KRISHNAN', 1, 1, 1, 7, CAST(0xAA2B0B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (276, N'KRISHNAN', 2, 4, 2, 8, CAST(0x4D370B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (277, N'KRISHNAN ARNAV', 1, 7, 2, 12, CAST(0x2E260B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (278, N'KRISHNAN GAAYATHRI', 2, 6, 1, 12, CAST(0x2E260B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (279, N'KRISHNAN GOKULA M', 3, 6, 2, 7, CAST(0xF5250B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (280, N'KRISHNAN K VIGNESH', 4, 14, 1, 18, CAST(0xBF350B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (281, N'KRISHNAN MEGHANA', 3, 15, 2, 17, CAST(0xE3290B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (282, N'KRISHNAN S', 1, 12, 1, 3, CAST(0x43270B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (283, N'KRISHNAN S', 2, 14, 2, 3, CAST(0x1A340B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (284, N'KRISHNAN S', 4, 10, 1, 9, CAST(0xD32F0B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (285, N'KRISHNAN VENKATA SAI', 3, 6, 2, 8, CAST(0xCD260B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (286, N'KRISHNAN VENKATA SAI', 3, 10, 1, 10, CAST(0x982F0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (287, N'KRISHNARAJ MEENAKSHI', 2, 13, 2, 17, CAST(0x67270B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (288, N'KRITHIKA S', 2, 7, 1, 13, CAST(0xF5250B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (289, N'KRITHIKA S', 2, 8, 1, 12, CAST(0x05330B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (290, N'KURUSHI MEHTA', 3, 2, 2, 14, CAST(0x60250B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (291, N'LAAVANYA', 4, 7, 1, 14, CAST(0xCD260B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (292, N'Laavanya R', 3, 15, 2, 16, CAST(0x182A0B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (293, N'LAGAAN', 2, 10, 2, 11, CAST(0x5F2E0B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (294, N'LAKSHAYA PATEL', 3, 8, 1, 13, CAST(0xCC320B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (295, N'Lakshmi Narayanan', 2, 11, 2, 4, CAST(0x9C250B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (296, N'Lakshmi Narayanan', 3, 11, 2, 19, CAST(0xFA250B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (297, N'LALITHA', 3, 8, 1, 14, CAST(0xA4330B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (298, N'Lalitha Kumar', 1, 7, 2, 13, CAST(0xF5250B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (299, N'Lathika S', 3, 7, 1, 15, CAST(0xD6250B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (300, N'LAVANYA N', 3, 2, 1, 16, CAST(0x2E240B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (301, N'LAVANYASHETTY', 2, 11, 1, 4, CAST(0x542A0B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (302, N'LAVYA MEGHANA', 3, 14, 2, 4, CAST(0xE0330B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (303, N'Laxman Reddy', 1, 7, 1, 16, CAST(0x9C250B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (304, N'LAXMIKANTH E', 2, 11, 1, 5, CAST(0x1D2A0B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (305, N'LEANDER JORAH', 1, 10, 1, 11, CAST(0xCD2F0B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (306, N'LEELA', 1, 10, 2, 12, CAST(0xBD2E0B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (307, N'LEELA KRISHNAN', 4, 4, 2, 9, CAST(0x14370B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (308, N'Leelakrishna', 4, 1, 1, 8, CAST(0x822C0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (309, N'LILLE S', 4, 7, 2, 14, CAST(0xCD260B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (310, N'LISHRAM SINGH', 2, 4, 2, 10, CAST(0xEC370B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (311, N'Lishram Singh', 3, 1, 1, 9, CAST(0x8B2B0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (312, N'Lishram Singh', 4, 13, 1, 17, CAST(0x81280B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (313, N'LIVINGSTON R', 1, 3, 1, 11, CAST(0xD0250B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (314, N'Livingston R', 1, 13, 1, 18, CAST(0xE7280B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (315, N'Livingston R', 1, 15, 2, 15, CAST(0x762A0B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (316, N'LIVINGSTON R', 4, 1, 2, 11, CAST(0x852B0B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (317, N'LOGANATHAN', 3, 4, 2, 11, CAST(0xF5360B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (318, N'Loganathan R', 1, 1, 1, 10, CAST(0x512B0B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (319, N'Loganathan R', 1, 13, 1, 19, CAST(0xD4280B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (320, N'Loganathan R', 4, 6, 1, 13, CAST(0xF5250B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (321, N'Lokesh R', 3, 13, 1, 20, CAST(0x9B280B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (322, N'LOKESH S', 4, 6, 2, 9, CAST(0xD6250B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (323, N'LOKPRAKASH', 4, 4, 2, 12, CAST(0xBB360B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (324, N'Lokprakash A', 2, 1, 1, 11, CAST(0x852B0B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (325, N'Lousie Paul', 4, 15, 2, 14, CAST(0x3D2A0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (326, N'MAANASA', 2, 6, 1, 14, CAST(0xCD260B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (327, N'MADDY SAMI', 1, 1, 1, 12, CAST(0xE32B0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (328, N'MADDY SAMI', 1, 4, 2, 13, CAST(0xEF360B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (329, N'MADHAV TUNTA', 2, 15, 2, 13, CAST(0x152B0B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (330, N'MAHADHREERAN K', 1, 10, 1, 12, CAST(0x2B300B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (331, N'MAHALAKSHMI', 4, 15, 2, 12, CAST(0x1E2A0B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (332, N'MAHIKA', 3, 13, 2, 18, CAST(0x3A280B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (333, N'Mahima', 1, 11, 2, 5, CAST(0xD0250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (334, N'Mahima', 1, 11, 2, 20, CAST(0xC1250B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (335, N'MALINI S', 2, 2, 1, 17, CAST(0x39240B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (336, N'MALVIKA T', 3, 5, 2, 8, CAST(0x822C0B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (337, N'MANALI KHANNA', 2, 8, 1, 15, CAST(0xAD320B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (338, N'MANANA J', 1, 3, 1, 12, CAST(0x2E260B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (339, N'MANANA J', 3, 1, 2, 12, CAST(0xE32B0B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (340, N'MANVIK DESAI', 1, 2, 2, 15, CAST(0x69240B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (341, N'MEENAKSHI', 4, 6, 1, 15, CAST(0xD6250B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (342, N'MEGHANA', 3, 12, 1, 4, CAST(0x09270B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (343, N'MENON R DEEPAK', 4, 8, 2, 9, CAST(0x40310B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (344, N'MERHABA M', 2, 7, 2, 15, CAST(0xD6250B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (345, N'MERHABA MOHAMMED', 4, 9, 1, 12, CAST(0x2E260B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (346, N'Michael', 1, 11, 2, 6, CAST(0x2E260B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (347, N'MISSER O NITISHA', 1, 9, 1, 13, CAST(0xF5250B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (348, N'MISSER O NITISHA', 3, 15, 2, 11, CAST(0xE3290B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (349, N'MISTRY BABITA', 3, 9, 1, 14, CAST(0xCD260B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (350, N'MITANSHI', 1, 14, 1, 19, CAST(0xAC350B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (351, N'MITHRA', 3, 9, 1, 15, CAST(0xD6250B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (352, N'MODI B ANKITHA', 1, 11, 1, 6, CAST(0xF42A0B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (353, N'MOHAMMED', 2, 2, 1, 3, CAST(0x69240B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (354, N'MOHANTY ROHAN', 2, 1, 1, 13, CAST(0xAA2B0B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (355, N'MOHANTY ROHAN', 2, 5, 1, 13, CAST(0x172D0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (356, N'MOHANTY ROHAN', 4, 4, 2, 14, CAST(0x4D370B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (357, N'MOHD HASSAN INAMUL', 1, 1, 2, 13, CAST(0xAA2B0B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (358, N'MOHD HUSSAIN IZHARUL', 1, 3, 1, 13, CAST(0xF5250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (359, N'MOHD HUSSAIN IZHARUL', 3, 1, 2, 14, CAST(0x822C0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (360, N'MOHITH G', 2, 1, 1, 14, CAST(0x822C0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (361, N'MOHITH G', 2, 4, 2, 15, CAST(0x14370B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (362, N'MOHUN GAUTHAM', 2, 3, 1, 14, CAST(0xCD260B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (363, N'MOHUN GAUTHAM', 3, 1, 1, 15, CAST(0x8B2B0B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (364, N'MOHUN GAUTHAM', 3, 1, 2, 15, CAST(0x8B2B0B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (365, N'MOHUN GAUTHAM', 4, 4, 2, 16, CAST(0xEC370B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (366, N'MONALISA', 3, 1, 2, 16, CAST(0x512B0B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (367, N'MONALISA', 4, 3, 1, 15, CAST(0xD6250B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (368, N'MONICA CHRISTINA JULIET', 2, 4, 2, 17, CAST(0xF5360B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (369, N'MONICA CHRISTINA JULIET', 4, 1, 1, 16, CAST(0x512B0B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (370, N'MONICA K', 1, 4, 2, 18, CAST(0xBB360B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (371, N'MONICA K', 4, 1, 1, 17, CAST(0x5C2B0B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (372, N'MONICA P', 1, 4, 1, 14, CAST(0x99380B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (373, N'MONIKA D', 1, 15, 1, 1, CAST(0x3D2A0B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (374, N'MONISH D N', 4, 5, 2, 9, CAST(0x8B2B0B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (375, N'MONISHA R', 1, 15, 1, 2, CAST(0x152B0B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (376, N'MONISHA S', 2, 1, 1, 18, CAST(0xC22B0B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (377, N'MONISHA S', 4, 4, 2, 19, CAST(0xC6360B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (378, N'MONITHA R', 2, 11, 1, 7, CAST(0xBD290B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (379, N'MOORTHY S RAGHAV', 2, 4, 2, 20, CAST(0x2C370B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (380, N'MOORTHY S RAGHAV', 4, 1, 1, 19, CAST(0xAF2B0B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (381, N'MORGAN JP', 4, 2, 2, 16, CAST(0x2E240B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (382, N'MRUDULA T', 3, 6, 2, 10, CAST(0x9C250B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (383, N'MUHAMMED THABREZ', 3, 6, 2, 11, CAST(0xD0250B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (384, N'MUKESH A', 1, 3, 1, 16, CAST(0x9C250B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (385, N'MUKESH A', 4, 1, 2, 17, CAST(0x5C2B0B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (386, N'MUKUND MANASVINI', 4, 1, 2, 18, CAST(0xC22B0B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (387, N'MUKUND MANASVINI', 4, 3, 1, 17, CAST(0xA7250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (388, N'MUKUNDAN BHARGAVEE', 1, 6, 2, 12, CAST(0x2E260B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (389, N'MUNAGALA AUROBINDO SRI', 1, 8, 2, 10, CAST(0x06310B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (390, N'MURALIDHARAN SRINIVAS', 4, 15, 2, 10, CAST(0x182A0B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (391, N'MURUGANANDAM VARUN', 4, 6, 2, 13, CAST(0xF5250B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (392, N'MUTHU GKEVIN M', 2, 15, 2, 9, CAST(0x762A0B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (393, N'MUTHUKUMAR VISHALINI', 4, 6, 1, 16, CAST(0x9C250B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (394, N'MUTHULAKSHMI SP', 1, 6, 1, 17, CAST(0xA7250B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (395, N'MYTHILY A', 2, 10, 1, 13, CAST(0xF22F0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (396, N'N ADITYA AJIT', 3, 8, 1, 16, CAST(0x73320B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (397, N'N NAVEEN', 4, 8, 1, 17, CAST(0x7E320B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (398, N'N S KAYALVIZHI', 1, 8, 1, 18, CAST(0xE4320B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (399, N'NACHAL', 4, 9, 1, 16, CAST(0x9C250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (400, N'NADESAN SHIVANI', 2, 9, 1, 17, CAST(0xA7250B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (401, N'NAG PROBAL', 2, 9, 2, 6, CAST(0x2E260B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (402, N'NAGARAJ NAMRATA', 1, 10, 2, 13, CAST(0x842E0B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (403, N'NAIR ADARSH', 4, 11, 1, 8, CAST(0x372A0B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (404, N'NAIR ADITYA', 1, 4, 1, 15, CAST(0x3D380B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (405, N'NAJDORF NEBUTT K', 3, 5, 2, 10, CAST(0x512B0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (406, N'NALAVANYA', 2, 15, 2, 8, CAST(0x3D2A0B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (407, N'NAMBILLI VARUN', 1, 13, 1, 21, CAST(0x76280B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (408, N'NANDHINI P', 4, 7, 1, 17, CAST(0xA7250B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (409, N'NARAJ AMOGH', 3, 11, 1, 9, CAST(0x772A0B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (410, N'NARCHANA B', 3, 2, 1, 18, CAST(0xA0240B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (411, N'NARENRAJU', 1, 5, 2, 11, CAST(0x852B0B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (412, N'NATHISHA', 3, 1, 2, 19, CAST(0xAF2B0B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (413, N'NATHISHA', 3, 3, 1, 18, CAST(0x0D260B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (414, N'NAUTHAM', 3, 4, 1, 16, CAST(0x03380B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (415, N'NEHA RAJAN K', 4, 2, 2, 17, CAST(0x39240B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (416, N'NIKESH SUDHAARSHAN', 1, 15, 2, 7, CAST(0x152B0B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (417, N'NIKHIL', 3, 10, 1, 20, CAST(0xBE2F0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (418, N'NIKHIL GAEKWAD G', 1, 2, 1, 19, CAST(0x8D240B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (419, N'NILOOM KALYAN', 4, 10, 1, 14, CAST(0xCA300B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (420, N'NIRANJAN N', 1, 2, 2, 18, CAST(0xA0240B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (421, N'NIRBHAV', 1, 10, 1, 15, CAST(0xD32F0B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (422, N'NIVETHA B', 4, 5, 1, 14, CAST(0xEF2D0B00 AS Date), N'O+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (423, N'NIVETHA S T', 4, 15, 1, 3, CAST(0x1E2A0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (424, N'NIVETHITHA A', 4, 5, 1, 15, CAST(0xF82C0B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (425, N'NIVETHITHA S', 3, 6, 1, 18, CAST(0x0D260B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (426, N'NIVHASINI V', 3, 6, 2, 14, CAST(0xCD260B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (427, N'NIVIGNESH', 4, 6, 1, 19, CAST(0xFA250B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (428, N'NIZAR SENU', 4, 6, 2, 15, CAST(0xD6250B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (429, N'NOMIKA GAYATHRI', 1, 12, 1, 5, CAST(0x3D270B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (430, N'NOMIKA GAYATHRI', 2, 14, 2, 5, CAST(0x14340B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (431, N'NOMIKA GAYATHRI', 3, 11, 1, 10, CAST(0x542A0B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (432, N'NOMISHWAR', 1, 5, 2, 12, CAST(0xE32B0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (433, N'NUMAR DINESH', 2, 10, 2, 14, CAST(0x5C2F0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (434, N'NURUSHOTHAMAN', 3, 6, 2, 16, CAST(0x9C250B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (435, N'NURUSHOTHAMAN', 3, 10, 2, 15, CAST(0x652E0B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (436, N'OLIVER', 4, 10, 2, 16, CAST(0x2B2E0B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (437, N'PAARKAVI D', 3, 9, 1, 18, CAST(0x0D260B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (438, N'PAARKAVI D', 4, 15, 2, 6, CAST(0x1E2A0B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (439, N'PHANI KUMAR', 4, 12, 2, 17, CAST(0x14270B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (440, N'POOJA', 1, 8, 1, 19, CAST(0xD1320B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (441, N'PORVI FOMRA', 2, 12, 2, 18, CAST(0x7A270B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (442, N'PRAFUL B', 4, 2, 2, 19, CAST(0x8D240B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (443, N'PRAJIT E', 2, 9, 2, 7, CAST(0xF5250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (444, N'PRAKASH ADITI', 4, 9, 2, 8, CAST(0xCD260B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (445, N'PRAKASH SAUMYA', 1, 15, 1, 4, CAST(0xE3290B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (446, N'PRANAV STEVE P', 2, 9, 1, 19, CAST(0xFA250B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (447, N'PRASAD AJAY', 1, 10, 1, 16, CAST(0x982F0B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (448, N'PRASAD VISHNU G', 2, 15, 1, 5, CAST(0x182A0B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (449, N'PRASANA R T', 4, 15, 1, 6, CAST(0x762A0B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (450, N'PRASANTH PITHANISETTY', 3, 8, 1, 20, CAST(0x98320B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (451, N'PRASATH HARI M', 4, 8, 2, 11, CAST(0x3A310B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (452, N'PRAVEEN T', 2, 11, 1, 11, CAST(0x1D2A0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (453, N'PREMAN SRUTHI SRI', 4, 4, 1, 17, CAST(0x44380B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (454, N'PREMAN SRUTHI SRI', 4, 15, 1, 7, CAST(0x3D2A0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (455, N'PRIADARSHNI A', 4, 4, 1, 18, CAST(0x65380B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (456, N'PRITHVI SAI R', 3, 4, 1, 19, CAST(0x43380B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (457, N'PRIYA HARI B', 2, 4, 1, 20, CAST(0x03380B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (458, N'PRIYA MOHANA K', 4, 6, 2, 17, CAST(0xA7250B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (459, N'PRIYA S', 4, 10, 1, 17, CAST(0xA32F0B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (460, N'PRIYA SHANMUGA A', 1, 14, 2, 6, CAST(0x72340B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (461, N'PRIYA SHANMUGA A', 3, 12, 1, 6, CAST(0x9B270B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (462, N'PRIYA SHANMUGA A', 4, 3, 2, 2, CAST(0x60250B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (463, N'PRIYA SHREE R', 3, 11, 1, 12, CAST(0xF42A0B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (464, N'PRIYADARSHINI M', 3, 6, 2, 18, CAST(0x0D260B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (465, N'PRIYADHARSINI N', 1, 6, 1, 20, CAST(0xC1250B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (466, N'PRIYANKA B', 1, 3, 2, 3, CAST(0x69240B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (467, N'PRIYANKA B', 3, 12, 1, 7, CAST(0x62270B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (468, N'PRIYANKA B', 3, 14, 2, 7, CAST(0x39340B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (469, N'PULIKOT ACHUTH', 2, 6, 2, 19, CAST(0xFA250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (470, N'PULIKOT ACHUTH', 3, 15, 2, 5, CAST(0xE3290B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (471, N'PURKAIT T SUNITHA', 3, 3, 2, 4, CAST(0x2E240B00 AS Date), N'A2B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (472, N'PURKAIT T SUNITHA', 3, 14, 2, 8, CAST(0x11350B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (473, N'PURKAIT T SUNITHA', 4, 12, 1, 8, CAST(0x3A280B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (474, N'PUROHIT RAJ DASHRATH', 4, 15, 2, 4, CAST(0xEE290B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (475, N'PUSHPANATHAN NIRANJAN', 2, 15, 2, 3, CAST(0x552A0B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (476, N'RAAGHAV R R', 2, 9, 1, 20, CAST(0xC1250B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (477, N'RAAGHAV R R', 2, 9, 2, 20, CAST(0xC1250B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (478, N'RAAJAN AADITHIYA G', 1, 9, 2, 9, CAST(0xD6250B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (479, N'RAAJAN AADITHIYA G', 1, 10, 2, 17, CAST(0x362E0B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (480, N'RAAM VINODH M', 2, 9, 2, 10, CAST(0x9C250B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (481, N'RAAMMOHAN VIGNESH', 4, 15, 2, 2, CAST(0x422A0B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (482, N'RAGHAV', 1, 13, 2, 19, CAST(0x43270B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (483, N'RAGHURAM S', 3, 9, 2, 11, CAST(0xD0250B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (484, N'RANGANATHAN MANASSA', 1, 10, 2, 18, CAST(0x9C2E0B00 AS Date), N'A1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (485, N'RANJAN K MANI', 2, 15, 2, 1, CAST(0x092A0B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (486, N'RANJIT', 3, 1, 2, 20, CAST(0x762B0B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (487, N'RANJIT', 3, 3, 1, 19, CAST(0xFA250B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (488, N'RANKA N AKSHAY', 1, 5, 1, 16, CAST(0xBE2C0B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (489, N'RASHITHA DEVARAPALLI', 3, 11, 1, 13, CAST(0xBD290B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (490, N'RASIKA A', 3, 5, 2, 13, CAST(0xAA2B0B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (491, N'RATHNAM S ADITYA', 4, 11, 1, 14, CAST(0x372A0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (492, N'RAVI R', 3, 1, 1, 2, CAST(0x822C0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (493, N'RAVIGANESH SUBHEEKSHA', 1, 10, 1, 18, CAST(0x0A300B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (494, N'RAVIKIRAN S B', 1, 10, 2, 19, CAST(0x892E0B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (495, N'REDDY HIMAJA P', 4, 15, 1, 8, CAST(0x152B0B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (496, N'REDDY KARAN CHANDRA', 2, 11, 1, 15, CAST(0x772A0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (497, N'REENA MEHTA E', 4, 7, 1, 18, CAST(0x0D260B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (498, N'REETA JOSHI', 3, 5, 1, 17, CAST(0xC92C0B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (499, N'REGIS SUNIL MARK', 2, 15, 1, 9, CAST(0x1E2A0B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (500, N'REHMAN', 1, 10, 2, 8, CAST(0x5C2F0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (501, N'REKHASRI R', 4, 11, 1, 16, CAST(0x542A0B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (502, N'RENGARAJ NANDHINI', 2, 8, 2, 12, CAST(0x98310B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (503, N'RENITA P', 1, 5, 2, 14, CAST(0x822C0B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (504, N'RESHMA', 2, 8, 2, 13, CAST(0x5F310B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (505, N'REVANTH REDDY', 4, 14, 1, 20, CAST(0x73350B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (506, N'REVATHI', 1, 7, 2, 16, CAST(0x9C250B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (507, N'REVATHI', 3, 11, 1, 16, CAST(0x9C250B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (508, N'REVATHY N', 2, 5, 2, 15, CAST(0x8B2B0B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (509, N'RINI ASHA R', 3, 5, 1, 18, CAST(0x2F2D0B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (510, N'RISHOB P', 1, 12, 1, 9, CAST(0x43270B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (511, N'RISHOB P', 1, 14, 2, 9, CAST(0x1A340B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (512, N'RISHOB P', 4, 3, 2, 5, CAST(0x63240B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (513, N'RITHICKA S', 3, 5, 2, 1, CAST(0xAA2B0B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (514, N'RIYA OVIYA I', 1, 7, 1, 19, CAST(0xFA250B00 AS Date), N'AB2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (515, N'RM PRIYA CHELLA', 1, 12, 1, 10, CAST(0x09270B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (516, N'RM PRIYA CHELLA', 2, 3, 2, 6, CAST(0xC1240B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (517, N'RM PRIYA CHELLA', 4, 11, 1, 17, CAST(0x1D2A0B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (518, N'RM PRIYA CHELLA', 4, 14, 2, 10, CAST(0xE0330B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (519, N'ROHIT R', 1, 6, 2, 20, CAST(0xC1250B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (520, N'ROONWAL S MUKUND', 1, 12, 1, 11, CAST(0x3D270B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (521, N'ROONWAL S MUKUND', 1, 14, 2, 11, CAST(0x14340B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (522, N'ROONWAL S MUKUND', 2, 3, 2, 7, CAST(0x88240B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (523, N'ROSE R', 3, 3, 2, 8, CAST(0x60250B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (524, N'ROSE R JENIFER', 1, 14, 2, 12, CAST(0x72340B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (525, N'ROSE R JENIFER', 4, 12, 1, 12, CAST(0x9B270B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (526, N'ROSHAN SUHIL M', 4, 3, 2, 9, CAST(0x69240B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (527, N'ROSHAN SUHIL M', 4, 10, 1, 19, CAST(0xF72F0B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (528, N'ROSHAN SUHIL M', 4, 12, 1, 13, CAST(0x62270B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (529, N'ROSHAN SUHIL M', 4, 14, 2, 13, CAST(0x39340B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (530, N'ROSHINI ANUSHA A', 1, 15, 1, 10, CAST(0xE3290B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (531, N'ROSHNI VELLAISAMY', 2, 3, 2, 10, CAST(0x2E240B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (532, N'ROSHNI VELLAISAMY', 3, 14, 2, 14, CAST(0x11350B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (533, N'ROSHNI VELLAISAMY', 4, 5, 1, 19, CAST(0x1C2D0B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (534, N'ROSHNI VELLAISAMY', 4, 12, 1, 14, CAST(0x3A280B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (535, N'RUPESH C M', 2, 14, 2, 15, CAST(0x1A340B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (536, N'RUPESH C M', 3, 3, 2, 11, CAST(0x63240B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (537, N'RUPESH C M', 4, 12, 1, 15, CAST(0x43270B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (538, N'RUSHA MADHU C', 1, 15, 1, 11, CAST(0x182A0B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (539, N'RUSTAGI PRATHAM', 4, 8, 2, 14, CAST(0x37320B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (540, N'SAANA KHAN', 1, 7, 2, 17, CAST(0xA7250B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (541, N'SAANA KHAN', 1, 11, 1, 17, CAST(0xA7250B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (542, N'SAKTHI A', 2, 9, 2, 12, CAST(0x2E260B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (543, N'SANA', 2, 14, 2, 16, CAST(0xE0330B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (544, N'SANJANA', 3, 12, 1, 16, CAST(0x09270B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (545, N'SANYA', 2, 3, 2, 12, CAST(0xC1240B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (546, N'Shadiya', 1, 11, 2, 7, CAST(0xF5250B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (547, N'Shakila', 4, 11, 2, 8, CAST(0xCD260B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (548, N'Sharmila', 3, 11, 2, 9, CAST(0xD6250B00 AS Date), N'A1B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (549, N'SHRIKANTH SUSHMITHA', 2, 5, 1, 20, CAST(0xE32C0B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (550, N'SHRIRAAM ABHINAVA', 2, 11, 1, 18, CAST(0xF42A0B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (551, N'SIVARAM J', 4, 15, 1, 12, CAST(0x762A0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (552, N'SIVASANKARI R', 1, 15, 1, 13, CAST(0x3D2A0B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (553, N'Smitha', 4, 11, 2, 10, CAST(0x9C250B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (554, N'SOMASUNDARAM KARTHIK T', 1, 11, 1, 19, CAST(0xFB290B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (555, N'SOWMYA S', 4, 9, 2, 13, CAST(0xF5250B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (556, N'SOWMYA V', 3, 9, 2, 14, CAST(0xCD260B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (557, N'SPATIKA K', 2, 9, 2, 15, CAST(0xD6250B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (558, N'SPOORTHI', 3, 9, 2, 16, CAST(0x9C250B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (559, N'SRAVANI KUDALA', 3, 9, 2, 17, CAST(0xA7250B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (560, N'SREEKAR S', 1, 5, 2, 16, CAST(0x512B0B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (561, N'SREEKAR S', 3, 9, 2, 18, CAST(0x0D260B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (562, N'SREERAM S S', 1, 10, 2, 20, CAST(0x502E0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (563, N'SREYAS P', 3, 15, 1, 14, CAST(0x152B0B00 AS Date), N'A2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (564, N'Sri Ram', 1, 11, 2, 11, CAST(0xD0250B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (565, N'SRIDHAR SANJANA', 4, 8, 2, 15, CAST(0x40310B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (566, N'SRIDHAR SHRUTHI', 2, 15, 1, 15, CAST(0x1E2A0B00 AS Date), N'AB-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (567, N'SRIDHAR SREEKRISHNA', 3, 8, 2, 16, CAST(0x06310B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (568, N'SRIKANTH DIVYA', 3, 8, 2, 17, CAST(0x11310B00 AS Date), N'A1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (569, N'SRIKRISHNAA D', 2, 5, 2, 17, CAST(0x5C2B0B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (570, N'SRIMATHI S N', 3, 5, 2, 18, CAST(0xC22B0B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (571, N'SRINATH M T', 1, 15, 1, 16, CAST(0xE3290B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (572, N'SRINIVAS AKELLA', 3, 11, 1, 20, CAST(0xFC290B00 AS Date), N'B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (573, N'STEFFI B', 1, 5, 2, 19, CAST(0xAF2B0B00 AS Date), N'AB-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (574, N'SUBRAMANIAN V', 1, 8, 2, 18, CAST(0x77310B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (575, N'SUBRAMANIYAM SHRUTI', 1, 5, 2, 20, CAST(0x762B0B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (576, N'SUDARSANAM SUBASHREE', 3, 15, 1, 17, CAST(0xEE290B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (577, N'SUJIN M', 2, 12, 1, 17, CAST(0x14270B00 AS Date), N'A1B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (578, N'SUJIN STUART M', 1, 14, 2, 17, CAST(0xEB330B00 AS Date), N'A1B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (579, N'SUJIN STUART M', 4, 3, 2, 13, CAST(0x88240B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (580, N'SUKHADIA Z DHYANESH', 3, 12, 1, 18, CAST(0x7A270B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (581, N'SUKHADIA Z DHYANESH', 3, 14, 2, 18, CAST(0x51340B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (582, N'SUKHADIA Z DHYANESH', 4, 3, 2, 14, CAST(0x60250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (583, N'Sundar Ganesh', 3, 12, 2, 19, CAST(0x67270B00 AS Date), N'B2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (584, N'SUNDAR JEYNTH', 2, 12, 1, 19, CAST(0x67270B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (585, N'SUNDAR JEYNTH', 4, 3, 2, 15, CAST(0x69240B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (586, N'SUNDAR JEYNTH', 4, 14, 2, 19, CAST(0x3E340B00 AS Date), N'A-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (587, N'SURES VISHNU', 1, 15, 1, 18, CAST(0x552A0B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (588, N'SURESH', 1, 11, 1, 15, CAST(0xD6250B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (589, N'SURESH D', 4, 13, 2, 20, CAST(0x2E270B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (590, N'SUSENDARAN S', 1, 12, 1, 20, CAST(0x2E270B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (591, N'SUSENDARAN S', 3, 3, 2, 16, CAST(0x2E240B00 AS Date), N'B1-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (592, N'SUSHMITHA M', 2, 1, 1, 20, CAST(0x762B0B00 AS Date), N'A-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (593, N'SUSHMITHA M', 3, 7, 1, 20, CAST(0xC1250B00 AS Date), N'B2+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (594, N'SUSHMITHA M', 4, 3, 1, 20, CAST(0xC1250B00 AS Date), N'A2-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (595, N'SWEETY CAROLINE N', 2, 8, 2, 19, CAST(0x64310B00 AS Date), N'A2B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (596, N'SWETHA S T', 3, 3, 2, 17, CAST(0x39240B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (597, N'TANUSHREE R', 4, 15, 1, 19, CAST(0x422A0B00 AS Date), N'AB+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (598, N'THASEEM MOHAMMED E', 2, 15, 1, 20, CAST(0x092A0B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (599, N'TYAGI ARJUN', 2, 3, 2, 18, CAST(0xA0240B00 AS Date), N'A2-', N'male', NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (600, N'UCHIT', 1, 4, 1, 1, CAST(0x3D380B00 AS Date), N'A+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (601, N'Uma', 3, 11, 2, 12, CAST(0x2E260B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (602, N'USHA PECHETTI', 3, 3, 2, 19, CAST(0x8D240B00 AS Date), N'A1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (603, N'VAIDHYA S', 4, 8, 2, 20, CAST(0x2B310B00 AS Date), N'A1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (604, N'VALARMATHI', 3, 11, 1, 18, CAST(0x0D260B00 AS Date), N'AB1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (605, N'VALARMATHI', 4, 7, 2, 18, CAST(0x0D260B00 AS Date), N'O-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (606, N'VARSHA RAJA', 4, 12, 2, 20, CAST(0x2E270B00 AS Date), N'A1B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (607, N'VIDHI BISANI', 4, 2, 2, 20, CAST(0x54240B00 AS Date), N'B+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (608, N'VIJITH G', 1, 2, 1, 1, CAST(0x88240B00 AS Date), N'B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (609, N'VIKRAM KUMAR', 1, 7, 2, 19, CAST(0xFA250B00 AS Date), N'AB1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (610, N'VIKRAM KUMAR', 3, 11, 1, 19, CAST(0xFA250B00 AS Date), N'AB2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (611, N'Vinothini', 4, 11, 2, 13, CAST(0xF5250B00 AS Date), N'A+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (612, N'VISHALI K', 1, 3, 2, 20, CAST(0x54240B00 AS Date), N'B1+', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (613, N'YAMINI', 4, 6, 1, 2, CAST(0xCD260B00 AS Date), N'B-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (614, N'YAMINI', 4, 8, 2, 1, CAST(0x5F310B00 AS Date), N'B1-', N'female', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (615, N'Yuvan', 2, 11, 2, 14, CAST(0xCD260B00 AS Date), N'O-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (616, N'Yuvaraj', 4, 11, 2, 15, CAST(0xD6250B00 AS Date), N'O+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (617, N'ZACHARIAH H', 1, 11, 1, 20, CAST(0xC1250B00 AS Date), N'A2+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (618, N'ZACHARIAH H', 4, 7, 2, 20, CAST(0xC1250B00 AS Date), N'A2B-', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (619, N'ZEENATH', 2, 9, 2, 19, CAST(0xFA250B00 AS Date), N'B1+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (620, N'ZUBBIN KALI', 1, 2, 1, 20, CAST(0x54240B00 AS Date), N'A2B+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (621, N'ZUBBIN MADHAN', 4, 14, 2, 20, CAST(0x05340B00 AS Date), N'AB+', N'male', NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[tbl_student] ([Id], [Name], [School_Id], [Standard_Id], [Section_Id], [Roll_No], [DOB], [Blood_Group], [Gender], [Status], [Created_on], [Created_by], [Updated_on], [Updated_by]) VALUES (633, N'Deepika', 1, 6, 2, 4, CAST(0x22380B00 AS Date), N'B+', N'female', 1, CAST(0x0000A75A01229A24 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tbl_student] OFF
USE [master]
GO
ALTER DATABASE [StudentManagementDB] SET  READ_WRITE 
GO
