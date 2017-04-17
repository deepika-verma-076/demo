using System;
using System.Collections.Generic;
using System.Linq;
using Excel;
using System.Web;
using System.Web.Mvc;
using StudentManagementSystem.Base_Controller;
using System.Data;
using StudentManagementSystem.Models;
using System.IO;
using System.Data.SqlClient;
using System.Configuration;

namespace StudentManagementSystem.Controllers
{
    public class HomeController : Controller
    {
        BusinessLogic bl = new BusinessLogic();

        public ActionResult Index()
        {
            return View();
        }

        public ActionResult AddStudent()
        {
            /*binding of all dropdown*/
            DataSet ds = new DataSet();
            ds = bl.bindDropDown();
            List<SelectListItem> li1 = new List<SelectListItem>();
            List<SelectListItem> li2 = new List<SelectListItem>();
            List<SelectListItem> li3 = new List<SelectListItem>();

            /*binding school in dropdown*/
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                li1.Add(new SelectListItem { Text = Convert.ToString(dr["Name"]), Value = Convert.ToString(dr["Id"]) });
            }
            ViewBag.School = li1;

            /*binding standart in dropdown*/
            foreach (DataRow dr in ds.Tables[1].Rows)
            {
                li2.Add(new SelectListItem { Text = Convert.ToString(dr["Name"]), Value = Convert.ToString(dr["Id"]) });
            }
            ViewBag.Standard = li2;

            /*binding section in dropdown*/
            foreach (DataRow dr in ds.Tables[2].Rows)
            {
                li3.Add(new SelectListItem { Text = Convert.ToString(dr["Name"]), Value = Convert.ToString(dr["Id"]) });
            }
            ViewBag.Section = li3;

            return PartialView("AddStudentsPartial");
        }

        public ActionResult uploadStudent(Student std)
        {
            bl.saveStudent(std);
            return View("Index");
        }

        public ActionResult AddSchool()
        {
            return PartialView("AddSchoolPartial");
        }

        public ActionResult UploadSchool(School sch)
        {
            bl.saveSchool(sch);
            return View("Index");
        }

        public ActionResult AddStandard()
        {
            return PartialView("AddStandardPartial");
        }

        public ActionResult UploadStandard(Standard stnd)
        {
            bl.saveStandard(stnd);
            return View("Index");
        }

        public ActionResult AddSection()
        {
            return PartialView("AddSectionPartial");
        }

        public ActionResult UploadSection(Section sec)
        {
            bl.saveSection(sec);
            return View("Index");
        }

        public ActionResult BlukUpload()
        {
            return View("ExcelImport");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Index(HttpPostedFileBase uploadfile)
        {
            if (ModelState.IsValid)
            {
                if (uploadfile != null && uploadfile.ContentLength > 0)
                {
                    //ExcelDataReader works on binary excel file
                    Stream stream = uploadfile.InputStream;
                    //We need to written the Interface.
                    IExcelDataReader reader = null;
                    if (uploadfile.FileName.EndsWith(".xls"))
                    {
                        //reads the excel file with .xls extension
                        reader = ExcelReaderFactory.CreateBinaryReader(stream);
                    }
                    else if (uploadfile.FileName.EndsWith(".xlsx"))
                    {
                        //reads excel file with .xlsx extension
                        reader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    }
                    else
                    {
                        //Shows error if uploaded file is not Excel file
                        ModelState.AddModelError("File", "This file format is not supported");
                        return View();
                    }
                    //treats the first row of excel file as Coluymn Names
                    reader.IsFirstRowAsColumnNames = true;
                    //Adding reader data to DataSet()
                    System.Data.DataSet result = reader.AsDataSet();
                    reader.Close();


                    string consString = ConfigurationManager.ConnectionStrings["StudentManegment"].ConnectionString;

                    using (SqlConnection con = new SqlConnection(consString))
                    {
                        using (SqlBulkCopy sqlBulkCopy = new SqlBulkCopy(con))
                        {
                            //Set the database table name
                            sqlBulkCopy.DestinationTableName = "tbl_student_temp";

                            // Map the Excel columns with that of the database table
                            sqlBulkCopy.ColumnMappings.Add("Roll Number", "Roll_No");
                            sqlBulkCopy.ColumnMappings.Add("Student Name", "Name");
                            sqlBulkCopy.ColumnMappings.Add("Blood Group", "Blood_Group");
                            sqlBulkCopy.ColumnMappings.Add("Date of Birth", "DOB");
                            sqlBulkCopy.ColumnMappings.Add("Gender", "Gender");
                            sqlBulkCopy.ColumnMappings.Add("School Name", "School_Name");
                            sqlBulkCopy.ColumnMappings.Add("Standard Name", "Standard_Name");
                            sqlBulkCopy.ColumnMappings.Add("Section Name", "Section_Name");

                            con.Open();
                            sqlBulkCopy.WriteToServer(result.Tables[0]);
                            con.Close();
                            SqlCommand cmd1 = new SqlCommand("[dbo].[BulkUpload]", con);
                            cmd1.CommandType = System.Data.CommandType.StoredProcedure;
                            con.Open();
                            cmd1.ExecuteNonQuery();
                            con.Close();
                        }
                    }

                    return View();
                }
            }
            else
            {
                ModelState.AddModelError("File", "Please upload your file");
            }
            return View();
        }

        public ActionResult ViewStudent()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewAllStudentData();           
            var li = new List<Student>();
            int n=1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;
                std.Name = Convert.ToString(dr["Name"]);
                //std.Roll_No = Convert.ToInt32(dr["Roll_No"]);
                var s = Convert.ToString(dr["Roll_No"]);
                if (s.Equals(""))
                {
                    std.Roll_No = 0;
                }
                else
                {
                    std.Roll_No = Convert.ToInt32(s);
                }
                std.DOB = Convert.ToString(dr["DOB"]);
                std.Blood_Group = Convert.ToString(dr["Blood_Group"]);
                std.Gender = Convert.ToString(dr["Gender"]);
                std.School_Name = Convert.ToString(dr["School_Name"]);
                std.Standard_Name = Convert.ToString(dr["Standard_Name"]);
                std.Section_Name = Convert.ToString(dr["Section_Name"]);
                li.Add(std);
            }
            ViewBag.Student = li;

            return  PartialView("ViewStudentsPartial");
        }

        public ActionResult ViewLink1()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewLink1Data();
            var li = new List<Student>();
            int n = 1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;
                std.Name = Convert.ToString(dr["Name"]);
                //std.Roll_No = Convert.ToInt32(dr["Roll_No"]);
                var s = Convert.ToString(dr["Roll_No"]);
                if (s.Equals(""))
                {
                    std.Roll_No = 0;
                }
                else
                {
                    std.Roll_No = Convert.ToInt32(s);
                }
                std.DOB = Convert.ToString(dr["DOB"]);
                std.Blood_Group = Convert.ToString(dr["Blood_Group"]);
                std.Gender = Convert.ToString(dr["Gender"]);
                std.Standard_Name = Convert.ToString(dr["Standard_Name"]);
                std.School_Name = Convert.ToString(dr["School_Name"]);               
                li.Add(std);
            }
            ViewBag.Link1 = li;

            return PartialView("ViewLink1Partial");
        }

        public ActionResult ViewLink2()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewLink2Data();
            var li = new List<Student>();
            int n = 1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();

                var s = Convert.ToString(dr["count"]);
                if (s.Equals(""))
                {
                    std.count = 0;
                }
                else
                {
                    std.count = Convert.ToInt32(s);
                }          

                li.Add(std);
            }
            ViewBag.Link2 = li;

            return PartialView("ViewLink2Partial");
        }

        public ActionResult ViewLink3()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewLink3Data();
            var li = new List<Student>();
            int n = 1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;
                std.Name = Convert.ToString(dr["Name"]);
                //std.Roll_No = Convert.ToInt32(dr["Roll_No"]);
                var s = Convert.ToString(dr["Roll_No"]);
                if (s.Equals(""))
                {
                    std.Roll_No = 0;
                }
                else
                {
                    std.Roll_No = Convert.ToInt32(s);
                }
                std.DOB = Convert.ToString(dr["DOB"]);
                std.Blood_Group = Convert.ToString(dr["Blood_Group"]);
                std.Gender = Convert.ToString(dr["Gender"]);
                std.School_Name = Convert.ToString(dr["School_Name"]);
                std.Standard_Name = Convert.ToString(dr["Standard_Name"]);
                std.Section_Name = Convert.ToString(dr["Section_Name"]);
                li.Add(std);
            }
            ViewBag.Link3 = li;

            return PartialView("ViewLink3Partial");
        }

        public ActionResult ViewLink4()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewLink4Data();
            var li = new List<Student>();
            int n = 1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;
                std.Name = Convert.ToString(dr["Name"]);
                //std.Roll_No = Convert.ToInt32(dr["Roll_No"]);
                var s = Convert.ToString(dr["Roll_No"]);
                if (s.Equals(""))
                {
                    std.Roll_No = 0;
                }
                else
                {
                    std.Roll_No = Convert.ToInt32(s);
                }
                std.DOB = Convert.ToString(dr["DOB"]);
                std.Blood_Group = Convert.ToString(dr["Blood_Group"]);
                std.Gender = Convert.ToString(dr["Gender"]);
                std.School_Name = Convert.ToString(dr["School_Name"]);
                std.Standard_Name = Convert.ToString(dr["Standard_Name"]);
                std.Section_Name = Convert.ToString(dr["Section_Name"]);
                li.Add(std);
            }
            ViewBag.Link4 = li;

            return PartialView("ViewLink4Partial");
        }

        public ActionResult ViewLink5()
        {
            DataSet ds = new DataSet();
            ds = bl.ViewLink5Data();
            var li = new List<Student>();
            int n = 1;

            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;

                std.Male = Convert.ToString(dr["Male"]);
                std.Female = Convert.ToString(dr["Female"]);
                std.School_Name = Convert.ToString(dr["School_Name"]);
                std.Standard_Name = Convert.ToString(dr["Standard_Name"]);
                li.Add(std);
            }
            ViewBag.Link5 = li;

            return PartialView("ViewLink5Partial");
        }

        [HttpPost]
        public JsonResult CheckRoll(int school_id, int standard_id, int section_id, int roll_no)
        {
            //Note : you can bind same list from database  

            DataSet ds = new DataSet();
            ds = bl.ViewAllStudentData();
            var li = new List<Student>();
            int n = 0;


            
            foreach (DataRow dr in ds.Tables[0].Rows)
            {
                Student std = new Student();
                std.Id = n++;
                std.Name = Convert.ToString(dr["Name"]);
                //std.Roll_No = Convert.ToInt32(dr["Roll_No"]);
                var s = Convert.ToString(dr["Roll_No"]);
                if (s.Equals(""))
                {
                    std.Roll_No = 0;
                }
                else
                {
                    std.Roll_No = Convert.ToInt32(s);
                }
                std.DOB = Convert.ToString(dr["DOB"]);
                std.Blood_Group = Convert.ToString(dr["Blood_Group"]);
                std.Gender = Convert.ToString(dr["Gender"]);
                //std.School_Id = Convert.ToInt32(dr["School_Id"]);
                var s1 = Convert.ToString(dr["School_Id"]);
                if (s1.Equals(""))
                {
                    std.School_Id = 0;
                }
                else
                {
                    std.School_Id = Convert.ToInt32(s1);
                }
                //std.Standard_Id = Convert.ToInt32(dr["Standard_Id"]);

                var s2 = Convert.ToString(dr["Standard_Id"]);
                if (s2.Equals(""))
                {
                    std.Standard_Id = 0;
                }
                else
                {
                    std.Standard_Id = Convert.ToInt32(s2);
                }
                //std.Section_Id = Convert.ToInt32(dr["Section_Id"]);

                var s3 = Convert.ToString(dr["Section_Id"]);
                if (s3.Equals(""))
                {
                    std.Section_Id = 0;
                }
                else
                {
                    std.Section_Id = Convert.ToInt32(s3);
                }
                li.Add(std);
            }
            
            int roll_count = li.Where(f => f.School_Id == school_id && f.Standard_Id == standard_id && f.Section_Id == section_id && f.Roll_No == roll_no).Count();
            //ViewBag.Student = li;

            var msg = "";
            if (roll_count == 0)
            {
                msg = "Available";
            }
            else
            {
                msg = "Already Exist";
            }

            //Searching records from list using LINQ query  
           
            return Json(msg, JsonRequestBehavior.AllowGet);
        }

    }
}