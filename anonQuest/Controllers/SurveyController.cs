using System;
using System.Text;
using System.Net;
using System.Net.Mail;
using System.Web.Mvc;
using anonQuest.Entity;
using PhiMarketing.Models;

namespace PhiMarketing.Controllers
{
    public class SurveyController : Controller
    {
        private SurveyDBEntities db = new SurveyDBEntities();

        [HttpGet]
        public ActionResult FillOut()
        {
            Survey survey = new Survey();
            survey.Init();
            return View(survey);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Submit(Survey survey)
        {
            //LogHelper.Info(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType, "Post action invoked.");
            Survey questions = new Survey();
            questions.Init();
            if (ModelState.IsValid)
            {
                if (SurveyMail(questions, survey))
                {
                    //LogHelper.Info(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType, "Email sent successfully.");
                    bool success = survey.CollectAnswers(questions);
                    if (success)
                        return View("Thankyou", survey);
                }
            }
            return View(questions);
        }

        public ActionResult Thankyou()
        {
            return View();
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool SurveyMail(Survey questions, Survey answers)
        {
            string contactFromAddress = @System.Configuration.ConfigurationManager.AppSettings["ContactFromAddress"];
            string contactBCCAddress = @System.Configuration.ConfigurationManager.AppSettings["ContactBCCAddress"];
            string userName = @System.Configuration.ConfigurationManager.AppSettings["userName"];
            string password = @System.Configuration.ConfigurationManager.AppSettings["password"];
            string host = @System.Configuration.ConfigurationManager.AppSettings["host"];
            int port = Convert.ToInt32(@System.Configuration.ConfigurationManager.AppSettings["port"]);

            UmbracoHelper helper = new UmbracoHelper(UmbracoContext.Current);
            var contactPage = helper.Content(1065);//get contactpage data
            string email = contactPage.contactUsDestinationAddress;//get destination address
            if (string.IsNullOrEmpty(email))
                return false;
            MailMessage mail = new MailMessage();
            mail.To.Add(email);
            mail.From = new MailAddress(contactFromAddress, "Phigenics");
            mail.Bcc.Add(contactBCCAddress);
            mail.Subject = "Survey submitted on " + DateTime.Now.ToString("d");
            try
            {
                string templateBody = RenderViewToString(questions, answers);
                mail.Body = templateBody;
                mail.IsBodyHtml = true;
                var smtp = new SmtpClient();
                smtp.Host = host;
                smtp.Port = port;
                smtp.UseDefaultCredentials = false;
                smtp.EnableSsl = true;
                var credential = new NetworkCredential
                {
                    UserName = userName,
                    Password = password
                };
                smtp.Credentials = credential;
                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                LogHelper.Error(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType, "Mail Sending Error", ex);
                return false;
            }
            return true;
        }

        public static string RenderViewToString(Survey questions, Survey answers)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendFormat("<html><head><title>{0} Submitted</title></head><body><table border='0' cellpadding='10' cellspacing='10' width='100%'>", questions.SurveyTitle);
            sb.AppendFormat("<tr height='20'><td width='20%' height='20' style='font-size:14px; margin-top:10px;'>{0}</td></td><td width='30%' height='20' style='font-size:14px;'><strong>{1}</strong></td></tr>", "Name:", answers.ContactInfo.FullName);
            sb.AppendFormat("<tr height='20'><td width='20%' height='20' style='font-size:14px; margin-top:10px;'>{0}</td></td><td width='30%' height='20' style='font-size:14px;'><strong>{1}</strong></td></tr>", "Company:", answers.ContactInfo.Company);
            sb.AppendFormat("<tr height='20'><td width='20%' height='20' style='font-size:14px; margin-top:10px;'>{0}</td></td><td width='30%' height='20' style='font-size:14px;'><strong>{1}</strong></td></tr>", "Email:", answers.ContactInfo.Email);
            sb.Append("</table><br></br><br></br>");
            int i = 0;
            sb.Append("<table border='0' cellpadding='10' cellspacing='10' width='100%'>");
            sb.Append("<tr height='20'><td width='70%' height='20' style='font-size:14px; margin-top:10px;'><strong>Questions</strong></td><td width='10%' height='20' style='font-size:14px;'></td><td width='30%' height='20' style='font-size:12px; text-align:center; margin-top:10px;'><strong>Answer</strong></td></tr>");
            foreach (Subject subject in questions.Subjects)
            {
                foreach (Question question in subject.Questions)
                {
                    Answer answer = answers.Answers[i++];
                    sb.AppendFormat("<tr height='20'><td width='70%' height='20' style='font-size:14px; margin-top:10px;'>{0}</td><td width='10%' height='20' style='font-size:14px;'></td><td width='30%' height='20' style='font-size:12px; text-align:center; margin-top:10px;'><strong>{1}</strong></td></tr>", question.QuestionText, question.PossibleAnswers[(int)answer.SelectedAnswer - 1].AnswerText);
                }
            }
            sb.AppendFormat("</table></body></html>");
            return sb.ToString();
        }
    }
}