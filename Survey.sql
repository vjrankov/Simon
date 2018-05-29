USE [SurveyDB]
GO
/****** Object:  Table [dbo].[Phi_ResponseAnswer]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_ResponseAnswer](
	[ResponseAnswerID] [int] IDENTITY(1,1) NOT NULL,
	[ResponseID] [int] NOT NULL,
	[QuestionID] [int] NOT NULL,
	[SelectedAnswer] [int] NOT NULL,
	[AnswerText] [nvarchar](max) NULL,
 CONSTRAINT [PK_Phi_ResponseAnswer] PRIMARY KEY CLUSTERED 
(
	[ResponseAnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phi_Survey]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_Survey](
	[SurveyID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](254) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Version] [float] NULL,
	[ValidFrom] [date] NULL,
	[ValidTo] [date] NULL,
 CONSTRAINT [PK_Phi_Survey] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phi_SurveyPossibleAnswer]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_SurveyPossibleAnswer](
	[AnswerID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionID] [int] NOT NULL,
	[SeqNo] [int] NOT NULL,
	[AnswerText] [nvarchar](max) NOT NULL,
	[AnswerLetter] [char](1) NULL,
 CONSTRAINT [PK_Phi_SurveyAnswer] PRIMARY KEY CLUSTERED 
(
	[AnswerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phi_SurveyQuestion]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_SurveyQuestion](
	[QuestionID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyID] [int] NOT NULL,
	[SubjectID] [int] NULL,
	[SeqNo] [int] NOT NULL,
	[QuestionText] [nvarchar](max) NOT NULL,
	[AnswerType] [varchar](16) NOT NULL,
 CONSTRAINT [PK_Phi_SurveyQuestion] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phi_SurveyResponse]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_SurveyResponse](
	[ResponseID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyID] [int] NOT NULL,
	[FullName] [nvarchar](254) NOT NULL,
	[Title] [nvarchar](254) NULL,
	[Company] [nvarchar](254) NULL,
	[Street] [nvarchar](254) NULL,
	[City] [nvarchar](254) NULL,
	[State] [char](2) NULL,
	[ZIp] [nchar](10) NULL,
	[Email] [nvarchar](254) NULL,
	[Phone] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NOT NULL,
	[Completed] [bit] NOT NULL,
 CONSTRAINT [PK_Phi_SurveyResponse] PRIMARY KEY CLUSTERED 
(
	[ResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Phi_SurveySubject]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Phi_SurveySubject](
	[SubjectID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyID] [int] NOT NULL,
	[SeqNo] [int] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Phi_SurveySubject] PRIMARY KEY CLUSTERED 
(
	[SubjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[GetSurveyList]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyList] 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Today DATE
	SET @Today = GETDATE();
	SELECT SurveyID, Title, [Description], Version, ValidFrom, ValidTo FROM Phi_Survey
	WHERE ((ValidFrom IS NULL) OR (ValidFrom >= @Today)) AND ((ValidTo IS NULL) OR (ValidTo < @Today))

END


GO
/****** Object:  StoredProcedure [dbo].[GetSurveyPossibleAnswers]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyPossibleAnswers] 
	@SurveyID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT spa.QuestionID, AnswerID, spa.SeqNo, AnswerLetter, AnswerText
	FROM Phi_SurveyPossibleAnswer AS spa JOIN Phi_SurveyQuestion AS sq ON spa.QuestionID = sq.QuestionID
	WHERE SurveyID = @SurveyID
	ORDER BY spa.SeqNo
END


GO
/****** Object:  StoredProcedure [dbo].[GetSurveyQuestions]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyQuestions] 
	@SurveyID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SubjectID, QuestionID, SeqNo, QuestionText, AnswerType
	FROM Phi_SurveyQuestion
	WHERE SurveyID = @SurveyID
	ORDER BY SeqNo
END


GO
/****** Object:  StoredProcedure [dbo].[GetSurveyResponses]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveyResponses]
@SurveyID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT sr.ResponseID, sr.LastUpdatedOn AS 'Taken on', FullName AS 'Name' , Company, Email, sq.QuestionText AS 'Question', COALESCE(spa.AnswerText, 'No') AS 'Answer'
	FROM Phi_ResponseAnswer AS ra JOIN Phi_SurveyResponse AS sr ON sr.ResponseID = ra.ResponseID
	JOIN Phi_SurveyQuestion AS sq ON ra.QuestionID = sq.QuestionID
	LEFT JOIN Phi_SurveyPossibleAnswer AS spa ON ra.SelectedAnswer = spa.SeqNo AND sq.QuestionID = spa.QuestionID
	WHERE sr.SurveyID = @SurveyID
	ORDER BY sr.ResponseID, sq.QuestionID
END


GO
/****** Object:  StoredProcedure [dbo].[GetSurveySubjects]    Script Date: 5/29/2018 11:52:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetSurveySubjects] 
	@SurveyID INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT SubjectID, Title, Description
	FROM Phi_SurveySubject
	WHERE SurveyID = @SurveyID
	ORDER BY SeqNo
END


GO
