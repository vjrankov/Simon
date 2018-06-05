using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace AnonQuest.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult About()
        {
            ViewBag.Message = "WARNING! ANKLE GRABBING AREA!!!";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "yoooooo";

            return View();
        }
    }
}