using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StudentManagementSystem.Models
{
    public class School
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool Status { get; set; }
        public string Created_by { get; set; }
        public string Created_on { get; set; }
        public string Updated_by { get; set; }
        public string Updated_on { get; set; }
    }
}
