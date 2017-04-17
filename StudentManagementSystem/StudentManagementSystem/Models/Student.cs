using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentManagementSystem.Models
{
    public class Student
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int School_Id { get; set; }
        public int Standard_Id { get; set; }
        public int Section_Id { get; set; }
        public int Roll_No { get; set; }
        public string DOB { get; set; }
        public string Blood_Group { get; set; }
        public string Gender { get; set; }
        public bool Status { get; set; }
        public string Created_by { get; set; }
        public string Created_on { get; set; }
        public string Updated_by { get; set; }
        public string Updated_on { get; set; }

        public string School_Name { get; set; }
        public string Standard_Name { get; set; }
        public string Section_Name { get; set; }
        public string Male { get; set; }
        public string Female { get; set; }
        public int count { get; set; }
    }
}
