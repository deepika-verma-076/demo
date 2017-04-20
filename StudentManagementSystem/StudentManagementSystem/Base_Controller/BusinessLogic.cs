using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.Common;
using System.Data;
using System.IO;
using System.Text.RegularExpressions;
using StudentManagementSystem.Models;

namespace StudentManagementSystem.Base_Controller
{
    public class BusinessLogic
    {
        public static string connectionString = ConfigurationManager.ConnectionStrings["StudentManegment"].ConnectionString;
        SqlConnection con = new SqlConnection(connectionString);
        public string datetime = DateTime.Now.ToString("MM/dd/yyyy hh:mm:ss tt");
        public bool status = true;

        public DataSet bindDropDown()
        {
            SqlCommand cmd = new SqlCommand("GetAllDropDown", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public void saveStudent(Student std)
        {
           // DateTime dt = DateTime.Parse(std.DOB);
            string queryStudent = "Insert into [dbo].[tbl_student] (Name, Roll_No, DOB, Blood_Group, Gender, School_Id, Standard_Id, Section_Id, Status, Created_on) values('"
                + std.Name + "'," + std.Roll_No + ",'" + std.DOB + "','" + std.Blood_Group + "','" + std.Gender + "'," + std.School_Id + "," + std.Standard_Id + ","
                + std.Section_Id + ",'" + status + "','"+ datetime +"'); ";
            SqlConnection con = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(queryStudent, con);
            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            con.Close();
        }

        public void saveSchool(School sch)
        {
            string querySchool = "Insert into [dbo].[tbl_school] (Name, Status, Created_on) values ('"+ sch.Name + "','" + status + "','" + datetime + "'); ";
            SqlConnection con = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(querySchool, con);
            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            con.Close();
        }

        public void saveStandard(Standard stnd)
        {
            string queryStandard = "Insert into [dbo].[tbl_standard] (Name, Status, Created_on) values ('" + stnd.Name + "','" + status + "','" + datetime + "'); ";
            SqlConnection con = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(queryStandard, con);
            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            con.Close();
        }

        public void saveSection(Section sec)
        {
            string querySection = "Insert into [dbo].[tbl_section] (Name, Status, Created_on) values ('" + sec.Name + "','" + status + "','" + datetime + "'); ";
            SqlConnection con = new SqlConnection(connectionString);
            SqlCommand cmd = new SqlCommand(querySection, con);
            con.Open();
            SqlDataReader sdr = cmd.ExecuteReader();
            con.Close();
        }

        public DataSet ViewAllStudentData()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[ViewAllStudents]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public DataSet ViewLink1Data()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Link1]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public DataSet ViewLink2Data()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Link2]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public DataSet ViewLink3Data()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Link3]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public DataSet ViewLink4Data()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Link4]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }

        public DataSet ViewLink5Data()
        {
            SqlCommand cmd = new SqlCommand("[dbo].[Link5]", con);
            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            con.Open();
            DataSet ds = new DataSet();

            try
            {
                cmd.ExecuteNonQuery();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                //Fill the DataSet using default values for DataTable names, etc
                da.Fill(ds);
            }
            catch (Exception ex)
            {

            }
            return ds;
        }
    }
}
